import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:notes/models/task_models.dart';
import 'package:notes/services/db_task.dart';
import 'package:notes/services/local_notifications.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  List<TaskModel> task = [];

  TaskBloc() : super(TaskState()) {
    on<SetTask>((event, emit) {
      emit(state.copyWith(task: event.task));
    });
    on<SetAlarm>((event, emit) {
      emit(state.copyWith(
          years: event.years,
          days: event.days,
          hour: DateTime.now().hour,
          minutes: DateTime.now().minute,
          month: event.month,
          dateFormat: ''));
    });
    on<SetHours>((event, emit) {
      emit(state.copyWith(hour: event.hours, minutes: event.minutes));
    });
    on<SetFormat>((event, emit) {
      emit(state.copyWith(dateFormat: event.dateFormat));
    });
    on<SetRepeat>((event, emit) {
      emit(state.copyWith(repeat: event.repeat));
    });
    on<SetDetails>((event, emit) {
      emit(state.copyWith(details: event.details));
    });
  }

  void borrarScanPorId(id, int sub) async {
    await DBTask.db.deleTask(id);
    cargarScanPorTipo(sub);
  }

  Future<void> cargarScanPorTipo(int tipo) async {
    final task = await DBTask.db.getTaskporTipo(tipo);
    this.task = [...task];
    add(SetTask(task));
  }

  void cargarTask() async {
    final task = await DBTask.db.getTodosLostTask();
    this.task = [...task];
    add(SetTask(task));
  }

  Future<void> updateTaskDetails(TaskModel task, String details) async {
    final newTask = TaskModel(
        id: task.id,
        task: task.task,
        completed: task.completed,
        details: details,
        hoursSet: task.hoursSet);
    await DBTask.db.updateTask(newTask);

    cargarScanPorTipo(task.completed);
  }

  Future<void> updateTaskDo(task, int completed, String texto) async {
    final newTask = TaskModel(
        id: task.id,
        task: texto,
        completed: completed,
        hoursSet: task.hoursSet,
        details: task.details);
    await DBTask.db.updateTask(newTask);

    cargarScanPorTipo(completed);
  }

  Future<void> updateHourSet(
      TaskModel task, String hourset, bool repeat) async {
    final datetime = DateTime(
        state.years, state.month, state.days, state.hour, state.minutes);
    final newTask = TaskModel(
        id: task.id,
        task: task.task,
        completed: task.completed,
        hoursSet: hourset,
        details: task.details,
        repeat: repeat ? 1 : 0);
    await DBTask.db.updateTask(newTask);
    PushNotifications.setNoficiations(
        task.task, task.id, datetime, repeat, task.details!, newTask);

    cargarScanPorTipo(task.completed);
  }

  Future<void> updateTask(task, int completed) async {
    final newTask = TaskModel(
        id: task.id,
        task: task.task,
        completed: completed,
        hoursSet: task.hoursSet,
        details: task.details);
    await DBTask.db.updateTask(newTask);

    cargarScanPorTipo(completed == 1 ? 0 : 1);
  }

  Future<TaskModel> newTask(
      String task, String hourSet, bool repeat, String details) async {
    var _random = Random();
    final int number = _random.nextInt(100000000) * 5;
    final datetime = DateTime(
        state.years, state.month, state.days, state.hour, state.minutes);
    final newTask = TaskModel(
      id: number,
      task: task,
      completed: 0,
      details: details,
      repeat: repeat ? 1 : 0,
      hoursSet: hourSet,
    );
    PushNotifications.setNoficiations(
        task, number, datetime, repeat, details, newTask);
    final id = await DBTask.db.nuevoTask(newTask);

    newTask.id = id;
    this.task.add(newTask);
    add(SetTask(this.task));
    return newTask;
  }
}
