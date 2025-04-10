import 'dart:ffi';

import 'package:app_food_delivery/app.dart';
import 'package:app_food_delivery/core/constants/app_colors.dart';
import 'package:app_food_delivery/core/constants/app_strings.dart';
import 'package:app_food_delivery/core/utils/format_utils.dart';
import 'package:app_food_delivery/screens/promotion/promotion_list_screen.dart';
import 'package:app_food_delivery/screens/promotion/promotion_screen.dart';
import 'package:app_food_delivery/widgets/custom_increase_decrease.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  List<Map<String, dynamic>> cartList = [
    {
      'id': 1,
      'name': 'Pizza Siêu Topping Hải Sản Xốt Pesto "Chanh Sả"',
      'price': 710000,
      'image': 'assets/images/pizza.png',
      'crust': "Đế Vừa",
      'size': 12,
      'quantity': 2,
    },
    {
      'id': 2,
      'name': 'Burger Phô Mai',
      'price': 190000,
      'image': 'assets/images/pizza.png',
      'crust': "Đế Mỏng",
      'size': 7,
      'quantity': 2,
    },
    {
      'id': 3,
      'name': 'Salad Caesar',
      'price': 980000,
      'image': 'assets/images/pizza.png',
      'crust': "Đế Dày",
      'size': 9,
      'quantity': 2,
    },
    {
      'id': 4,
      'name': 'Mì Ý Carbonara',
      'price': 109099,
      'image': 'assets/images/pizza.png',
      'crust': "Đế Dày",
      'size': 12,
      'quantity': 2,
    },
  ]; 
  int selectedButton = 1; //  chọn ô promotion mặc định
  int qualityCart = 10;

  //Controller nhập liệu
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _noteOrderController = TextEditingController();

  String crustAndSize(int index){
    return cartList[index]["crust"] + " Bột Tươi - Cỡ " +  cartList[index]["size"].toString() + " inch";
  }

  double totalMoney(){
    double total = 0;
    for(var cartItem in cartList){
      total += cartItem['price'] * cartItem["quantity"]; 
    }
    return total;
  }
  //Trạng thái Giao hàng hay mua về
  void onToggleButton(int buttonIndex){
    setState(() {
      selectedButton = buttonIndex;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Địa chỉ
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){
                              Navigator.pop(context);
                          }, 
                          child: Container(
                            margin: EdgeInsets.fromLTRB(4, 4, 4, 0),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              size: 18,
                            ),
                          )
                        ),
                        Container(
                          width: 100,
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
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                                      "Giao Hàng",
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
                                      "Đến Lấy",
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
                  //Danh sách sản phẩm trong giỏ hàng
                  SizedBox(
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cartList.length,
                      // itemCount: 1,
                      itemBuilder: (context, index){
                        return buildCartItem(index);
                      }
                    ),
                  ),
                  //Có thể bạn sẽ thích
                  Container(
                    margin: EdgeInsets.fromLTRB(12, 0, 12, 10),
                    child: Text(
                      "Có thể bạn sẽ thích",
                      style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(12, 0, 12, 12),
                    height: 140,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return buildYourFavouriteItem(
                          imgPath: "assets/images/pizza.png",
                          name: "Gà Viên Phô Mai Đút Lò",
                          price: 69000,
                          onAddToCart: () {
                            print("Them vao gio hang");
                          },
                        );
                      },
                    )
                  ),
                  //Khám phá với E-voucher
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context)=>MainApp())
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 1, color: AppColors.border),
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                  offset: Offset(1, 1),
                                  color: AppColors.textPrimary.withOpacity(0.2),
                                )
                              ]
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/icons/pizza.png",
                                          width: 24,
                                          height: 24,
                                          fit: BoxFit.cover,
                                          color: AppColors.primary,
                                        ),
                                        SizedBox(width: 6),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Khám Phá Thực Đơn",
                                              style: TextStyle(
                                                color: AppColors.textPrimary,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "Thêm Nhiều Món Ngon Vào Giỏ Hàng",
                                              //"Áp Dụng E-Voucher Và Xem Thêm Các Ưu Đãi Tuyệt VỚi",
                                              style: TextStyle(
                                                color: AppColors.textSecondary,
                                                fontSize: 11,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context)=>MainApp())
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 1, color: AppColors.border),
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                  offset: Offset(1, 1),
                                  color: AppColors.textPrimary.withOpacity(0.2),
                                )
                              ]
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/icons/discount_tag.png",
                                          width: 20,
                                          height: 20,
                                          fit: BoxFit.cover,
                                          color: AppColors.error,
                                        ),
                                        SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "E-voucher",
                                              style: TextStyle(
                                                color: AppColors.textPrimary,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 200,
                                              child: Text(
                                                "Áp Dụng E-Voucher Và Xem Thêm Các Ưu Đãi Tuyệt Vời Khác",
                                                softWrap: true,
                                                maxLines: 2,
                                                style: TextStyle(
                                                  color: AppColors.textSecondary,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  //Thông tin khách hàng
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red,
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 1, color: AppColors.border),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 1,
                                spreadRadius: 1,
                                offset: Offset(1, 1),
                                color: AppColors.textPrimary.withOpacity(0.2),
                              )
                            ]
                          ),
                          child: Column(
                            children: [
                              buildCustomerTextField(
                                label: "Tên Khách Hàng",
                                isCompulsory: true,
                                prefixIcon: Icons.person,
                                hintText: "Nhập tên của bạn",
                                onChanged: (value){},
                                controller: _nameController
                              ),

                              buildCustomerTextField(
                                label: "Email",
                                isCompulsory: true,
                                prefixIcon: Icons.person,
                                hintText: "Nhập email của bạn",
                                onChanged: (value){},
                                controller: _nameController
                              ),

                              buildCustomerTextField(
                                label: "Số Điện Thoại",
                                isCompulsory: true,
                                prefixIcon: Icons.person,
                                hintText: "Nhập số điện thoại của bạn",
                                onChanged: (value){},
                                controller: _nameController
                              ),

                              buildCustomerTextField(
                                label: "Ghi Chú Đơn Hàng",
                                isCompulsory: false,
                                prefixIcon: Icons.person,
                                hintText: "Nhập ghi chú đơn hàng (nếu có)",
                                onChanged: (value){},
                                controller: _nameController
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  
                  SizedBox(height: 150,)
                ],
              ),
            ),
            //Hoàn tất thanh toán
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10,  10),
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Tổng cộng: ",
                            style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.normal, fontSize: 12),
                          ),
                          Text(
                            FormatUtils.formattedPriceDouble(totalMoney()) + AppStrings.tienTe,
                            style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=> MainApp())
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
                          "Hoàn Tất Thanh Toán",
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
      )
    );
  }

  Widget buildCartItem(int index){
    return Container(
      margin: EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(spreadRadius: 2, blurRadius: 2, offset: Offset(2, 2), color: AppColors.textPrimary.withOpacity(0.2))
        ]
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  cartList[index]["image"],
                  width: 70,
                  height: 50,
                  fit: BoxFit.cover
                ),
              ),
              const SizedBox(width: 6,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 160,
                    child: Text(
                      cartList[index]["name"],
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    crustAndSize(index),
                    style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.normal, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 10),
          //Xem chi tiết và xóa
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Xem chi tiết
              GestureDetector(
                onTap: (){

                },
                child: Row(
                  children: [
                    const Text(
                      "Xem chi tiết",
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.normal, fontSize: 12),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 4, top: 1),
                      child: const Icon(
                        Icons.keyboard_double_arrow_down,
                        size: 14,
                        color: AppColors.primary,
                      ),
                    )
                  ],
                )
              ),
              //Xóa
              GestureDetector(
                onTap: (){
                  setState(() {
                    cartList.remove(index);
                  });
                }, 
                child: Icon(
                  Icons.delete_outline,
                  color: AppColors.error,
                  size: 18,
                )
              )
            ],
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  buildQuantityControl(
                    icon: Icons.remove, 
                    onPressed: (){
                      setState(() {
                        cartList[index]["quantity"] == 1 ? cartList[index]["quantity"] = 1 : cartList[index]["quantity"]--;
                      });
                    }
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${cartList[index]["quantity"]}',
                    style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(width: 10),
                  buildQuantityControl(
                    icon: Icons.add, 
                    onPressed: (){
                      setState(() {
                        cartList[index]["quantity"] == 100 ? cartList[index]["quantity"] = 100 : cartList[index]["quantity"]++;
                      });
                    }
                  ),
                ],
              ),
              Text(
                FormatUtils.formattedPrice(cartList[index]["price"]) + AppStrings.tienTe,
                style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ],
          ),
          Visibility(
            visible: true,
            child: Container(
              margin: EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: -4,
                        top: -12,
                        child: Image.asset(
                          "assets/icons/ticket.png",
                          width: 54,
                          height: 54,
                          fit: BoxFit.cover,
                          color: AppColors.error
                        )
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                        decoration: BoxDecoration(
                          color: AppColors.error
                        ),
                        child: Text(
                          "Mua Theo Chương Trình Khuyến Mãi",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        topRight: Radius.circular(10)
                      )
                    ),
                    child: Image.asset(
                      "assets/icons/discount_tag.png",
                      width: 20,
                      height: 20,
                      fit: BoxFit.cover,
                    )
                  ),
                ],
              ),
            ),
          )
        ]
      ),
    );
  }

  Widget buildQuantityControl({required IconData icon, required VoidCallback onPressed}){
    return SizedBox(
      width: 24,
      child: IconButton(
        onPressed: onPressed,
        style: IconButton.styleFrom(
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

  Widget buildYourFavouriteItem({required String imgPath, required String name, required int price, required VoidCallback onAddToCart}){
    return  Container(
      margin: EdgeInsets.only(right: 10),
      width: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: AppColors.border),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            spreadRadius: 1,
            offset: Offset(1, 1),
            color: AppColors.textPrimary.withOpacity(0.2),
            )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hình ảnh sản phẩm
          Container(
            width: double.infinity,
            height: 60,
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              image: DecorationImage(
                image: AssetImage(imgPath),
                fit: BoxFit.cover,
              ),
            ),
            child: const SizedBox(), // Để đảm bảo Container hiển thị đúng kích thước
            // Xử lý lỗi hình ảnh
            clipBehavior: Clip.hardEdge,
            // Thêm errorBuilder nếu cần
          ),
          // Tên sản phẩm
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                name,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ),
          // Giá và nút thêm
          Container(
            padding: const EdgeInsets.fromLTRB(6, 6, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  FormatUtils.formattedPrice(price) + AppStrings.tienTe,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                GestureDetector(
                  onTap: onAddToCart, // Thêm hành động khi nhấn nút
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        bottomRight: Radius.circular(4), // Bo góc cho đồng bộ
                      ),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCustomerTextField({
      required String label,
      required bool isCompulsory,
      required IconData? prefixIcon,
      required String hintText,
      required ValueChanged<String>? onChanged,
      TextEditingController? controller, // Controller để quản lý giá trị
    }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: AppColors.textPrimary),
            ),
            Container(
              margin: const EdgeInsets.only(left: 4, bottom: 6),
              child: Text(
                isCompulsory ? "*" : "",
                style: TextStyle(fontSize: 12, color: AppColors.error),
              ),
            ),
          ],
        ),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller, // Sử dụng controller nếu có
            cursorColor: AppColors.primary,
            cursorHeight: 14,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
            ),
            onChanged: onChanged, // Callback khi người dùng nhập
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
              ),
              prefixIcon: prefixIcon != null
                  ? Icon(
                      prefixIcon,
                      color: Colors.grey,
                      size: 18,
                    )
                  : null,
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.shade500,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.shade500,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }
}