import 'package:flutter/material.dart';
import 'main_app_screen.dart';
import 'author_page.dart';

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
            style: const TextStyle(
              fontSize: 32, 
              fontWeight: FontWeight.bold, 
              color: myPurple,
              letterSpacing: 1.1
            ),
          ),
          const SizedBox(height: 40),
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
        centerTitle: true,
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
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('images/logo.png'),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Pet Todo", 
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              
   
              ListTile(
                leading: Icon(
                  Icons.apps, 
                  color: _currentDrawerIndex == 0 ? myPurple : (isDark ? Colors.white70 : Colors.grey)
                ),
                title: Text(
                  "App", 
                  style: TextStyle(
                   
                    color: _currentDrawerIndex == 0 
                        ? myPurple 
                        : (isDark ? Colors.white : Colors.black87),
                    fontWeight: _currentDrawerIndex == 0 ? FontWeight.bold : FontWeight.normal
                  )
                ),
                selected: _currentDrawerIndex == 0,
                onTap: () {
                  setState(() => _currentDrawerIndex = 0);
                  Navigator.pop(context);
                },
              ),
         
              ListTile(
                leading: Icon(
                  Icons.person_outline, 
                  color: _currentDrawerIndex == 1 ? myPurple : (isDark ? Colors.white70 : Colors.grey)
                ),
                title: Text(
                  "Tác giả", 
                  style: TextStyle(
                  
                    color: _currentDrawerIndex == 1 
                        ? myPurple 
                        : (isDark ? Colors.white : Colors.black87),
                    fontWeight: _currentDrawerIndex == 1 ? FontWeight.bold : FontWeight.normal
                  )
                ),
                selected: _currentDrawerIndex == 1,
                onTap: () {
                  setState(() => _currentDrawerIndex = 1);
                  Navigator.pop(context);
                },
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