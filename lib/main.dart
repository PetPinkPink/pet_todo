import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  void toggleTheme() {
    setState(() => isDark = !isDark);
  }

  @override
  Widget build(BuildContext context) {
    
    const Color lightPurpleBg = Color(0xFFF3E5F5); 
    const Color darkPurpleBg = Color(0xFF1A1125); 

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet Todo',

      
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.deepPurple,
        
   
        scaffoldBackgroundColor: lightPurpleBg, 
        
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.deepPurple,
        
        
        scaffoldBackgroundColor: darkPurpleBg, 
      ),

      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

      home: LoginPage(onToggleTheme: toggleTheme, isDark: isDark),
    
      routes: {
        '/login': (context) => LoginPage(onToggleTheme: toggleTheme, isDark: isDark),
      },
    );
  }
}