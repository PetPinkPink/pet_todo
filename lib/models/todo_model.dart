class Todo {
  final String id;    
  String title;       
  bool done;          
  DateTime time;     

  Todo({
    required this.id,
    required this.title,
    this.done = false,
    required this.time,
  });
}