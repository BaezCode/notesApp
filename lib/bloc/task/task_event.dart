part of 'task_bloc.dart';

@immutable
abstract class TaskEvent {}

class SetDate extends TaskEvent {
  final bool datePicker;

  SetDate(this.datePicker);
}

class SetTask extends TaskEvent {
  final List<TaskModel> task;
  SetTask(this.task);
}

class CompletedTask extends TaskEvent {
  final List<TaskModel> completedTask;
  CompletedTask(this.completedTask);
}

class SetAlarm extends TaskEvent {
  final int years;
  final int month;
  final int days;

  SetAlarm(
    this.years,
    this.month,
    this.days,
  );
}

class SetHours extends TaskEvent {
  final int minutes;
  final int hours;

  SetHours(this.minutes, this.hours);
}

class SetFormat extends TaskEvent {
  final String dateFormat;

  SetFormat(this.dateFormat);
}

class SetRepeat extends TaskEvent {
  final bool repeat;

  SetRepeat(this.repeat);
}

class SetDetails extends TaskEvent {
  final String details;

  SetDetails(this.details);
}
