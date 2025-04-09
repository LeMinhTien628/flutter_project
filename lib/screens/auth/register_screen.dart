import 'package:app_food_delivery/screens/auth/login_screen.dart';
import 'package:app_food_delivery/widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:app_food_delivery/core/constants/app_colors.dart'; // Giả định AppColors

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;
  bool _isAgree = false;
  bool _isRegister = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  bool _handleRegister() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập email và mật khẩu')),
      );
    } 
    else if (_isAgree == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn đồng ý điều khoản')),
      );
    } 
    else if(password != confirmPassword){
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mật khẩu không khớp')),
      );
    }
    else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Đăng ký thành công')),
      // );
      _isRegister = true;
    }
    return _isRegister;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Hình nền nằm dưới cùng
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
                  fit: BoxFit.cover, // Hình nền phủ toàn màn hình
                ),
              ),
            ),
            //Nút close
            Positioned(
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            // Nút Skip 
            Positioned(
              right: 0,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Image.asset(
                  "assets/icons/account.png",
                  width: 26,
                  height: 26,
                  fit: BoxFit.cover,
                  color: Colors.white,
                )
              ),
            ),
            // Modal chứa form đăng ký nằm ở dưới
            Align(
              alignment: Alignment.bottomCenter,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9), // Nền trắng mờ để nổi trên ảnh
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Đăng Ký',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: AppColors.primary,
                        cursorHeight: 20,
                        cursorWidth: 2,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          labelText: 'Email',
                          hintText: 'Nhập email của bạn',
                          labelStyle: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14
                          ),
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14
                          ),
                          prefixIcon: const Icon(Icons.email, color: AppColors.textSecondary, size: 20,),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.fromLTRB(10, 14, 10, 14)
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: _isPasswordHidden,
                        cursorColor: AppColors.primary,
                        cursorHeight: 20,
                        cursorWidth: 2,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          labelText: 'Mật khẩu',
                          labelStyle: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14
                          ),
                          hintText: 'Nhập mật khẩu',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14
                          ),
                          prefixIcon: const Icon(Icons.lock, color: AppColors.textSecondary, size: 20,),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                              color: Colors.black54,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordHidden = !_isPasswordHidden;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.fromLTRB(10, 14, 10, 14)
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: _isConfirmPasswordHidden,
                        cursorColor: AppColors.primary,
                        cursorHeight: 20,
                        cursorWidth: 2,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          labelText: 'Nhập lại mật khẩu',
                          labelStyle: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14
                          ),
                          hintText: 'Nhập lại mật khẩu',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14
                          ),
                          prefixIcon: const Icon(Icons.lock, color: AppColors.textSecondary, size: 20,),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordHidden ? Icons.visibility_off : Icons.visibility,
                              color: Colors.black54,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.fromLTRB(10, 14, 10, 14)
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.only(left: 16),
                        child: Row(
                          children: [
                            CustomCheckbox(
                              value: _isAgree,
                              onChanged: (newValue) {
                                setState(() {
                                  _isAgree = newValue;
                                });
                              },
                              activeColor: AppColors.primary,
                              checkColor: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Đồng ý với điều khoản sử dụng',
                              style: TextStyle(
                                color: !_isAgree ? AppColors.textSecondary : AppColors.primary , 
                                fontSize: 12
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: (){
                          if(_handleRegister()){
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context)=>LoginScreen()) 
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Đăng Ký',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=>LoginScreen())
                          ); // Quay lại LoginScreen
                        },
                        child: const Text(
                          'Đã có tài khoản? Đăng nhập',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
