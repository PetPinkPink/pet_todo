import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; 
import 'todo_tab.dart';
import 'stats_page.dart';
import '../models/todo_model.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key, required String username});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> with AutomaticKeepAliveClientMixin {
  int _bottomIndex = 0;
  List<Todo> todos = []; 
  List<Map<String, dynamic>> notes = []; 
  final TextEditingController _noteController = TextEditingController();
  
  bool _isLoadingApi = false;

  static const Color myPurple = Color.fromARGB(255, 194, 75, 237);

  @override
  bool get wantKeepAlive => true; 

  @override
  void initState() {
    super.initState();
    _fetchApiTodos();
  }


  void _showEditTodoDialog(Todo todo) {
    final TextEditingController editController = TextEditingController(text: todo.title);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
                Navigator.pop(context);
              }
            },
            child: const Text("Lưu", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditNoteDialog(int index) {
    final note = notes[index];
    final TextEditingController editController = TextEditingController(text: note['text']);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
                Navigator.pop(context);
              }
            },
            child: const Text("Lưu", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchApiTodos() async {
    if (todos.any((t) => t.id.startsWith("api_"))) return;
    setState(() => _isLoadingApi = true);
    final dio = Dio();
    try {
      final response = await dio.get('https://dummyjson.com/todos?limit=5');
      if (response.statusCode == 200) {
        List<dynamic> apiData = response.data['todos'];
        setState(() {
          for (var item in apiData) {
            todos.add(Todo(
              id: "api_${item['id']}", 
              title: "🐾 ${item['todo']}", 
              time: DateTime.now(),
              done: item['completed']
            ));
          }
        });
      }
    } catch (e) {
      debugPrint("Lỗi API: $e");
    } finally {
      if (mounted) setState(() => _isLoadingApi = false);
    }
  }

  void _addNote() {
    String text = _noteController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        notes.insert(0, {
          'id': DateTime.now().millisecondsSinceEpoch.toString(), 
          'text': text,
          'time': DateTime.now(),
        });
        _noteController.clear();
      });
      FocusScope.of(context).unfocus(); 
    }
  }

  void _deleteNote(int index) {
    setState(() => notes.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đã xóa ghi chú!"), duration: Duration(seconds: 1), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); 

    final List<Widget> _tabs = [
      _isLoadingApi
      ? const Center(child: CircularProgressIndicator(color: myPurple))
      : TodoTab(
          todos: todos,
          onAdd: (title, time) => setState(() => todos.add(Todo(id: DateTime.now().toString(), title: title, time: time))),
          onToggle: (t, v) => setState(() => t.done = v ?? false),
          onDelete: (t) => setState(() => todos.remove(t)), 
          
          onEdit: (Todo t) => _showEditTodoDialog(t), 
          drawer: Container()
        ),
      StatsPage(todos: todos),
      _buildNotesTab(),
    ];

    return Scaffold(
      body: IndexedStack(index: _bottomIndex, children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomIndex,
        selectedItemColor: myPurple, 
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _bottomIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Công việc"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Thống kê"),
          BottomNavigationBarItem(icon: Icon(Icons.note_alt), label: "Ghi chú"),
        ],
      ),
    );
  }

  Widget _buildNotesTab() {
    return Column(
      children: [
        const SizedBox(height: 40), 
        const Text("Ghi chú", 
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: myPurple)),
        
        Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    hintText: "Nhập ghi chú hôm nay...", 
                    filled: true,
                    fillColor: myPurple.withOpacity(0.1),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20)
                  ),
                  onSubmitted: (_) => _addNote(),
                ),
              ),
              const SizedBox(width: 10),
              CircleAvatar(
                backgroundColor: myPurple,
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white, size: 20), 
                  onPressed: _addNote
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: notes.isEmpty
          ? const Center(child: Text("Chưa có ghi chú nào", style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: notes.length,
              itemBuilder: (context, i) {
                final n = notes[i];
                final String formattedTime = "${n['time'].hour}:${n['time'].minute.toString().padLeft(2, '0')}";

                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: myPurple.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: ListTile(
                    
                    onTap: () => _showEditNoteDialog(i),
                    leading: const Icon(Icons.edit_note, color: Colors.orangeAccent),
                    title: Text(n['text'] ?? "", style: const TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Text("Lưu lúc: $formattedTime - ${n['time'].day}/${n['time'].month}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () => _deleteNote(i),
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