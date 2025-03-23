import 'package:app_food_delivery/constants/app_colors.dart';
import 'package:app_food_delivery/screens/promotion/e_voucher_screen.dart';
import 'package:app_food_delivery/screens/promotion/promotion_list_screen.dart';
import 'package:flutter/material.dart';

class PromotionScreen extends StatefulWidget {
  const PromotionScreen({super.key});

  @override
  State<PromotionScreen> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
   int selectedButton = 1; //  chọn ô promotion mặc định
  //Trạng thái Promotion - E-voucher
  void onToggleButton(int buttonIndex){
    setState(() {
      selectedButton = buttonIndex;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(0),
          physics: BouncingScrollPhysics(),
          reverse: false,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.background
            ),
            margin: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Button Delivery - Carry Out
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroudGreyBland,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(1, 1),
                          blurRadius: 1,
                          spreadRadius: 1,
                        )
                      ]
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: ()=>onToggleButton(1),
                          child: AnimatedContainer(
                            width: 120,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.bounceInOut, // vào chậm – bật ra nhanh – rồi nảy nhẹ
                            padding: EdgeInsets.fromLTRB(24, 6, 24, 6),
                            decoration: BoxDecoration(
                              color: selectedButton == 1 ? AppColors.buttonPrimary : AppColors.backgroudGreyBland,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "Promotion",
                              style: TextStyle(
                                color: selectedButton == 1 ?Colors.white : AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap:()=>onToggleButton(0),
                          child: AnimatedContainer(
                            width: 120,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            padding: EdgeInsets.fromLTRB(24, 6, 24, 6),
                            decoration: BoxDecoration(
                              color: selectedButton == 0 ? AppColors.buttonPrimary : AppColors.backgroudGreyBland,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "E-voucher",
                              style: TextStyle(
                                color: selectedButton == 0 ?Colors.white : AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                //Đường phân cách
                Container(
                  height: 1,
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.backgroudGreyBland
                  ),
                ),
                
                selectedButton == 1 ? PromotionListScreen() : EVoucherScreen()
              ],
            ),
          ),
        )
      )
    );
  }
}