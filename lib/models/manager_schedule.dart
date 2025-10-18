class ToDoModel {
  String title;
  String description;
  String date;
  int id;

  ToDoModel({
    required this.date,
    required this.description,
    required this.title,
    this.id = 0,
  });
}