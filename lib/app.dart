import 'package:app_food_delivery/screens/auth/account_screen.dart';
import 'package:app_food_delivery/screens/detail/detail_product.dart';
import 'package:app_food_delivery/screens/home/home_screen.dart';
import 'package:app_food_delivery/screens/menu/menu_screen.dart';
import 'package:app_food_delivery/screens/order/order_screen.dart';
import 'package:app_food_delivery/screens/promotion/promotion_screen.dart';
import 'package:flutter/material.dart';

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 3;

  final List<Widget> _screens = [
    Center(child: HomeScreen()),
    Center(child: PromotionScreen()),
    Center(child: MenuScreen()),
    Center(child: DetailProduct()),
    //Center(child: OrderScreen()),
    Center(child: AccountScreen()),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = screenWidth / 5;

    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex],
      bottomNavigationBar: Stack(
        children: [
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 1),
              ],
              // borderRadius: BorderRadius.only(
              //   topLeft: Radius.circular(30),
              //   topRight: Radius.circular(30),
              // ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Stack(
              children: [
                // Animated Indicator
                AnimatedPositioned(
                  duration: Duration(milliseconds: 300),
                  left: _selectedIndex * itemWidth + (itemWidth / 2) - 18,
                  top: -2,
                  child: Container(
                    width: 34,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () => _onItemTapped(index),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        padding: EdgeInsets.fromLTRB(8, 12, 8, 12),
                        child: Container(
                          margin: EdgeInsets.only(top: 0),
                          child: ImageIcon(
                            AssetImage(_getIcon(index)),
                            color: _selectedIndex == index ? Colors.orange : Colors.grey,
                            size: _selectedIndex == index ? 32 : 24,
                          ),
                        )
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Icon của bottom nagivation
  String _getIcon(int index) {
    //String pathIcon = "assets/icons/";
    switch (index) {
      case 0:
        return "assets/icons/domino.png";
      case 1:
        return "assets/icons/coupon.png";
      case 2:
        return "assets/icons/pizza.png";
      case 3:
        return "assets/icons/delivery.png";
      case 4:
        return "assets/icons/account.png";
      default:
        return "assets/icons/domino.png";
    }
  }
}
