part of 'subtask_bloc.dart';

@immutable
abstract class SubtaskEvent {}

class SetSubTask extends SubtaskEvent {
  List<dynamic> subtask;

  SetSubTask(this.subtask);
}

class LoadTask extends SubtaskEvent {
  final int id;
  final String task;
  final int completed;
  final String? details;
  final String? hoursSet;
  final List<dynamic>? subtask;

  LoadTask(this.id, this.task, this.completed, this.details, this.hoursSet,
      this.subtask);
}

class SetTextTask extends SubtaskEvent {
  final String task;

  SetTextTask(this.task);
}

class SubDetaiils extends SubtaskEvent {
  final String details;

  SubDetaiils(this.details);
}
