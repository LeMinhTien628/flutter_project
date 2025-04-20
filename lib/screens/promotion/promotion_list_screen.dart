import 'package:flutter/material.dart';
import 'package:app_food_delivery/api/promotion_service.dart';
import 'package:app_food_delivery/models/promotion_model.dart';
import 'package:app_food_delivery/core/constants/app_colors.dart';

class PromotionListScreen extends StatefulWidget {
  const PromotionListScreen({super.key});

  @override
  State<PromotionListScreen> createState() => _PromotionListScreenState();
}

class _PromotionListScreenState extends State<PromotionListScreen> {
  final PromotionService _promotionService = PromotionService();
  late Future<List<PromotionModel>> _promotionsFuture;

  @override
  void initState() {
    super.initState();
    _promotionsFuture = _promotionService.getPromotions();
  }

  Future<void> _refreshPromotions() async {
    setState(() {
      _promotionsFuture = _promotionService.getPromotions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Khuyến mãi chính
          Container(
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(width: 2, color: AppColors.backgroudGreyBland),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(
                      "assets/images/promotion_main.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 16),
                  padding: const EdgeInsets.only(right: 8, left: 8),
                  child: const Text(
                    "MUA 2 TẶNG 3",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Danh sách khuyến mãi từ API
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: FutureBuilder<List<PromotionModel>>(
              future: _promotionsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      children: [
                        Text('Lỗi: ${snapshot.error}'),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _refreshPromotions,
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Không tìm thấy khuyến mãi'));
                }

                final promotions = snapshot.data!;
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2 / 3,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: promotions.length,
                  itemBuilder: (context, index) {
                    final promotion = promotions[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          width: 2,
                          color: AppColors.backgroudGreyBland,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 110,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                "assets/images/promotion_main.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(right: 8, left: 8),
                            margin: const EdgeInsets.only(top: 10),
                            child: Text(
                              promotion.promotionName.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(right: 8, left: 8),
                            child: Text(
                              'Giảm: ${promotion.discountPercentage}%',
                              style: const TextStyle(fontSize: 10, color: Colors.green),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}