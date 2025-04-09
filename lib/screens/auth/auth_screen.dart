// import 'package:app_food_delivery/core/constants/app_colors.dart';
// import 'package:app_food_delivery/screens/auth/login_screen.dart';
// import 'package:app_food_delivery/screens/auth/register_screen.dart';
// import 'package:flutter/material.dart';

// class AuthScreen extends StatefulWidget {
//   const AuthScreen({super.key});

//   @override
//   State<AuthScreen> createState() => _AuthScreenState();
// }

// class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
//     );
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               AppColors.primary, 
//               Colors.white, 
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 40),
//                 // Hình ảnh pizza
//                 FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: Container(
//                     height: MediaQuery.of(context).size.height * 0.3, // Giảm kích cỡ hình
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle, // Bo tròn hình ảnh
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           blurRadius: 10,
//                           offset: const Offset(0, 5),
//                         ),
//                       ],
//                       image: const DecorationImage(
//                         image: AssetImage('assets/images/loginpizza.png'),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 // Tiêu đề "YummyGo Xin Chào!"
//                 FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: const Text(
//                     'YummyGo Xin Chào!',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                       letterSpacing: 1.2,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 // Mô tả
//                 Container(
//                   width: 240,
//                   child: FadeTransition(
//                     opacity: _fadeAnimation,
//                     child: const Text(
//                       'Welcome To YummyGo, where you nmanage your daily tasks',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.black54,
//                         height: 1.5,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 // Nút Login
//                 FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 40),
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context)=>LoginScreen())
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primary,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 18),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         elevation: 5,
//                         shadowColor: Colors.black38,
//                       ),
//                       child: const SizedBox(
//                         width: double.infinity,
//                         child: Text(
//                           'Login',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 // Nút Register
//                 FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 40),
//                     child: OutlinedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context)=>RegisterScreen())
//                         );
//                       },
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: const Color(0xFF1A73E8),
//                         side: const BorderSide(color: AppColors.primary, width: 2),
//                         padding: const EdgeInsets.symmetric(vertical: 18),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                       ),
//                       child: const SizedBox(
//                         width: double.infinity,
//                         child: Text(
//                           'Register',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.primary,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 // // Dòng chữ "SIGN UP USING"
//                 // FadeTransition(
//                 //   opacity: _fadeAnimation,
//                 //   child: const Text(
//                 //     'SIGN UP USING',
//                 //     style: TextStyle(
//                 //       fontSize: 14,
//                 //       color: Colors.black54,
//                 //       fontWeight: FontWeight.w500,
//                 //     ),
//                 //   ),
//                 // ),
                
//                 const SizedBox(height: 16),
//                 // Biểu tượng Facebook và Google
//                 // FadeTransition(
//                 //   opacity: _fadeAnimation,
//                 //   child: Row(
//                 //     mainAxisAlignment: MainAxisAlignment.center,
//                 //     children: [
//                 //       _buildSocialButton(
//                 //         iconPath: 'assets/icons/facebook.png',
//                 //         onTap: () {
//                 //           // Xử lý đăng nhập bằng Facebook
//                 //         },
//                 //       ),
//                 //       const SizedBox(width: 16),
//                 //       _buildSocialButton(
//                 //         iconPath: 'assets/icons/google.png',
//                 //         onTap: () {
//                 //           // Xử lý đăng nhập bằng Google
//                 //         },
//                 //       ),
//                 //       const SizedBox(width: 16),
//                 //       _buildSocialButton(
//                 //         iconPath: 'assets/icons/google.png',
//                 //         onTap: () {
//                 //           // Xử lý đăng nhập bằng Google (thứ hai)
//                 //         },
//                 //       ),
//                 //     ],
//                 //   ),
//                 // ),
//                 // const SizedBox(height: 40),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Widget tùy chỉnh cho nút đăng nhập xã hội
//   Widget _buildSocialButton({required String iconPath, required VoidCallback onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 5,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Image.asset(
//           iconPath,
//           height: 40,
//           width: 40,
//         ),
//       ),
//     );
//   }
// }
