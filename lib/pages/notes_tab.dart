import 'package:flutter/material.dart';

class NoteItem {
  final String id;
  final String content;
  final DateTime time;

  NoteItem({required this.id, required this.content, required this.time});
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {

  static const Color myPurple = Color(0xFFC35CEC); 


  final TextEditingController _controller = TextEditingController();

  List<NoteItem> _notes = [
    NoteItem(id: '1', content: "Nhập ghi chú mới ở trên nhé ✨", time: DateTime.now()),
  ];


  void _addNote() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        _notes.insert(0, NoteItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: _controller.text,
          time: DateTime.now(),
        ));
        _controller.clear();
      });
    }
  }


  void _deleteNote(String id) {
    setState(() {
      _notes.removeWhere((note) => note.id == id);
    });
    

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Đã xóa ghi chú"),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent, 
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
    
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.white,
                borderRadius: BorderRadius.circular(12),
                // ignore: deprecated_member_use
                border: Border.all(color: myPurple.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Nhập ghi chú hôm nay...",
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _addNote(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send_rounded, color: myPurple),
                    onPressed: _addNote,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

      
            Expanded(
              child: _notes.isEmpty
                  ? const Center(child: Text("Hết ghi chú rồi!"))
                  : ListView.builder(
                      itemCount: _notes.length,
                      itemBuilder: (context, index) {
                        final note = _notes[index];
                        
                        return Dismissible(
                          key: Key(note.id),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) => _deleteNote(note.id),
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                            child: ListTile(
                              leading: const Icon(Icons.note_rounded, color: Colors.orangeAccent),
                              title: Text(note.content),
                              subtitle: Text("Lưu lúc: ${note.time.hour}:${note.time.minute.toString().padLeft(2, '0')} - ${note.time.day}/${note.time.month}"),
                             
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent),
                                onPressed: () => _deleteNote(note.id),
                              ),
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