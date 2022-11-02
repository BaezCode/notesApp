import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:notes/models/task_models.dart';
import 'package:notes/services/db_task.dart';

part 'subtask_event.dart';
part 'subtask_state.dart';

class SubtaskBloc extends Bloc<SubtaskEvent, SubtaskState> {
  List<dynamic> subTask = [];

  SubtaskBloc() : super(SubtaskState()) {
    on<SetSubTask>((event, emit) {
      emit(state.copyWith(subtask: event.subtask));
    });
    on<LoadTask>((event, emit) {
      emit(state.copyWith(
          id: event.id,
          completed: event.completed,
          task: event.task,
          details: event.details,
          hoursSet: event.hoursSet,
          subtask: event.subtask));
    });
    on<SetTextTask>((event, emit) {
      emit(state.copyWith(task: event.task));
    });
    on<SubDetaiils>((event, emit) {
      emit(state.copyWith(details: event.details));
    });
  }

  Future<void> removeData(String value, SubtaskState task) async {
    subTask.remove(value);
    final String _encode = jsonEncode(subTask);
    final newTask = TaskModel(
        id: task.id,
        task: task.task,
        completed: task.completed,
        details: task.details,
        hoursSet: task.hoursSet,
        subtask: _encode);
    await DBTask.db.updateTask(newTask);

    add(SetSubTask(subTask));
  }

  Future<void> updateTaskDetails(SubtaskState task, String details) async {
    final String _encode = jsonEncode(subTask);

    final newTask = TaskModel(
        id: task.id,
        task: task.task,
        completed: task.completed,
        details: details,
        hoursSet: task.hoursSet,
        subtask: _encode);
    await DBTask.db.updateTask(newTask);
    add(SubDetaiils(details));
  }

  Future<void> addSubTask(String data, SubtaskState task) async {
    subTask.add(data);
    final String _encode = jsonEncode(subTask);
    final newTask = TaskModel(
        id: task.id,
        task: task.task,
        completed: task.completed,
        details: task.details,
        hoursSet: task.hoursSet,
        subtask: _encode);
    await DBTask.db.updateTask(newTask);

    add(SetSubTask(subTask));
  }
}
