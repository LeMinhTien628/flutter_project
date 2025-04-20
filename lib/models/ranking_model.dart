// RankingModel: Chức năng xếp hạng sản phẩm theo đánh giá.
class RankingModel {
  final int rankingId; // ID xếp hạng, khóa chính.
  final int productId; // ID sản phẩm, liên kết với Products.
  final double averageRating; // Điểm đánh giá trung bình, từ 0-5.
  final int rankPosition; // Vị trí xếp hạng, hiển thị thứ tự.
  final String period; // Chu kỳ xếp hạng (Weekly, Monthly).
  final DateTime createdDate; // Ngày tạo xếp hạng, theo dõi thời gian.

  RankingModel({
    required this.rankingId,
    required this.productId,
    required this.averageRating,
    required this.rankPosition,
    required this.period,
    required this.createdDate,
  });

  factory RankingModel.fromJson(Map<String, dynamic> json) {
    return RankingModel(
      rankingId: json['RankingID'] as int,
      productId: json['ProductID'] as int,
      averageRating: (json['AverageRating'] as num).toDouble(),
      rankPosition: json['RankPosition'] as int,
      period: json['Period'] as String,
      createdDate: DateTime.parse(json['CreatedDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'RankingID': rankingId,
      'ProductID': productId,
      'AverageRating': averageRating,
      'RankPosition': rankPosition,
      'Period': period,
      'CreatedDate': createdDate.toIso8601String(),
    };
  }
}