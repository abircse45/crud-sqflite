// To parse this JSON data, do
//
//     final todoModel = todoModelFromJson(jsonString);

import 'dart:convert';

TodoModel todoModelFromJson(String str) => TodoModel.fromJson(json.decode(str));

String todoModelToJson(TodoModel data) => json.encode(data.toJson());

class TodoModel {
  TodoModel({
    this.todoModelInt,
    this.title,
    this.description,
    this.datatime,
  });

  int ?todoModelInt;
  String? title;
  String? description;
  String? datatime;

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
    todoModelInt: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : json["description"],
    datatime: json["dateTime"] == null ? null : json["dateTime"],
  );

  Map<String, dynamic> toJson() => {
    "id": todoModelInt == null ? null : todoModelInt,
    "title": title == null ? null : title,
    "description": description == null ? null : description,
    "dateTime": datatime == null ? null : datatime,
  };
}
