using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using api_app_pizza_flutter.Data;
using api_app_pizza_flutter.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using MathNet.Numerics.Distributions;
using Accord.Statistics.Testing;
using Accord.Statistics.Distributions.Univariate;
namespace api_app_pizza_flutter.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RankingsController : ControllerBase
    {
        private readonly AppOrderDbContext _context;

        public RankingsController(AppOrderDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public IActionResult GetRankings(string period = "Weekly")
        {
            try
            {
                // Bước 1: Lấy đánh giá cho các sản phẩm pizza (CategoryId = 1)
                var ratingsData = _context.Feedbacks
                    .Join(_context.Products,
                        f => f.ProductId,
                        p => p.ProductId,
                        (f, p) => new { f.ProductId, p.ProductName, f.OverallTasteRating, p.CategoryId })
                    .Where(x => x.CategoryId == 1)
                    .ToList();

                // Sử dụng lớp GroupedRating để lưu trữ dữ liệu nhóm
                var groupedRatings = ratingsData
                    .GroupBy(x => new { x.ProductId, x.ProductName })
                    .Select(g => new GroupedRating
                    {
                        ProductId = g.Key.ProductId,
                        ProductName = g.Key.ProductName,
                        Ratings = g.Select(x => (double)x.OverallTasteRating).ToList(),
                        RatingCount = g.Count(),
                        AverageRating = g.Average(x => x.OverallTasteRating)
                    })
                    .Where(x => x.RatingCount >= 5) // Yêu cầu ít nhất 5 đánh giá
                    .ToList();

                if (!groupedRatings.Any())
                {
                    return NotFound("Không tìm thấy sản phẩm pizza nào có đủ số lượng đánh giá.");
                }

                // Bước 2: Thực hiện ANOVA
                var anovaResult = PerformAnova(groupedRatings);

                // Bước 3: Xếp hạng pizza theo điểm trung bình
                var rankings = groupedRatings
                    .OrderByDescending(x => x.AverageRating)
                    .Select((x, index) => new Ranking
                    {
                        ProductId = x.ProductId,
                        AverageRating = (decimal)x.AverageRating, // Đảm bảo kiểu decimal khớp với mô hình
                        RankPosition = index + 1,
                        Period = period,
                        CreatedDate = DateTime.UtcNow
                    })
                    .ToList();

                // Bước 4: Xóa các xếp hạng hiện có cho khoảng thời gian này
                DateTime cutoffDate;
                if (period=="Weekly")
                {
                    cutoffDate = DateTime.UtcNow.AddDays(-7);//xóa dữ liệu tuần trước
                }
                else if (period == "Monthly")
                {
                    cutoffDate = DateTime.UtcNow.AddMonths(-1);//xóa dữ liệu tháng trước
                }
                else
                {
                    return BadRequest("Chu kỳ không hợp lệ. Vui lòng sử dụng 'Weekly' hoặc 'Monthly'.");
                }
                var existingRankings = _context.Rankings
                    .Where(r => r.Period == period && r.CreatedDate < cutoffDate)
                    .ToList();
                _context.Rankings.RemoveRange(existingRankings);

                // Bước 5: Lưu xếp hạng mới
                _context.Rankings.AddRange(rankings);
                _context.SaveChanges();

                // Bước 6: Chuẩn bị phản hồi
                var response = rankings
                    .Join(_context.Products,
                        r => r.ProductId,
                        p => p.ProductId,
                        (r, p) => new
                        {
                            r.ProductId,
                            p.ProductName,
                            r.AverageRating,
                            r.RankPosition,
                            r.Period,
                            CreatedDate = r.CreatedDate.ToString("yyyy-MM-dd")
                        })
                    .OrderBy(r => r.RankPosition)
                    .ToList();

                return Ok(new
                {
                    AnovaFStatistic = anovaResult.FStatistic,
                    AnovaPValueApproximation = anovaResult.PValueApproximation,
                    SignificantDifference = anovaResult.PValueApproximation < 0.05,
                    Rankings = response
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Lỗi máy chủ nội bộ: {ex.Message}");
            }
        }

        private (double FStatistic, double PValueApproximation) PerformAnova(List<GroupedRating> groupedRatings)
        {
            // Bước 1: Tính trung bình tổng thể
            var allRatings = groupedRatings.SelectMany(g => g.Ratings).ToList();
            if (!allRatings.Any())
            {
                throw new InvalidOperationException("Không có đánh giá nào để tính toán ANOVA.");
            }

            double overallMean = allRatings.Average();
            int totalN = allRatings.Count;
            int k = groupedRatings.Count; // Số nhóm

            // Bước 2: Tính Tổng bình phương giữa các nhóm (SSB)
            double ssb = 0;
            foreach (var group in groupedRatings)
            {
                double groupMean = group.AverageRating;
                int groupSize = group.RatingCount;
                ssb += groupSize * Math.Pow(groupMean - overallMean, 2);
            }

            // Bước 3: Tính Tổng bình phương trong nhóm (SSW)
            double ssw = 0;
            foreach (var group in groupedRatings)
            {
                double groupMean = group.AverageRating;
                foreach (var rating in group.Ratings)
                {
                    ssw += Math.Pow(rating - groupMean, 2);
                }
            }

            // Bước 4: Tính bậc tự do
            int dfBetween = k - 1;
            int dfWithin = totalN - k;

            if (dfBetween <= 0 || dfWithin <= 0)
            {
                throw new InvalidOperationException("Không đủ dữ liệu để thực hiện ANOVA (bậc tự do không hợp lệ).");
            }

            // Bước 5: Tính Trung bình bình phương
            double msb = ssb / dfBetween;
            double msw = ssw / dfWithin;

            // Bước 6: Tính F-statistic
            double fStatistic = msb / msw;

            // Kiểm tra giá trị F-statistic
            if (double.IsNaN(fStatistic) || double.IsInfinity(fStatistic))
            {
                throw new InvalidOperationException("Kết quả F-statistic không hợp lệ.");
            }

            // Bước 7: Tính p-value chính xác bằng MathNet.Numerics
            var fDistribution = new FDistribution(dfBetween, dfWithin);
            double pValue = 1 - fDistribution.DistributionFunction(fStatistic);

            return (fStatistic, pValue);
        }
    }
}