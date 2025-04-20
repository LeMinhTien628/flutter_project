import 'package:flutter/material.dart';
import 'package:app_food_delivery/core/constants/app_colors.dart';

class EVoucherScreen extends StatefulWidget {
  const EVoucherScreen({super.key});

  @override
  State<EVoucherScreen> createState() => _EVoucherScreenState();
}

class _EVoucherScreenState extends State<EVoucherScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _voucherController = TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose(); // Giải phóng FocusNode
    _voucherController.dispose(); // Giải phóng TextEditingController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return 
    
    Scaffold(
      resizeToAvoidBottomInset: true, // Điều chỉnh giao diện khi bàn phím xuất hiện
      body: GestureDetector(
        onTap: () => _focusNode.unfocus(), // Ẩn bàn phím khi chạm ra ngoài
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                const Text(
                  "Bạn có mã E-Voucher tại YummyGo không?",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Nhập mã E-Voucher của bạn vào ô dưới đây để nhận ưu đãi",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 36,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              bottomLeft: Radius.circular(4),
                            ),
                            border: Border.all(
                              width: 1,
                              color: AppColors.border,
                            ),
                          ),
                          child: TextField(
                            controller: _voucherController,
                            focusNode: _focusNode,
                            onChanged: (value) {
                              // Thêm logic kiểm tra mã voucher tại đây
                              // Ví dụ: Kiểm tra mã có hợp lệ không
                            },
                            cursorColor: AppColors.primary,
                            cursorRadius: const Radius.circular(10),
                            cursorHeight: 14,
                            cursorWidth: 2,
                            cursorOpacityAnimates: true,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Nhập mã E-Voucher",
                              hintStyle: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Thêm logic áp dụng mã voucher
                          final code = _voucherController.text;
                          if (code.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Đang áp dụng mã: $code")),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Vui lòng nhập mã voucher")),
                            );
                          }
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.background,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(4),
                              bottomRight: Radius.circular(4),
                            ),
                          ),
                        ),
                        child: const Text(
                          "Áp dụng",
                          style: TextStyle(
                            color: AppColors.background,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      // Thêm logic chuyển hướng đến màn hình đăng nhập
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Chuyển hướng đến đăng nhập")),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.background,
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      side: const BorderSide(
                        color: AppColors.border,
                        width: 1,
                      ),
                    ),
                    child: const Text(
                      "Đăng nhập để nhận thêm ưu đãi",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 90),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Image.asset(
                    "assets/images/yummygo_logo.png",
                    width: 100,
                    height: 100,
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
 
  }
}