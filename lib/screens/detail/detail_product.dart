import 'package:app_food_delivery/constants/app_colors.dart';
import 'package:app_food_delivery/constants/app_strings.dart';
import 'package:app_food_delivery/utils/format_utils.dart';
import 'package:flutter/material.dart';

class DetailProduct extends StatefulWidget {
  const DetailProduct({super.key});

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  int selectedItem = 0;
  //Vi du size với giá
  List<int> sizes = [7, 9, 12];
  List<int> prices = [85000, 155500, 225000];
  int maxRow = 2;

  void changeActive(int index){
    setState(() {
      selectedItem = index;
    });
  }
  void changeMaxRow(){
    setState(() {
      if(maxRow == 2){
        maxRow = 10;
      }
      else {
        maxRow = 2;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Container(
            
            child: Image.asset(
              "assets/images/pizza.png",
              width: double.infinity,
              height: MediaQuery.of(context).size.height*0.3333,
              fit: BoxFit.cover,
            ),
          ),
          
          Positioned(
            top: 180,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(9),
                  topRight: Radius.circular(9)
                )
              ),
              padding: EdgeInsets.only(top: 12, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 12, right: 12, bottom: 4),
                    child: Text(
                      "Seafood Four Seasons",
                      style: TextStyle(color: AppColors.primary , fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(left: 12, right: 12),
                    child: Text(
                      "Tăng 50% lượng topping protein: Tôm Có Đuôi, Mực Khoanh; Thêm Phô Mai Mozzarella, Xốt Pesto Kem Chanh, Xốt Kim Quất, Xốt Vải, Xốt Xoài, Hành Tây, Cà Chua, Lá Mùi Tây, Xốt Bơ Tỏi Viền Bánh ",
                      style: TextStyle(color: AppColors.textSecondary , fontSize: 12, fontWeight: FontWeight.normal),
                      maxLines: maxRow,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                   Container(
                    margin: EdgeInsets.only(top: 4,  bottom: 8),
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      onTap: () {
                        changeMaxRow();
                      },
                      child: Text(
                        maxRow ==  2 ? "Xem thêm" : "Ẩn Đi",
                        style: TextStyle(color: AppColors.primary , fontSize: 12, fontWeight: FontWeight.normal, decoration: TextDecoration.underline, decorationColor: AppColors.primary),
                      ),
                    )
                  ),
                  Container(
                    // width: MediaQuery.of(context).size.width,
                    height: 1,
                    decoration: BoxDecoration(
                      color: AppColors.backgroudGreyBland
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: const Text(
                            "Select Size",
                            style: TextStyle(color: AppColors.textPrimary , fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),

                        Container(
                          height: 42,
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            itemBuilder: (context, index){
                              bool isActive = (index == selectedItem);
                              return Container(
                                margin: EdgeInsets.only(right: 6),
                                child: GestureDetector(
                                  onTap: (){
                                    changeActive(index);
                                    print("Bạn chọn size ${sizes[index]}");
                                  },
                                  child: buidSizeAndPrice(isActive ,sizes[index], prices[index]),
                                ),
                              );
                            }
                          ),
                        )
                      ],
                    ),
                  ),
                
                  Container(
                    padding: EdgeInsets.only(left: 12, right: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: const Text(
                            "Chọn Đế Bánh",
                            style: TextStyle(color: AppColors.textPrimary , fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.fromLTRB(6, 4, 6, 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              width: 1,
                              color: AppColors.border
                            )
                          ),
                          child: Row(
                            mainAxisSize:MainAxisSize.min, //wrap
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 4),
                                child: Image.asset(
                                  "assets/icons/crust.png",
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                child: Text(
                                  "Đế dày",
                                  style: TextStyle(color: AppColors.textPrimary , fontSize: 12, fontWeight: FontWeight.normal),

                                ),

                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                
                ],
              ),
            ),
          ),
          Positioned(
            child: Container(
              
              margin: EdgeInsets.only(left: 8, right: 8, top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap:() {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.textPrimary.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(50)
                      ),
                      child: Image.asset(
                        "assets/icons/close.png",
                        width: 18,
                        height: 18,
                        fit: BoxFit.fill,
                        color: Colors.white
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap:() {
                      print("Ket thuc trang");
                    },
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.textPrimary.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(50)
                      ),
                      child: Image.asset(
                        "assets/icons/cart.png",
                        width: 20,
                        height: 20,
                        fit: BoxFit.fill,
                        color: Colors.white
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buidSizeAndPrice(bool isActive, int size, int price){
    return  Container(
      padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary.withOpacity(0.2) : Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          width: 1,
          color: isActive ? AppColors.primary : AppColors.border
        )
      ),
      child: Row(
        mainAxisSize:MainAxisSize.min, //wrap
        children: [
          Container(
            margin: EdgeInsets.only(right: 6),
            child: Image.asset(
              "assets/icons/pizza_size.png",
              width: 20,
              height: 20,
              fit: BoxFit.cover,
              color: AppColors.primary,
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 3),
                  child: Text(
                    "Cỡ $size inch",
                    style: TextStyle(color: AppColors.textPrimary , fontSize: 11, fontWeight: FontWeight.normal),

                  ),
                ),
                Container(
                  child: Text(
                    FormatUtils.formattedPrice(price) + AppStrings.tienTe,
                    style: TextStyle(color: AppColors.textSecondary , fontSize: 8, fontWeight: FontWeight.normal),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buidCrust(bool isActive, int size, int price){
    return  Container(
      padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary.withOpacity(0.2) : Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          width: 1,
          color: isActive ? AppColors.primary : AppColors.border
        )
      ),
      child: Row(
        mainAxisSize:MainAxisSize.min, //wrap
        children: [
          Container(
            margin: EdgeInsets.only(right: 6),
            child: Image.asset(
              "assets/icons/pizza_size.png",
              width: 20,
              height: 20,
              fit: BoxFit.cover,
              color: AppColors.primary,
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 3),
                  child: Text(
                    "Cỡ $size inch",
                    style: TextStyle(color: AppColors.textPrimary , fontSize: 11, fontWeight: FontWeight.normal),

                  ),
                ),
                Container(
                  child: Text(
                    FormatUtils.formattedPrice(price) + AppStrings.tienTe,
                    style: TextStyle(color: AppColors.textSecondary , fontSize: 8, fontWeight: FontWeight.normal),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

}