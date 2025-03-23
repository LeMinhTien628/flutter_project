import 'package:flutter/material.dart';

import 'package:app_food_delivery/constants/app_colors.dart';

class PromotionListScreen extends StatefulWidget {
  const PromotionListScreen({super.key});

  @override
  State<PromotionListScreen> createState() => _PromotionListScreenState();
}

class _PromotionListScreenState extends State<PromotionListScreen> {
  //Danh sách khuyến mãi Model khuyến mãi
  List<String> promotionNames = [
    "70% OFF ON 2ND PIZZA",
    "BOGO MONTH YUMMYGO'LOTTE MARIO ONLINE",
    "BUY 1 GET 3 SEAFOOD PIZZA",
    "CARRY OUT 50% OFF",
    "[FAMILY COMBO] JOYFUL PARTY JUST ONE MONTH",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0),
      child: Column(
        children: [
          //Khuyến mãi chính
          Container(
            padding: EdgeInsets.all(4),
            margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                width: 2,
                color: AppColors.backgroudGreyBland
              )
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  width: 300,
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(
                      "assets/images/promotion_main.png",
                      fit: BoxFit.fill
                    ),
                  )
                ),
                //Tên khuyến mãi chính
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                  padding: EdgeInsets.only(right: 8, left: 8),
                  child: Text(
                    "Buy 2 GET 3".toUpperCase(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),

          //Danh sách khuyến mãi
          Container(
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2/3,
              ), 
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: promotionNames.length,
              itemBuilder: (context, index){
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      width: 2,
                      color: AppColors.backgroudGreyBland
                    )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            "assets/images/promotion_main.png",
                            height: 110,
                            fit: BoxFit.fill
                          ),
                        )
                      ),
                      //Tên khuyến mãi chính
                      Container(
                        padding: EdgeInsets.only(right: 8, left: 8),
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          promotionNames[index].toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}