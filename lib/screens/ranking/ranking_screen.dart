import 'package:app_food_delivery/app.dart';
import 'package:app_food_delivery/core/constants/app_colors.dart';
import 'package:app_food_delivery/core/constants/app_padding.dart';
import 'package:app_food_delivery/core/constants/app_strings.dart';
import 'package:app_food_delivery/core/utils/format_utils.dart';
import 'package:app_food_delivery/screens/cart/cart_screen.dart';
import 'package:app_food_delivery/screens/product/product_detail_screen.dart';
import 'package:flutter/material.dart';

class RankingScreen extends StatefulWidget {
  static const routeName = '/ranking';
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  int selectedFilter = 0;

  //Fillter lọc sản phẩm theo các tiêu chí
  // Bán chạy, Đánh giá cao, Mới nhất
  final List<String> filters = ['Bán chạy', 'Theo tuần', 'Theo tháng'];

  //Danh sách các sản phẩm đã được đánh giá anova 
  //Lọc ra top 3 điểm cao nhất
  
  //Top 7 sản phẩm còn lại

  //Danh sách các sản phẩm nổi bật nhất dựa theo anova tiêu chí khác như ăn nhiều, rẻ, ngon

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Tiêu đề
          Container(
            margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Bảng Xếp Hạng',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.emoji_events, color: AppColors.warning),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Filter
          Container(
            height: 60,
            padding: EdgeInsets.only(left: 12, right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: FilterChip(
                    selected: selectedFilter == index,
                    label: Text(
                      filters[index],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onSelected: (bool selected) {
                      setState(() {
                        selectedFilter = index;
                      });
                    },
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.backgroudGreyBland,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    labelStyle: TextStyle(
                      color: selectedFilter == index ? Colors.white : AppColors.textPrimary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top 1
                  Container(
                    margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
                    width: double.infinity,
                    height: 250, // Đặt chiều cao cụ thể
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: AssetImage("assets/images/pizza.png"),
                        fit: BoxFit.cover,
                        opacity: 0.8,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                        // Nội dung
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.warning,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  '#1',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Seafood Four Season American Bue',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '225.000đ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context)=>CartScreen())
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text('Thêm vào giỏ'),
                                  ),
                                  SizedBox(width: 8,),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        MainApp.routeName,
                                        (Route<dynamic> route) => false,
                                        arguments: 2, // Tab Menu
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text('Menu'),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),

                  //Top 2 - 3
                  Container(
                    margin: AppPadding.paddingLe,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 200,
                            // width: MediaQuery.of(context).size.width*0.3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: const DecorationImage(
                                image: AssetImage("assets/images/pizza.png"),
                                fit: BoxFit.cover,
                                opacity: 0.8,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                // Gradient overlay
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: LinearGradient(
                                      colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                ),
                                // Nội dung
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: AppColors.warning,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: const Text(
                                          '#3',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Pizza Hải Sản',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        FormatUtils.formattedPrice(225000) + "đ",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context)=>CartScreen())
                                         );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.fromLTRB(14, 8, 6, 8),
                                          backgroundColor: AppColors.primary,
                                          foregroundColor: Colors.white,
                                          minimumSize: const Size(1, 1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        icon: Image.asset(
                                          "assets/icons/add_cart.png",
                                          width: 20,
                                          height: 20,
                                          fit: BoxFit.cover,
                                          color: Colors.white,
                                        ),
                                        label: Text(""),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        SizedBox(width: 12,),
                        
                        Expanded(
                          flex: 2,
                          child: Container(
                              height: 250, // Đặt chiều cao cụ thể
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: const DecorationImage(
                                  image: AssetImage("assets/images/pizza.png"),
                                  fit: BoxFit.cover,
                                  opacity: 0.8,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  // Gradient overlay
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      gradient: LinearGradient(
                                        colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                  ),
                                  // Nội dung
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: AppColors.warning,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: const Text(
                                            '#2',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'Pizza Hải Sản',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          '225.000đ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context)=>CartScreen())
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.fromLTRB(12, 6, 4, 6),
                                                backgroundColor: AppColors.primary,
                                                foregroundColor: Colors.white,
                                                minimumSize: const Size(1, 1),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                              icon: Image.asset(
                                                "assets/icons/add_cart.png",
                                                width: 22,
                                                height: 22,
                                                fit: BoxFit.cover,
                                                color: Colors.white,
                                              ),
                                              label: Text(""),
                                            ),
                                            SizedBox(width: 8,),
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  MainApp.routeName,
                                                  (Route<dynamic> route) => false,
                                                  arguments: 2, // Tab Menu
                                                );  
                                              },
                                              style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.fromLTRB(12, 6, 4, 6),
                                                backgroundColor: AppColors.primary,
                                                foregroundColor: Colors.white,
                                                minimumSize: const Size(1, 1),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                              icon: Image.asset(
                                                "assets/icons/menu_book.png",
                                                width: 22,
                                                height: 22,
                                                fit: BoxFit.cover,
                                                color: Colors.white,
                                              ),
                                              label: Text(""),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                      ],
                    ),
                  ),

                  // Các món khác (ví dụ)
                  Container(
                    margin: EdgeInsets.only(top: 16, bottom: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: AppPadding.paddingLe,
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Món ngon hôm nay",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: 3,
                            itemBuilder: (context, index){
                              return _buildFoodCard();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16, bottom: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: AppPadding.paddingLe,
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Món ăn nổi bật",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        _buildFoodListOutstand(),
                      ],
                    ),
                  ),
                ],
              
              ),
            ),
          )
        ],
      )
    );
  }

  Widget _buildFoodListOutstand() {
    List<String> name = [
      "Seafood Four Seasons",
      "American Cheeseburger",
      "Cheesy Madness",
      "Super Topping Surf And Turf"
    ];
    List<int> price = [
      325000, 205000, 175000, 235000,
    ];
    return  Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      height: 204,
      decoration: BoxDecoration(
        color: AppColors.border
      ),
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
              width: 120,
              margin: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Màu bóng
                    spreadRadius: -4, // Độ lan của bóng
                    blurRadius: 4, // Độ mờ của bóng
                    offset: Offset(0, 4), // Độ dịch chuyển (chỉ xuống dưới)
                  ),
                ]
              ),
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

  Widget _buildFoodCard() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), // Khoảng cách giữa các item
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150, // Chiều cao hình ảnh
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              image: const DecorationImage(
                image: AssetImage("assets/images/pizza.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pizza Hải Sản',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '225.000đ',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.amberAccent,
                        borderRadius: BorderRadius.circular(50),

                      ),
                      child: Text(
                        "4.5",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.6, // Button chiếm toàn chiều rộng của card
                      height: 30,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            MainApp.routeName,
                            (Route<dynamic> route) => false,
                            arguments: 2, // Tab Menu
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.zero, // Loại bỏ padding mặc định
                        ),
                        icon: Image.asset(
                          "assets/icons/pizza.png",
                          width: 20,
                          height: 20,
                          fit: BoxFit.cover,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Mua ngay',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.2, // Button chiếm toàn chiều rộng của card
                      height: 30,
                      child:  ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=>CartScreen())
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(6, 2, 2, 2),
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(1, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: Image.asset(
                          "assets/icons/add_cart.png",
                          width: 20,
                          height: 20,
                          fit: BoxFit.cover,
                          color: Colors.white,
                        ),
                        label: Text(""),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
