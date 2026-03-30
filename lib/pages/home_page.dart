import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; 
import 'dart:io'; 
import 'package:flutter/foundation.dart' show kIsWeb; 
import 'main_app_screen.dart';
import 'author_page.dart';


String? globalImagePath;

class HomePage extends StatefulWidget {
  final String username;
  final VoidCallback onToggleTheme;
  const HomePage({super.key, required this.username, required this.onToggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentDrawerIndex = -1; 
  static const Color myPurple = Color.fromARGB(255, 195, 88, 234);

  String getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) return "Chào buổi sáng ☀️";
    if (hour < 18) return "Chào buổi chiều 🌤️";
    return "Chào buổi tối 🌙";
  }

  void _showEmilyProfile(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EmilyProfilePage()),
    );
    setState(() {}); 
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color uniformBg = Theme.of(context).scaffoldBackgroundColor;

    Widget welcomeScreen = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.pets, size: 100, color: myPurple),
          const SizedBox(height: 25),
          Text(getGreeting(), style: const TextStyle(fontSize: 20, color: Colors.grey)),
          const SizedBox(height: 10),
          Text(
            widget.username, 
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: myPurple, letterSpacing: 1.1),
          ),
          const SizedBox(height: 60), 
        ],
      ),
    );

    return Scaffold(
      backgroundColor: uniformBg, 
      appBar: AppBar(
        title: InkWell(
          onTap: () => setState(() => _currentDrawerIndex = -1),
          child: const Text("Pet Todo", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        centerTitle: false,
        backgroundColor: myPurple,
        foregroundColor: Colors.white,
        elevation: 0, 
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu), 
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onToggleTheme,
          ),
          
          
          Padding(
            padding: const EdgeInsets.only(right: 15, left: 5),
            child: GestureDetector(
              onTap: () => _showEmilyProfile(context),
              child: Container(
                padding: const EdgeInsets.all(1.5),
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  backgroundImage: globalImagePath != null
                      ? (kIsWeb ? NetworkImage(globalImagePath!) : FileImage(File(globalImagePath!)) as ImageProvider)
                      : const AssetImage('images/logo.png'), 
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: uniformBg,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                color: myPurple,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: globalImagePath != null
                          ? (kIsWeb ? NetworkImage(globalImagePath!) : FileImage(File(globalImagePath!)) as ImageProvider)
                          : const AssetImage('images/logo.png'),
                    ),
                    const SizedBox(height: 15),
                    const Text("Pet Todo", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.apps, color: _currentDrawerIndex == 0 ? myPurple : (isDark ? Colors.white70 : Colors.grey)),
                title: Text("App", style: TextStyle(color: _currentDrawerIndex == 0 ? myPurple : (isDark ? Colors.white : Colors.black87))),
                onTap: () { setState(() => _currentDrawerIndex = 0); Navigator.pop(context); },
              ),
              ListTile(
                leading: Icon(Icons.person_outline, color: _currentDrawerIndex == 1 ? myPurple : (isDark ? Colors.white70 : Colors.grey)),
                title: Text("Tác giả", style: TextStyle(color: _currentDrawerIndex == 1 ? myPurple : (isDark ? Colors.white : Colors.black87))),
                onTap: () { setState(() => _currentDrawerIndex = 1); Navigator.pop(context); },
              ),
              const Spacer(),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text("Đăng xuất", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                onTap: () => Navigator.pushReplacementNamed(context, '/login'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      body: _currentDrawerIndex == -1 
          ? welcomeScreen 
          : IndexedStack(
              index: _currentDrawerIndex,
              children: [
                MainAppScreen(username: widget.username), 
                const AuthorPage(),
              ],
            ),
    );
  }
}

class EmilyProfilePage extends StatefulWidget {
  const EmilyProfilePage({super.key});
  @override
  State<EmilyProfilePage> createState() => _EmilyProfilePageState();
}

class _EmilyProfilePageState extends State<EmilyProfilePage> {
  static const Color emilyPurple = Color.fromARGB(255, 195, 88, 234);
  bool _isEditing = false;
  final ImagePicker _picker = ImagePicker();

  final _nameController = TextEditingController(text: 'Emily Smith');
  final _emailController = TextEditingController(text: 'emily.smith@example.com');
  final _phoneController = TextEditingController(text: '0 123 456 789');
  final _birthdayController = TextEditingController(text: '15 tháng 5');
  final _goalController = TextEditingController(text: 'Sống kỷ luật hơn, cố gắng hơn ngày hôm qua');

  Future<void> _getImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        globalImagePath = pickedFile.path; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emily\'s Profile'),
        backgroundColor: emilyPurple,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () => setState(() => _isEditing = !_isEditing),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Stack(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundColor: emilyPurple,
                  backgroundImage: globalImagePath != null 
                    ? (kIsWeb ? NetworkImage(globalImagePath!) : FileImage(File(globalImagePath!)) as ImageProvider)
                    : const AssetImage('images/logo.png'),
                ),
                if (_isEditing)
                  Positioned(
                    bottom: 0, right: 0,
                    child: CircleAvatar(
                      backgroundColor: emilyPurple,
                      child: IconButton(icon: const Icon(Icons.camera_alt, color: Colors.white), onPressed: _getImage),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            _buildField("Họ tên", _nameController),
            _buildField("Email", _emailController),
            _buildField("Số điện thoại", _phoneController),
            _buildField("Ngày sinh", _birthdayController),
            _buildField("Mục tiêu", _goalController),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        enabled: _isEditing,
        style: TextStyle(color: _isEditing ? emilyPurple : Colors.grey),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: emilyPurple),
          border: _isEditing ? const OutlineInputBorder() : InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}