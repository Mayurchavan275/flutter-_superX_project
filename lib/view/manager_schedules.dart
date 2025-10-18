import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manager_side/database/schedule.dart';
import 'package:manager_side/models/manager_schedule.dart';

import 'package:intl/intl.dart';

//import 'package:intl/intl.dart';
class ManagerSchedules extends StatefulWidget {
  const ManagerSchedules({super.key});

  @override
  State createState() => _ManagerSchedules();
}

class _ManagerSchedules extends State {
  TextEditingController titleController = TextEditingController();
  TextEditingController discriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  List<ToDoModel> todoCard = [];

  List cardColorsList = [
    Color.fromRGBO(250, 232, 232, 1),
    Color.fromRGBO(232, 237, 250, 1),
    Color.fromRGBO(250, 249, 232, 1),
    Color.fromRGBO(250, 232, 250, 1),
  ];
  //intitalizer
  @override
  void initState() {
    super.initState();
    getData();
  }

  //get Dtata
  void getData() async {
    List<Map> cardList = await TodoDatabase().getTodoItems();
    for (var element in cardList) {
      todoCard.add(
        ToDoModel(
          date: element['date'],
          description: element['description'],
          title: element['title'],
          id: element['id'],
        ),
      );
    }
    setState(() {});
  }

  void clearController() {
    titleController.clear();
    discriptionController.clear();
    dateController.clear();
  }

  void submit(bool doEdit, [ToDoModel? obj]) {
    if (titleController.text.isNotEmpty &&
        discriptionController.text.isNotEmpty &&
        dateController.text.isNotEmpty) {
      if (doEdit) {
        obj!.title = titleController.text;
        obj.description = discriptionController.text;
        obj.date = dateController.text;

        Map<String, dynamic> mapObj = {
          'title': obj.title,
          'description': obj.description,
          'date': obj.date,
          'id': obj.id,
        };
        TodoDatabase().updateTodoItem(mapObj);
      } else {
        todoCard.add(
          ToDoModel(
            title: titleController.text,
            description: discriptionController.text,
            date: dateController.text,
          ),
        );
        Map<String, dynamic> dataMap = {
          'title': titleController.text,
          'description': discriptionController.text,
          'date': dateController.text,
        };
        TodoDatabase().insertTodoItem(dataMap);
      }
      clearController();
      Navigator.of(context).pop();
      setState(() {});
    }
  }

  showBottomSheet(bool doEdit, [ToDoModel? obj]) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Today's Schedule",
                    style: GoogleFonts.quicksand(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "Taske",
                style: GoogleFonts.quicksand(
                  fontSize: 22,
                  color: Color.fromRGBO(2, 167, 177, 1),
                ),
              ),

              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Color.fromRGBO(2, 167, 177, 1),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Description",
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  color: Color.fromRGBO(2, 167, 177, 1),
                ),
              ),

              TextField(
                controller: discriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Color.fromRGBO(2, 167, 177, 1),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Date",
                style: GoogleFonts.quicksand(
                  fontSize: 22,
                  color: Color.fromRGBO(2, 167, 177, 1),
                ),
              ),

              TextField(
                controller: dateController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Color.fromRGBO(2, 167, 177, 1),
                    ),
                  ),
                  suffixIcon: Icon(Icons.calendar_month_outlined),
                ),
                onTap: () async {
                  DateTime? pickDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2025),
                    lastDate: DateTime(2036),
                  );
                  dateController.text = DateFormat.yMMMd().format(pickDate!);
                },
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (doEdit) {
                        submit(doEdit, obj);
                      } else {
                        submit(doEdit);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Color.fromRGBO(2, 167, 177, 1),
                      ),
                    ),
                    child: Text("Submit"),
                  ),
                ],
              ),
              SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(2, 167, 177, 1.0),
        title: Text(
          "Today's Schedule",
          style: GoogleFonts.quicksand(
            fontSize: 30,
            color: Color.fromRGBO(255, 255, 255, 1.0),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: todoCard.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsetsGeometry.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: cardColorsList[index % cardColorsList.length],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: ClipOval(
                          child: Image.network(
                            "https://play-lh.googleusercontent.com/BOt2x0R2JIaGOpMu-tVBWV8PLgu88gorbRTUfaNhKBoBBFxL_Qgcl-gPRKohHPLamsU=w240-h480-rw",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              todoCard[index].title,
                              style: GoogleFonts.quicksand(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              todoCard[index]
                                  .description, // ✅ now description shows
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: Row(
                      children: [
                        Text(
                          todoCard[index].date,
                          style: GoogleFonts.quicksand(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            titleController.text = todoCard[index].title;
                            discriptionController.text =
                                todoCard[index].description;
                            dateController.text = todoCard[index].date;
                            showBottomSheet(true, todoCard[index]);
                          },
                          child: Icon(Icons.edit_outlined),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            int id = todoCard[index].id;

                            todoCard.remove(todoCard[index]);
                            TodoDatabase().deleteTodoItem(id);

                            setState(() {});
                          },
                          child: Icon(Icons.delete_outline_rounded),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          clearController();
          showBottomSheet(false);
        },
        backgroundColor: Color.fromRGBO(2, 167, 177, 1),
        child: Icon(Icons.add),
      ),
    );
  }
}
