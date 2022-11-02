part of 'subtask_bloc.dart';

class SubtaskState {
  final List<dynamic> subtask;
  final int id;
  final String task;
  final int completed;
  final String? details;
  final String? hoursSet;
  final int? repeat;

  SubtaskState(
      {this.subtask = const [],
      this.id = 0,
      this.task = '',
      this.completed = 0,
      this.details = '',
      this.hoursSet = '',
      this.repeat = 0});

  SubtaskState copyWith({
    List<dynamic>? subtask,
    int? id,
    String? task,
    int? completed,
    String? details,
    String? hoursSet,
    int? repeat,
  }) =>
      SubtaskState(
          subtask: subtask ?? this.subtask,
          id: id ?? this.id,
          task: task ?? this.task,
          completed: completed ?? this.completed,
          details: details ?? this.details,
          hoursSet: hoursSet ?? this.hoursSet,
          repeat: repeat ?? this.repeat);
}
