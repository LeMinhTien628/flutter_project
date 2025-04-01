  import 'package:app_food_delivery/constants/app_colors.dart';
  import 'package:app_food_delivery/screens/cart/cart_sub.dart';
import 'package:app_food_delivery/screens/menu/categories_list_product.dart';
import 'package:app_food_delivery/screens/menu/categories_main.dart';
  import 'package:app_food_delivery/screens/promotion/e_voucher_screen.dart';
  import 'package:app_food_delivery/screens/promotion/promotion_list_screen.dart';
  import 'package:flutter/material.dart';

  class MenuScreen extends StatefulWidget {
    const MenuScreen({super.key});

    @override
    State<MenuScreen> createState() => _MenuScreenState();
  }

  class _MenuScreenState extends State<MenuScreen> {

    int selectedButton = 1; //  chọn ô promotion mặc định

    int qualityCart = 10;
    
    //Trạng thái Promotion - E-voucher
    void onToggleButton(int buttonIndex){
      setState(() {
        selectedButton = buttonIndex;
      });
    }
    @override
    Widget build(BuildContext context) {
      return SafeArea(
        child: Container(
          child: Column(
            children: [
               // Button Delivery - Carry Out
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 128,
                      margin: EdgeInsets.only(top: 4),
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              bottomLeft: Radius.circular(4)
                            ),
                            border: Border.all(
                              width: 1,
                              color: AppColors.border
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: Offset(1, 1),
                                blurRadius: 1,
                                spreadRadius: 1,
                              )
                            ]
                          ),
                          child: Text(
                            selectedButton == 1 ? "Choose Address" : "Please Select Store",
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textPrimary
                            ),    
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 16),
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
                                duration: Duration(milliseconds: 300),
                                curve: Curves.bounceInOut, // vào chậm – bật ra nhanh – rồi nảy nhẹ
                                padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                                decoration: BoxDecoration(
                                  color: selectedButton == 1 ? AppColors.buttonPrimary : AppColors.backgroudGreyBland,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  "Delivery",
                                  style: TextStyle(
                                    color: selectedButton == 1 ?Colors.white : AppColors.textSecondary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap:()=>onToggleButton(0),
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                                decoration: BoxDecoration(
                                  color: selectedButton == 0 ? AppColors.buttonPrimary : AppColors.backgroudGreyBland,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  "Carry Out",
                                  style: TextStyle(
                                    color: selectedButton == 0 ?Colors.white : AppColors.textSecondary,
                                    fontSize: 11,
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
                  ],
                ),
              ),
              
              Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroudGreyBland
                ),
                child: CategoriesMain(),
              ),

              //Nội dung          
              Flexible(
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        color: AppColors.backgroudGreyBland
                      ),
                      child: CategoriesListProduct(),
                    ),
                    //Giỏ hàng
                    CartSub()
                  ],
                )
              )
            
            ],
          ),
        )
      );
    }
  }