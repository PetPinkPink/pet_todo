import 'package:flutter/material.dart';

class NoteItem {
  final String id;
  String content; 
  final DateTime time;

  NoteItem({required this.id, required this.content, required this.time});
}

class NotesPage extends StatefulWidget {

  final String? username;
  const NotesPage({super.key, this.username});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
 
  static const Color myPurple = Color.fromARGB(255, 194, 75, 237); 
  final TextEditingController _controller = TextEditingController();

  List<NoteItem> _notes = [
    NoteItem(id: '1', content: "🐾 Chào mừng bạn đến với Pet Todo!", time: DateTime.now()),
  ];

  void _addNote() {
    String text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _notes.insert(0, NoteItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: text,
          time: DateTime.now(),
        ));
        _controller.clear();
      });
    
      FocusScope.of(context).unfocus();
    }
  }

  void _showEditNoteDialog(NoteItem note) {
    final TextEditingController editController = TextEditingController(text: note.content);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Sửa ghi chú", 
          style: TextStyle(color: myPurple, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: editController, 
          autofocus: true,
          decoration: const InputDecoration(hintText: "Nhập nội dung mới..."),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: myPurple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
            ),
            onPressed: () {
              if (editController.text.trim().isNotEmpty) {
                setState(() { note.content = editController.text.trim(); }); 
                Navigator.pop(context);
              }
            },
            child: const Text("Lưu", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteNote(String id) {
    setState(() { _notes.removeWhere((n) => n.id == id); });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đã xóa ghi chú!"), behavior: SnackBarBehavior.floating, duration: Duration(seconds: 1))
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
     
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 10),
    
            Text(
              widget.username != null ? "Ghi chú của ${widget.username}" : "Ghi chú cá nhân",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: myPurple),
            ),
            const SizedBox(height: 20),
       
            TextField(
              controller: _controller,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                hintText: "Ghi lại ý tưởng mới...",
                filled: true,
                fillColor: myPurple.withOpacity(0.1),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send_rounded, color: myPurple), 
                  onPressed: _addNote
                ),
              ),
              onSubmitted: (_) => _addNote(),
            ),
            const SizedBox(height: 20),
           
            Expanded(
              child: _notes.isEmpty 
              ? const Center(child: Text("Chưa có ghi chú nào 🐾", style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  final note = _notes[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                    child: ListTile(
                      onTap: () => _showEditNoteDialog(note),
                      leading: const Icon(Icons.note_alt_outlined, color: myPurple),
                      title: Text(
                        note.content,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      subtitle: Text(
                        "${note.time.hour}:${note.time.minute.toString().padLeft(2, '0')} - ${note.time.day}/${note.time.month}",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent), 
                        onPressed: () => _deleteNote(note.id)
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}