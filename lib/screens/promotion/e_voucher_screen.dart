import 'package:flutter/material.dart';

import 'package:app_food_delivery/constants/app_colors.dart';

class EVoucherScreen extends StatefulWidget {
  const EVoucherScreen({super.key});

  @override
  State<EVoucherScreen> createState() => _EVoucherScreenState();
}

class _EVoucherScreenState extends State<EVoucherScreen> {
  
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

          //
          
        ],
      ),
    );
  }
}