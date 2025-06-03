using System;
using System.Collections.Generic;
using System.Linq;
using Accord.MachineLearning.Rules;
using api_app_pizza_flutter.Data;
using api_app_pizza_flutter.Service;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Mvc;
using api_app_pizza_flutter.Models;

public class RecommendationService : IRecommendationService
{
    private readonly AssociationRuleMatcher<int> _ruleMatcher;

    public RecommendationService(AppOrderDbContext db)
    {
        // 1. Load toàn bộ giao dịch từ OrderDetails  
        var transactions = db.OrderDetails
            .AsNoTracking()
            .GroupBy(od => od.OrderId)
            .AsEnumerable() // Switch to client-side evaluation
            .Select(g => g.Select(od => od.ProductId).Distinct().ToArray())
            .Where(arr => arr.Length > 1)
            .ToArray();

        // 2. Học luật Apriori (support 1%, confidence 50%)  
        var apriori = new Apriori<int>(threshold: (int)0.01, confidence: 0.5);
        _ruleMatcher = apriori.Learn(transactions);
    }

    public List<int> Recommend(int productId, int topN = 5)
    {
        return _ruleMatcher.Rules
            .Where(r => r.X.Contains(productId))
            .OrderByDescending(r => r.Confidence)
            .SelectMany(r => r.Y) 
            .Where(id => id != productId)
            .Distinct()
            .Take(topN)
            .ToList();
    }
}
