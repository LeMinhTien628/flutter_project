import 'package:app_food_delivery/constants/app_colors.dart';
import 'package:app_food_delivery/constants/app_strings.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int quanlityCart = 0;
  bool isButtonLanguage = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          top: 46,
          child: Container(
            margin: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(color: AppColors.backgroudGreyBland),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    clipBehavior: Clip.none,
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        color: AppColors.backgroudGreyBland,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                            decoration: BoxDecoration(color: Colors.white),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          "Đơn Hàng Của Số Điện Thoại",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          "0345088996",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: AppColors.textPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    "Thay Đổi",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          quanlityCart == 0 ? buidNoCart() : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Header
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 66,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(width: 1, color: AppColors.border),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    print("Quay lại trang trước");
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 24, left: 8),
                    child: Icon(Icons.chevron_left),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 24),
                  child: Text(
                    "Theo Dõi Đơn Hàng",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                Opacity(
                  opacity: 0.0,
                  child: Container(child: Icon(Icons.chevron_left)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSeparate() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      height: 2,
      decoration: BoxDecoration(color: AppColors.backgroudGreyBland),
    );
  }

  Widget buidNoCart() {
    return Container(
      child: Column(
        children: [
          Container(
            child: Image.asset(
              "assets/images/no_cart.png",
              width: 200,
              height: 200,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            child: Text(
              "Bạn Hiện Chưa Có Đơn Hàng Nào!",
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Container(
            height: 32,
            margin: EdgeInsets.only(top: 20),
            child: TextButton(
              onPressed: () {
                print("Di chuyển đến menu");
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.buttonPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              ),
              child: Text(
                "Đặt Hàng Ngay",
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
