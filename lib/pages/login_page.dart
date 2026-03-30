import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; 
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  
  const LoginPage({super.key, required this.onToggleTheme, required bool isDark});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final user = TextEditingController();
  final pass = TextEditingController();

  
  static const Color myPurple = Color.fromARGB(255, 194, 75, 237);

  Future<void> _handleApiLogin() async {
    String inputUser = user.text.trim();
    String inputPass = pass.text.trim();

    if (inputUser.isEmpty || inputPass.isEmpty) {
      _showSnackBar("Nhập đủ Username và Password");
      return;
    }

    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: myPurple)),
    );

    try {
      final dio = Dio();
      final response = await dio.post(
        'https://dummyjson.com/auth/login',
        data: {
          'username': inputUser,   
          'password': inputPass,   
          'expiresInMins': 30,
        },
      );

      if (mounted) Navigator.pop(context); 

      if (response.statusCode == 200) {
        String nameFromServer = response.data['firstName'];
        
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomePage(
                username: nameFromServer, 
                onToggleTheme: widget.onToggleTheme,
              ),
            ),
          );
        }
      }
    } on DioException catch (e) {
      if (mounted) Navigator.pop(context); 
      _showSnackBar("Sai tài khoản hoặc mật khẩu");
      debugPrint("Lỗi Login: ${e.message}");
    }
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, 
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 350, 
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo Icon
                const Icon(Icons.pets, size: 80, color: myPurple),
                const SizedBox(height: 10),
                const Text(
                  "PET TODO",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: myPurple, letterSpacing: 2),
                ),
                const SizedBox(height: 40),
                
                // Ô nhập Username
                TextField(
                  controller: user, 
                  decoration: InputDecoration(
                    hintText: "Username", 
                    prefixIcon: const Icon(Icons.person_outline, color: myPurple),
                    filled: true,
                    fillColor: myPurple.withOpacity(0.05),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  )
                ),
                const SizedBox(height: 20),
                
                // Ô nhập Password
                TextField(
                  controller: pass, 
                  obscureText: true, 
                  decoration: InputDecoration(
                    hintText: "Password", 
                    prefixIcon: const Icon(Icons.lock_outline, color: myPurple),
                    filled: true,
                    fillColor: myPurple.withOpacity(0.05),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  )
                ),
                const SizedBox(height: 30),
                
                // Nút Đăng nhập
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: myPurple, 
                      foregroundColor: Colors.white, 
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                    ),
                    onPressed: _handleApiLogin, 
                    child: const Text("ĐĂNG NHẬP", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage())),
                  child: const Text(
                    "Chưa có tài khoản? Đăng ký ngay", 
                    style: TextStyle(color: myPurple, fontWeight: FontWeight.w500)
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