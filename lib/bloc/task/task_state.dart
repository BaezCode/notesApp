part of 'task_bloc.dart';

class TaskState {
  final List<TaskModel> task;
  final int years;
  final int month;
  final int days;
  final int hour;
  final int minutes;
  final String dateFormat;
  final bool repeat;
  final String details;

  TaskState(
      {this.task = const [],
      this.years = 0,
      this.month = 0,
      this.days = 0,
      this.hour = 0,
      this.minutes = 0,
      this.dateFormat = '',
      this.repeat = false,
      this.details = ''});

  TaskState copyWith(
          {final List<TaskModel>? task,
          final TaskModel? taskModel,
          final int? years,
          final int? month,
          final int? days,
          final int? hour,
          final int? minutes,
          final String? dateFormat,
          final bool? repeat,
          final String? details}) =>
      TaskState(
          task: task ?? this.task,
          years: years ?? this.years,
          month: month ?? this.month,
          days: days ?? this.days,
          hour: hour ?? this.hour,
          minutes: minutes ?? this.minutes,
          dateFormat: dateFormat ?? this.dateFormat,
          repeat: repeat ?? this.repeat,
          details: details ?? this.details);
}
