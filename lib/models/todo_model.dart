class Todo {
  final String id;
  final String title;
  bool done;
  final DateTime time; 

  Todo({
    required this.id,
    required this.title,
    this.done = false,
    required this.time,
  });
}