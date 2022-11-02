// To parse this JSON data, do
//
//     final taskModel = taskModelFromJson(jsonString);

import 'dart:convert';

TaskModel taskModelFromJson(String str) => TaskModel.fromJson(json.decode(str));

String taskModelToJson(TaskModel data) => json.encode(data.toJson());

class TaskModel {
  TaskModel(
      {required this.id,
      required this.task,
      required this.completed,
      this.details,
      this.hoursSet,
      this.repeat,
      this.subtask});

  int id;
  String task;
  int completed;
  String? details;
  String? hoursSet;
  int? repeat;
  String? subtask;

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json["id"],
        task: json["task"],
        completed: json["completed"],
        details: json["details"],
        hoursSet: json["hoursSet"],
        repeat: json["repeat"],
        subtask: json["subtask"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "task": task,
        "completed": completed,
        "details": details,
        "hoursSet": hoursSet,
        "repeat": repeat,
        "subtask": subtask,
      };
}
