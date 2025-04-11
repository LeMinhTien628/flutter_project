import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_food_delivery/models/user_model.dart';

class ApiService {
  static const String baseUrl =
      'http://192.168.189.1:5021'; //Không phải cổng local host nữa mà là địa chỉ ipv4
  // dotnet run --urls "http://0.0.0.0:5021" 
  //chạy bên api để chấp nhận mọi kết nối

  Future<LoginReponse> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/Auth/login');
    final request = LoginRequest(email: email, password: password);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    // print('Status: ${response.statusCode}, Body: ${response.body}');
    if (response.statusCode == 200) {
      print('Đăng nhập thành công');
      return LoginReponse.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body)['message'];
      print(error);
      throw Exception(error);
    }
  }

  Future<RegisterReponse> register(
    String username,
    String phone,
    String email,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/api/Auth/register');
    final request = RegisterRequest(
      username: username,
      phone: phone,
      email: email,
      password: password,
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
      print('Đăng ký thành công');
      return RegisterReponse.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body)['message'];
      throw Exception(error);
    }
  }
}
