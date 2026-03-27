import 'package:flutter/material.dart';

class AuthorPage extends StatelessWidget {
  const AuthorPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    const Color myPurple = Color.fromARGB(255, 194, 75, 237);

    return Scaffold(
      
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView( 
          child: Container(
            padding: const EdgeInsets.all(25),
            margin: const EdgeInsets.all(25),
            decoration: BoxDecoration(
             
              color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF3E5F5),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: myPurple.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
              border: Border.all(
                color: myPurple.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                
                Container(
                  padding: const EdgeInsets.all(4), 
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: myPurple,
                  ),
                  child: const CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage("images/anhdaidien.jpg"),
                  ),
                ),
                const SizedBox(height: 20),
                
               
                Text(
                  "Nguyễn Thu Trang",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: myPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    "MSV: 23T1020557",
                    style: TextStyle(
                      fontSize: 16,
                      color: myPurple,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                const Divider(thickness: 1),
                const SizedBox(height: 20),
                
                
                const Text(
                  "Sinh viên Công nghệ phần mềm",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                
                const SizedBox(height: 10),
                
        
                const Text(
                  "\"Intargram: petpinkpink \"", 
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    color: myPurple,
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