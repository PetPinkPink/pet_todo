import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final user = TextEditingController();
  final pass = TextEditingController();
  final email = TextEditingController();
  
  String gender = "Nam"; 
  int birthYear = 2000;

  void _showYearPicker() {
    final Color uniformBg = Theme.of(context).scaffoldBackgroundColor;

    showModalBottomSheet(
      context: context,
      backgroundColor: uniformBg, 
      builder: (_) => SizedBox(
        height: 250,
        child: CupertinoPicker(
          itemExtent: 40,
          scrollController: FixedExtentScrollController(initialItem: birthYear - 1950),
          onSelectedItemChanged: (index) => setState(() => birthYear = 1950 + index),
          children: List.generate(80, (i) => Center(child: Text("${1950 + i}"))),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color uniformBg = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
    
      backgroundColor: uniformBg,
      appBar: AppBar(
        title: const Text("Đăng Ký"), 
        backgroundColor: const Color.fromARGB(255, 195, 92, 236),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Username
            TextField(
              controller: user, 
              decoration: const InputDecoration(labelText: "Username", prefixIcon: Icon(Icons.person))
            ),
            const SizedBox(height: 15),
            // Password
            TextField(
              controller: pass, 
              obscureText: true, 
              decoration: const InputDecoration(labelText: "Password", prefixIcon: Icon(Icons.lock))
            ),
            const SizedBox(height: 15),
            // Email
            TextField(
              controller: email, 
              decoration: const InputDecoration(labelText: "Email đăng ký", prefixIcon: Icon(Icons.email))
            ),
            const SizedBox(height: 20),
            
            
            Row(
              children: [
                const Text("Giới tính: ", style: TextStyle(fontWeight: FontWeight.bold)),
                Radio(
                  value: "Nam", 
                  groupValue: gender, 
                  activeColor: const Color.fromARGB(255, 195, 92, 236), 
                  onChanged: (v) => setState(() => gender = v.toString())
                ),
                const Text("Nam"),
                Radio(
                  value: "Nữ", 
                  groupValue: gender, 
                  activeColor: const Color.fromARGB(255, 195, 92, 236),
                  onChanged: (v) => setState(() => gender = v.toString())
                ),
                const Text("Nữ"),
              ],
            ),
            
            // Chọn Năm sinh
            ListTile(
              title: const Text("Năm sinh"),
              trailing: Text("$birthYear", style: const TextStyle(color: Color.fromARGB(255, 195, 92, 236), fontWeight: FontWeight.bold, fontSize: 18)),
              onTap: _showYearPicker,
              tileColor: isDark ? Colors.white10 : Colors.white.withOpacity(0.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 195, 92, 236),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đăng ký thành công!")));
                  Navigator.pop(context);
                },
                child: const Text("HOÀN TẤT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}