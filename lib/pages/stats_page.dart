import 'package:flutter/material.dart';
import '../models/todo_model.dart';

class StatsPage extends StatefulWidget {
  final List<Todo> todos;
  const StatsPage({super.key, required this.todos});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  int _selectedType = 0; 
  static const Color myPurple = Color(0xFFC35CEC);
  static const Color myPurpleLight = Color(0x26C35CEC);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    List<Todo> filtered = widget.todos.where((t) {
      if (_selectedType == 0) return _isSameDay(t.time, now);
      if (_selectedType == 1) return t.time.isAfter(now.subtract(const Duration(days: 7)));
      return t.time.month == now.month && t.time.year == now.year;
    }).toList();

    List<Todo> completedHistory = filtered.where((t) => t.done).toList();
    double percent = filtered.isEmpty ? 0.0 : completedHistory.length / filtered.length;

    return Container(
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        children: [
          _buildSwitchTab(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _selectedType == 0 
                      ? _buildDailyCircle(percent) 
                      : (_selectedType == 1 ? _buildWeeklyBar(widget.todos) : _buildMonthlyHeatmap(widget.todos)),
                  const SizedBox(height: 40),
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: ExpansionTile(
                      leading: const Icon(Icons.history, color: myPurple),
                      title: const Text("Lịch sử công việc", style: TextStyle(fontWeight: FontWeight.bold, color: myPurple)),
                      subtitle: Text("Đã xong ${completedHistory.length} mục"),
                      children: completedHistory.map((item) => ListTile(
                        dense: true,
                        leading: const Icon(Icons.check_circle, color: Colors.green, size: 18),
                        title: Text(item.title),
                        subtitle: Text("${item.time.hour}:${item.time.minute} - ${item.time.day}/${item.time.month}"),
                      )).toList(),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDailyCircle(double percent) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(width: 160, height: 160, child: CircularProgressIndicator(value: percent, strokeWidth: 12, color: myPurple, backgroundColor: myPurpleLight, strokeCap: StrokeCap.round)),
        Text("${(percent * 100).toInt()}%", style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: myPurple)),
      ],
    );
  }

  Widget _buildWeeklyBar(List<Todo> all) {
    final now = DateTime.now();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(7, (i) {
        DateTime date = now.subtract(Duration(days: 6 - i));
        int count = all.where((t) => _isSameDay(t.time, date) && t.done).length;
        return Column(
          children: [
            Container(width: 15, height: count * 15.0 + 5, decoration: BoxDecoration(color: _isSameDay(date, now) ? myPurple : myPurpleLight, borderRadius: BorderRadius.circular(5))),
            const SizedBox(height: 5),
            Text("${date.day}", style: const TextStyle(fontSize: 10)),
          ],
        );
      }),
    );
  }

  Widget _buildMonthlyHeatmap(List<Todo> all) {
    return Wrap(
      spacing: 4, runSpacing: 4,
      children: List.generate(30, (i) {
        DateTime date = DateTime(DateTime.now().year, DateTime.now().month, i + 1);
        int count = all.where((t) => _isSameDay(t.time, date) && t.done).length;
        return Container(
          width: 25, height: 25,
          decoration: BoxDecoration(color: count == 0 ? myPurpleLight : myPurple, borderRadius: BorderRadius.circular(4)),
        );
      }),
    );
  }

  bool _isSameDay(DateTime d1, DateTime d2) => d1.day == d2.day && d1.month == d2.month && d1.year == d2.year;

  Widget _buildSwitchTab() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: myPurpleLight, borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: List.generate(3, (i) => Expanded(
          child: InkWell(
            onTap: () => setState(() => _selectedType = i),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(color: _selectedType == i ? myPurple : Colors.transparent, borderRadius: BorderRadius.circular(30)),
              child: Text(["Ngày", "Tuần", "Tháng"][i], textAlign: TextAlign.center, style: TextStyle(color: _selectedType == i ? Colors.white : myPurple, fontWeight: FontWeight.bold)),
            ),
          ),
        )),
      ),
    );
  }
}