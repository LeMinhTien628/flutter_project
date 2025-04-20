import 'package:app_food_delivery/app.dart';
import 'package:app_food_delivery/core/constants/app_colors.dart';
import 'package:app_food_delivery/core/constants/app_padding.dart';
import 'package:app_food_delivery/core/constants/app_strings.dart';
import 'package:app_food_delivery/core/utils/format_utils.dart';
import 'package:app_food_delivery/screens/cart/cart_screen.dart';
import 'package:app_food_delivery/screens/home/best_seller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  List<int> sizes = [7, 9, 12];
  List<int> prices = [85000, 155500, 225000];
  bool isTop = true;
  int selectedSize = 0;
  int selectedCrust = 0;
  int quantity = 1;
  int selectedPrice = 0;
  int maxRow = 2;

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedPrice = prices[0];
    });
  }

  void changeSizeActive(int index) {
    setState(() {
      selectedSize = index;
    });
  }

  void changeCrustActive(int index) {
    setState(() {
      selectedCrust = index;
    });
  }

  void changeMaxRow() {
    setState(() {
      maxRow = maxRow == 2 ? 10 : 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // Ảnh sản phẩm
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3333,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Image.asset(
                      "assets/images/pizza.png",
                      fit: BoxFit.cover,
                    ),
                  )
                ),
                // Thông tin sản phẩm
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(9),
                      topRight: Radius.circular(9),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tên sản phẩm
                      Padding(
                        padding: AppPadding.paddingLe,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Seafood Four Seasons",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Visibility(
                              visible: isTop,
                              child: Image.asset(
                                "assets/icons/top_1st.png",
                                width: 24,
                                height: 24,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      // Nội dung thành phần
                      Padding(
                        padding: AppPadding.paddingLe,
                        child: Text(
                        "Tăng 50% lượng topping protein: Tôm Có Đuôi, Mực Khoanh; Thêm Phô Mai Mozzarella, Xốt Pesto Kem Chanh, Xốt Kim Quất, Xốt Vải, Xốt Xoài, Hành Tây, Cà Chua, Lá Mùi Tây, Xốt Bơ Tỏi Viền Bánh",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                        maxLines: maxRow,
                        overflow: TextOverflow.ellipsis,
                      ),
                      ),
                      const SizedBox(height: 4),
                      // Xem thêm - ẩn đi
                      Padding(padding: AppPadding.paddingLe,
                        child: GestureDetector(
                          onTap: changeMaxRow,
                          child: Text(
                            maxRow == 2 ? "Xem thêm" : "Ẩn Đi",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Ngăn cách
                      Container(
                        height: 1,
                        color: AppColors.backgroudGreyBland,
                      ),
                      const SizedBox(height: 10),
                      // Kích thước
                      Padding(padding: AppPadding.paddingLe,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Select Size",
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 42,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: sizes.length,
                                itemBuilder: (context, index) {
                                  bool isActiveSize = (index == selectedSize);
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedPrice = prices[index];
                                      });
                                      changeSizeActive(index);
                                      print("Bạn chọn size ${sizes[index]}");
                                    },
                                    child: buildSizeAndPrice(isActiveSize, sizes[index], prices[index]),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Đế bánh
                      Padding(
                        padding: AppPadding.paddingLe,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Chọn Đế Bánh",
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 32,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 3,
                                itemBuilder: (context, index) {
                                  bool isActiveCrust = (index == selectedCrust);
                                  List<String> crusts = ["Đế dày", "Đế vừa", "Đế mỏng"];
                                  return GestureDetector(
                                    onTap: () {
                                      changeCrustActive(index);
                                      print("Bạn chọn đế ${crusts[index]}");
                                    },
                                    child: buildCrust(isActiveCrust, crusts[index]),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Sản phẩm mua kèm
                      Container(
                        width: double.infinity,
                        color: AppColors.backgroudGreyBland,
                        padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                        margin: EdgeInsets.only(bottom: 106),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: const Text(
                                    "Sản phẩm mua kèm",
                                    style: TextStyle(
                                      color: AppColors.secondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      Text(
                                        "Xem thêm",
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      FaIcon(
                                        FontAwesomeIcons.angleRight,
                                        size: 14,
                                        color: AppColors.textPrimary,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            BestSeller(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          //Thêm giỏi hàng
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 106,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    width: 1,
                    color: AppColors.border
                  )
                )
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 10),
                          buildQuantityControl(
                            icon: Icons.remove, 
                            onPressed: (){
                              setState(() {
                                if(quantity == 1){
                                  quantity = 1;
                                }
                                else{
                                  quantity--;
                                }
                              });
                            }
                          ),
                          SizedBox(width: 10),
                          Text(
                            '$quantity',
                            style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 10),
                          buildQuantityControl(
                            icon: Icons.add, 
                            onPressed: (){
                              setState(() {
                                if(quantity == 100){
                                  quantity = 100;
                                }
                                else{
                                  quantity++;
                                }
                              });
                            }
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 12),
                        child: Row(
                          children: [
                            Text(
                              "Tổng cộng: ",
                              style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.normal, fontSize: 12),
                            ),
                            Text(
                              FormatUtils.formattedPrice(selectedPrice*quantity) + AppStrings.tienTe,
                              style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> CartScreen())
                        );
                      }, 
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)
                        ),
                      ),
                      child: const Text(
                        "Thêm Vào Giỏ Hàng",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      // Thoát và thêm giỏ hàng
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.textPrimary.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Image.asset(
                  "assets/icons/close.png",
                  width: 18,
                  height: 18,
                  fit: BoxFit.fill,
                  color: Colors.white,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=>CartScreen())
                );
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.textPrimary.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Image.asset(
                  "assets/icons/cart.png",
                  width: 20,
                  height: 20,
                  fit: BoxFit.fill,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
    );
  }

  Widget buildSizeAndPrice(bool isActive, int size, int price) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary.withOpacity(0.2) : Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          width: 1,
          color: isActive ? AppColors.primary : AppColors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/icons/pizza_size.png",
            width: 20,
            height: 20,
            fit: BoxFit.cover,
            color: AppColors.primary,
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Cỡ $size inch",
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 11,
                ),
              ),
              Text(
                "${FormatUtils.formattedPrice(price)} ${AppStrings.tienTe}",
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCrust(bool isActive, String crustName) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary.withOpacity(0.2) : Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          width: 1,
          color: isActive ? AppColors.primary : AppColors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/icons/crust.png",
            width: 20,
            height: 20,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 4),
          Text(
            crustName,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQuantityControl({required IconData icon, required VoidCallback onPressed}){
    return SizedBox(
      width: 24,
      child: IconButton(
        onPressed: onPressed,
        style: IconButton.styleFrom(
          minimumSize: Size(0, 0),
          padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(width: 1, color: AppColors.border)
          ) 
        ),
        icon: Icon(
          icon,
          size: 16,
          color: AppColors.primary,
        )
      ),
    );
  }
}