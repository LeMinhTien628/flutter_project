import 'package:app_food_delivery/app.dart';
import 'package:app_food_delivery/screens/auth/auth_screen.dart';
import 'package:app_food_delivery/screens/auth/login_screen.dart';
import 'package:app_food_delivery/screens/feedback/feedback_screen.dart';
import 'package:app_food_delivery/screens/order/order_screen.dart';
import 'package:app_food_delivery/screens/ranking/ranking_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// user1@gmail.com hash1
// dotnet run --urls "http://0.0.0.0:5021"
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  debugPaintSizeEnabled = false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      //initialRoute: MainApp.routeName, // Màn hình khởi đầu
      initialRoute: FeedbackScreen.routeName, //Test màn
      onGenerateRoute: (settings) {
        // Xử lý route động cho MainApp
        if (settings.name == MainApp.routeName) {
          final int tabIndex = settings.arguments as int? ?? 0;
          return MaterialPageRoute(
            builder: (context) => MainApp(initialIndex: tabIndex),
          );
        }
        return null;
      },
      routes: {
        MainApp.routeName: (context) => MainApp(),
        // MainApp.routeName: (context) => MainApp(selectedScreen: 1),
        // HomeScreen.routeName: (context) => const HomeScreen(),
        // PromotionScreen.routeName: (context) => const PromotionScreen(),
        // MenuScreen.routeName: (context) => const MenuScreen(),
        // ProductDetailScreen.routeName: (context) => const ProductDetailScreen(),
        AuthScreen.routeName: (context) => const AuthScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        OrderScreen.routeName: (context) => const OrderScreen(),
        RankingScreen.routeName: (context) => const RankingScreen(),
        FeedbackScreen.routeName: (context) => const FeedbackScreen(),
        // OrderCheckoutScreen.routeName: (context) => const OrderCheckoutScreen(
        //       customerName: 'John Doe',
        //       email: 'john@example.com',
        //       phoneNumber: '1234567890',
        //       note: '',
        //       deliveryMethod: 'Delivery Now',
        //       paymentMethod: 'Thanh Toán Tiền Mặt',
        //       cartItems: [],
        //       totalAmount: 0,
        //     ),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text('404 - Page Not Found')),
          ),
        );
      },
    );
  }
}