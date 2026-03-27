import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; 
import '../models/todo_model.dart';

class TodoTab extends StatelessWidget {
  final List<Todo> todos;
  final Function(String title, DateTime time) onAdd;
  final Function(Todo, bool?) onToggle;
  final Function(Todo) onDelete;
  final Function(Todo) onEdit; 

  const TodoTab({
    super.key,
    required this.todos,
    required this.onAdd,
    required this.onToggle,
    required this.onDelete, 
    required this.onEdit, 
    required Widget drawer, 
  });

  static const Color myPurple = Color.fromARGB(255, 195, 92, 236);

  String formatDateTime(DateTime d) {
    return "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} - ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";
  }


  void _showAddDialog(BuildContext context) {
    final TextEditingController _taskController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    DateTime selectedTime = DateTime.now();
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 20, right: 20, top: 20
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 15),
            Text("Thêm công việc mới", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: myPurple)),
            const SizedBox(height: 15),
            TextField(
              controller: _taskController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Bạn cần làm gì?",
                prefixIcon: const Icon(Icons.edit, color: myPurple),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildPickerColumn("Ngày", CupertinoDatePickerMode.date, (d) => selectedDate = d)),
                Expanded(child: _buildPickerColumn("Giờ", CupertinoDatePickerMode.time, (t) => selectedTime = t)),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: myPurple, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  if (_taskController.text.isNotEmpty) {
                    onAdd(_taskController.text, DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute));
                    Navigator.pop(context);
                  }
                },
                child: const Text("XÁC NHẬN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerColumn(String label, CupertinoDatePickerMode mode, Function(DateTime) onChanged) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        SizedBox(
          height: 100,
          child: CupertinoDatePicker(
            mode: mode,
            use24hFormat: true,
            onDateTimeChanged: onChanged,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color bg = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: bg,
      body: todos.isEmpty
          ? const Center(child: Text("Chưa có công việc nào!"))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: todos.length,
              itemBuilder: (context, i) {
                final t = todos[i];
                return Card(
                  elevation: 0.5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    onTap: () => onEdit(t), 
                    leading: Checkbox(value: t.done, activeColor: myPurple, onChanged: (v) => onToggle(t, v)),
                    title: Text(t.title, style: TextStyle(decoration: t.done ? TextDecoration.lineThrough : null, fontWeight: FontWeight.bold)),
                    subtitle: Text(formatDateTime(t.time)),
                    trailing: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent), onPressed: () => onDelete(t)),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: myPurple,
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}