import 'package:flutter/material.dart';
import '../models/todo_model.dart';
import 'stats_page.dart';
import 'todo_tab.dart';
import 'author_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  int _drawerIndex = 0; 
  int _bottomNavIndex = 0; 
  
  List<Todo> todos = [];
  List<Map<String, dynamic>> notes = [];
  final TextEditingController _noteController = TextEditingController();

  static const Color myPurple = Color.fromARGB(255, 194, 75, 237);

  @override
  void initState() {
    super.initState();
    _loadData();
  }


  void _showEditNoteDialog(int index) {
    final note = notes[index];
    final TextEditingController editController = TextEditingController(text: note['text']);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Sửa ghi chú", style: TextStyle(color: myPurple, fontWeight: FontWeight.bold)),
        content: TextField(controller: editController, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: myPurple),
            onPressed: () {
              if (editController.text.trim().isNotEmpty) {
                setState(() {
                  notes[index]['text'] = editController.text.trim();
                  notes[index]['time'] = DateTime.now();
                });
                _saveNotes();
                Navigator.pop(context);
              }
            },
            child: const Text("Lưu", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }


  void _showEditTodoDialog(Todo todo) {
    final TextEditingController editController = TextEditingController(text: todo.title);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Sửa công việc", style: TextStyle(color: myPurple, fontWeight: FontWeight.bold)),
        content: TextField(controller: editController, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: myPurple),
            onPressed: () {
              if (editController.text.trim().isNotEmpty) {
                setState(() {
                
                  todo.title = editController.text.trim();
                });
                _saveTodos();
                Navigator.pop(context);
              }
            },
            child: const Text("Lưu", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

 
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final todoData = prefs.getString("todos");
    final noteData = prefs.getString("notes");
    
    if (mounted) {
      setState(() {
        if (todoData != null) {
          final List<dynamic> list = jsonDecode(todoData);
          todos = list.map((e) => Todo(
            id: e['id'] ?? DateTime.now().toString(),
            title: e['title'],
            time: DateTime.parse(e['time']),
            done: e['done'] ?? false,
          )).toList();
        }
        if (noteData != null) {
          final List<dynamic> nList = jsonDecode(noteData);
          notes = nList.map((e) => {
            'id': e['id'],
            'text': e['text'],
            'time': DateTime.parse(e['time']),
          }).toList();
        }
      });
    }
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final data = todos.map((e) => {
      'id': e.id, 'title': e.title, 'time': e.time.toIso8601String(), 'done': e.done
    }).toList();
    await prefs.setString("todos", jsonEncode(data));
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = notes.map((e) => {
      'id': e['id'], 'text': e['text'], 'time': e['time'].toIso8601String()
    }).toList();
    await prefs.setString("notes", jsonEncode(data));
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> drawerPages = [
      _buildMainAppStructure(), 
      const AuthorPage(),       
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_drawerIndex == 0 ? "Pet Todo" : "Tác giả", 
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: myPurple,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.pets, color: Colors.white), 
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: _buildDrawer(),
      body: IndexedStack(
        index: _drawerIndex,
        children: drawerPages,
      ),
    );
  }

  Widget _buildMainAppStructure() {
    return Scaffold(
      body: IndexedStack(
        index: _bottomNavIndex,
        children: [
          TodoTab(
            todos: todos, 
            onAdd: (title, time) { 
              setState(() => todos.add(Todo(id: DateTime.now().toString(), title: title, time: time, done: false))); 
              _saveTodos(); 
            },
            onToggle: (todo, v) { setState(() => todo.done = v ?? false); _saveTodos(); },
            onDelete: (todo) { setState(() => todos.remove(todo)); _saveTodos(); }, 
            // FIX DÒNG 176: Khai báo rõ kiểu dữ liệu (Todo todo)
            onEdit: (Todo todo) => _showEditTodoDialog(todo), 
            drawer: Container()
          ),
          StatsPage(todos: todos),
          _buildNotesTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        selectedItemColor: myPurple,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Công việc"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Thống kê"),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: "Ghi chú"),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: myPurple),
            accountName: Text("Pet Todo", style: TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text("phiên bản 1.0.0"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white, 
              child: Icon(Icons.pets, color: myPurple, size: 35)
            ),
          ),
          _drawerItem(Icons.apps, "App", 0),
          _drawerItem(Icons.person, "Tác giả", 1),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Đăng xuất", style: TextStyle(color: Colors.red)),
            onTap: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: _drawerIndex == index ? myPurple : Colors.grey),
      title: Text(title, style: TextStyle(color: _drawerIndex == index ? myPurple : Colors.black, fontWeight: _drawerIndex == index ? FontWeight.bold : FontWeight.normal)),
      selected: _drawerIndex == index,
      onTap: () {
        setState(() => _drawerIndex = index);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildNotesTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    hintText: "Nhập ghi chú...",
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.send, color: myPurple), 
                onPressed: () {
                  if (_noteController.text.trim().isNotEmpty) {
                    setState(() {
                      notes.insert(0, {
                        'id': DateTime.now().toString(),
                        'text': _noteController.text,
                        'time': DateTime.now()
                      });
                      _noteController.clear();
                    });
                    _saveNotes();
                  }
                }
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, i) {
              final n = notes[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(

                  
                  onTap: () => _showEditNoteDialog(i), // Nhấn để sửa ghi chú
                  title: Text(n['text']),
                  subtitle: Text("${n['time'].hour}:${n['time'].minute.toString().padLeft(2, '0')}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () { setState(() => notes.removeAt(i)); _saveNotes(); }
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}