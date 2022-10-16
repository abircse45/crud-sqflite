import 'dart:math';

import 'package:crud/database/database_helper.dart';
import 'package:crud/model/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DbHelper _dataBaseHelper = DbHelper();
  bool loader = false;
  
  Random random = Random();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          inputFrom();
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Todo"),
      ),
      body: Container(
        child: loader
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              )
            : FutureBuilder(
                future: _dataBaseHelper.getTodoModel(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<TodoModel>?> snapshot) {
                  if (snapshot.hasError) return Container();
                  if (snapshot.hasData)
                    return ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 10,
                            child: ListTile(
                              trailing: Text("${snapshot.data![index].datatime}"),
                              title: Text("${snapshot.data![index].title ?? ""}"),
                              subtitle: Text("${snapshot.data![index].description}"),
                            ),
                          ),
                        );
                      },
                    );
                  return Container();
                },
              ),
      ),
    );
  }

  inputFrom() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0, right: 2),
                    child: TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                          hintText: "Title",
                          labelText: "Title",
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 2.0, right: 2, top: 20, bottom: 30),
                    child: TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                          hintText: "Desciption",
                          labelText: "Description",
                          border: OutlineInputBorder()),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        loader = true;
                      });
                      var todoModel = TodoModel(
                        todoModelInt: random.nextInt(100),
                          title: titleController.text,
                          description: descriptionController.text,
                          datatime:
                              DateFormat().add_jm().format(DateTime.now()));

                      await _dataBaseHelper.addTodo(todoModel);
                      setState(() {
                        Navigator.pop(context,true);
                        loader = false;
                      });
                    },
                    child: Text("       Submit      "),
                    style: ElevatedButton.styleFrom(primary: Colors.purple),
                  )
                ],
              ),
            ),
          );
        });
  }
}
