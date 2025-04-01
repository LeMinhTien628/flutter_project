import 'package:app_food_delivery/constants/app_colors.dart';
import 'package:app_food_delivery/constants/app_strings.dart';
import 'package:app_food_delivery/screens/detail/detail_product.dart';
import 'package:app_food_delivery/utils/format_utils.dart';
import 'package:flutter/material.dart';

class CategoriesListProduct extends StatefulWidget {
  const CategoriesListProduct({super.key});

  @override
  State<CategoriesListProduct> createState() => _CategoriesListProductState();
}

class _CategoriesListProductState extends State<CategoriesListProduct> {
  List<String> currentListProduct = [
    "Pizza",
    "Burger",
    "Pasta",
    "Sushi"
  ];

  bool isLike = false;
  void isCheckLike(){
    setState(() {
      if(isLike){
        isLike = false;
      }
      else{
        isLike = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        //itemCount: currentListProduct.length,
        itemCount: 10,
        itemBuilder: (context, index) {
          return buildProductItem(context, index);
        },
      ),
    );
  }

  Widget buildProductItem(BuildContext context, int index) {
    return GestureDetector(
      onTap:() {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => DetailProduct()),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.background
        ),
        child: Stack(
          children: [
            Positioned(
              child: Transform.translate(
                offset: Offset(-82, 0),
                child: Container(
                  child: Image.asset(
                    "assets/images/product_rbg.png",
                    height: 110,
                    width: 218,
                    fit: BoxFit.fitWidth,
                  ),
                )
              ),
            ),
            Positioned(
              left: 98,
              bottom: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 150,
                          margin: EdgeInsets.only(top: 0),
                          child: Text(
                            "Super Topping Seafood Four",
                            maxLines: 2,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 16, top: 2),
                          width: 150,
                          child: Text(
                            "Extra protein toppings by 50% Tail-on Shrimp, Squid Ring; Extr Mozzarella Cheese, Lime Pesto Sauce",
                            style: TextStyle(
                              fontSize: 9,
                              color: AppColors.textSecondary
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          margin: EdgeInsets.only(top: 0),
                          width: 150,
                          child: Text(
                            FormatUtils.formattedPrice(355000) + AppStrings.tienTe,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 0),
                    height: 110,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          child: GestureDetector(
                            onTap: (){
                              isCheckLike();
                            },
                            child: Image.asset(
                              "assets/icons/heart.png",
                              width: 18,
                              height: 18,
                              fit: BoxFit.fill,
                              color: isLike ? AppColors.heart : AppColors.backgroudGreyBland,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 6),
                          child: GestureDetector(
                            onTap: (){

                            },
                            child:  Image.asset(
                              "assets/icons/add_cart.png",
                              width: 24,
                              height: 24,
                              fit: BoxFit.fill,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
