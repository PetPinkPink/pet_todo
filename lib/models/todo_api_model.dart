class TodoApi {
  final int id;
  final String todo;
  final bool completed;

  TodoApi({required this.id, required this.todo, required this.completed});

 
  factory TodoApi.fromJson(Map<String, dynamic> json) {
    return TodoApi(
      id: json['id'],
      todo: json['todo'],
      completed: json['completed'],
    );
  }
}