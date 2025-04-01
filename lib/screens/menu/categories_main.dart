  import 'package:app_food_delivery/constants/app_colors.dart';
import 'package:app_food_delivery/screens/menu/categories_sub.dart';
import 'package:flutter/material.dart';

class CategoriesMain extends StatefulWidget {
  const CategoriesMain({super.key});

  @override
  State<CategoriesMain> createState() => _CategoriesMainState();
}

class _CategoriesMainState extends State<CategoriesMain> {
  int selectedItem = 0;
  //Danh sách category ten + ảnh
  List<String> categoriesName = [
    "PIZZA", "CHICKEN", "PASTA", "APPETIZER", "DESSERT", "DRINKS"
  ];
  List<String> categoriesImage = [
    "assets/images/category_pizza.png",
    "assets/images/category_chicken.png",
    "assets/images/category_pasta.png",
    "assets/images/category_appetizer.png",
    "assets/images/category_desser.png",
    "assets/images/category_drink.png",
  ];

  void updateSelectedItem(int index) {
    setState(() {
      selectedItem = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            height: (selectedItem == 0 || selectedItem == 3) ? 62 : 70,
            decoration: BoxDecoration(
              color: AppColors.background
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              cacheExtent: 500, // Tải trước nội dung cách 500px
              primary: true,
              itemCount: categoriesName.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedItem = index;
                      // Xử lí listview chỗ này
                      print(selectedItem);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 8),
                    decoration: BoxDecoration(
                      // color: Colors.amberAccent
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: Image.asset(
                            categoriesImage[index],
                            width: 24,
                            height: 24,
                            fit: BoxFit.fill,
                            color: selectedItem == index ? AppColors.textRed : AppColors.textSecondary,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            categoriesName[index],
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: selectedItem == index ? Colors.red : AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ),
                      ],
                    ),
                  )
                );
              },
            ),
          ),

          CategoriesSub(selectedItem: selectedItem,)
  
        ],
      ),
    );
    
    
  }
}