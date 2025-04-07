import 'package:app_food_delivery/core/constants/app_colors.dart';
import 'package:app_food_delivery/core/constants/app_strings.dart';
import 'package:app_food_delivery/screens/product/product_detail_screen.dart';
import 'package:app_food_delivery/core/utils/format_utils.dart';
import 'package:flutter/material.dart';


class BestSeller extends StatelessWidget {
  BestSeller({super.key});
  //Danh sách best seller
  List<String> name = [
    "Seafood Four Seasons",
    "American Cheeseburger",
    "Cheesy Madness",
    "Super Topping Surf And Turf"
  ];
  List<int> price = [
    325000, 205000, 175000, 235000,
  ];

  //Chuyển đổi tiền
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 184,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: name.length,
        itemBuilder: (context, index){
          return GestureDetector(
            onTap: (){
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => ProductDetailScreen()),
              );
            },
            onDoubleTap: (){
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => ProductDetailScreen()),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6)
              ),
              width: 120,
              margin: EdgeInsets.only(left: 16),
              child: Column(
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6)
                      ),
                      child: Image.asset(
                        "assets/images/pizza.png",
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                    )
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    child: Text(
                      name[index],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary
                      ),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(top: 4, bottom: 6),
                    child: Text(
                      FormatUtils.formattedPrice(price[index]) + AppStrings.tienTe,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}