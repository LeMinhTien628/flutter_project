import 'package:app_food_delivery/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CategoriesSub extends StatefulWidget {
  final int selectedItem;

  const CategoriesSub({
    Key? key,
    required this.selectedItem,
  }) : super(key: key);

  @override
  _CategoriesSubState createState() => _CategoriesSubState();
}

class _CategoriesSubState extends State<CategoriesSub> {
  int selectItemSub = 0;

  final List<String> categoriesSubPizzaName = [
    "SUPER TOPPING", "SEAFOOD CRAVERS", "KID FAVORS", "TRADITIONAL & MEAT LOVERS"
  ];
  final List<String> categoriesAppetizerName = [
    "SAUSAGE", "BREAD", "POTATO"
  ];

  //Lấy danh sách sản phẩm từ API theo category

  //Lọc theo category sub từ category chính

  @override
  Widget build(BuildContext context) {
    List<String> currentCategories = [];
    bool isVisibility = false;
    if (widget.selectedItem == 0) {
      currentCategories = categoriesSubPizzaName;
      isVisibility = true;
    } else if (widget.selectedItem == 3) {
      currentCategories = categoriesAppetizerName;
      isVisibility = true;
    }

    return Visibility(
      visible: isVisibility,
      child: Stack(
        children: [
          Container(
            height: 36,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border.all(
                width: 1,
                color: AppColors.border
              )
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: widget.selectedItem == 3 ? NeverScrollableScrollPhysics() : BouncingScrollPhysics(),
              shrinkWrap: true,
              cacheExtent: 500,
              itemCount: currentCategories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectItemSub = index;
                      // Xử lí listview chỗ này
                      print(selectItemSub);
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.333,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Text(
                      currentCategories[index],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: selectItemSub == index ? Colors.red : AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
              
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                // Bóng trên
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(0, 16),
                  blurRadius: 14,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
