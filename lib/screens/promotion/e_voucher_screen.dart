import 'package:flutter/material.dart';

import 'package:app_food_delivery/core/constants/app_colors.dart';

class EVoucherScreen extends StatefulWidget {
  const EVoucherScreen({super.key});

  @override
  State<EVoucherScreen> createState() => _EVoucherScreenState();
}

class _EVoucherScreenState extends State<EVoucherScreen> {
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
   return Container(
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              "Do you have E-Voucher Code At YummyGo",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              "Enter Your E-Voucher Code In The Box Below To Recevie The Offer",
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 9,
              ),
            ),
          ),
          GestureDetector(
            onTap:() {
              _focusNode.unfocus();
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              height: 36,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          bottomLeft: Radius.circular(4)
                        ),
                        border: Border.all(
                          width: 1,
                          color: AppColors.border
                        )
                      ),
                      child: TextField(
                        onChanged: (value) {
                          //Lấy mã để so sánh khi người dùng nhập
                          print("$value");
                        },
                        showCursor: true,
                        cursorColor: AppColors.primary,
                        cursorRadius: Radius.circular(10),
                        cursorHeight: 14,
                        cursorWidth: 2,
                        cursorOpacityAnimates: true, // Con trỏ sẽ nhấp nháy với hiệu ứng mờ dần
                        cursorErrorColor: AppColors.error,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter E-Voucher Code",
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textPrimary
                        ),
                      ),
                    )
                    
                    
                  ),
                  Container(
                    child: TextButton(
                      onPressed: (){}, 
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(2),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(4),
                            bottomRight: Radius.circular(4)
                          )
                        )
                      ),
                      child: Text(
                        "Apply",
                        style: TextStyle(
                          color: AppColors.background,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ),
                  )
                ],
              ),
            ),
          ),
          
          Container(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: (){}, 
              style: TextButton.styleFrom(
                backgroundColor: AppColors.background,
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                side: BorderSide(
                  color: AppColors.border,
                  width: 1
                )
              ),
              child: Text(
                "Sign In To Get More Offers",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold
                ),
              )
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 90),
            alignment: Alignment.bottomLeft,
            child: Image.asset(
              "assets/images/yummygo_logo.png",
              width: 100,
              height: 100,
              fit: BoxFit.fill
            ),
          ),
        ],
      ),
    );
  }
}