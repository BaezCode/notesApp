part of 'notes_bloc.dart';

class NotesState {
  final List<FolderModel> archives;
  final int indexHome;
  final String titulo;
  final bool appBarActive;
  final double textSize;
  final bool updated;
  final int groupValue;
  final int orderValue;
  final bool activePin;

  NotesState({
    this.archives = const [],
    this.indexHome = 0,
    this.titulo = 'Title',
    this.appBarActive = true,
    this.textSize = 18,
    this.updated = false,
    this.groupValue = 0,
    this.orderValue = 1,
    this.activePin = false,
  });

  NotesState copyWith({
    List<FolderModel>? archives,
    int? indexHome,
    String? titulo,
    bool? appBarActive,
    double? textSize,
    bool? updated,
    int? groupValue,
    bool? activePin,
    int? orderValue,
  }) =>
      NotesState(
        archives: archives ?? this.archives,
        indexHome: indexHome ?? this.indexHome,
        titulo: titulo ?? this.titulo,
        appBarActive: appBarActive ?? this.appBarActive,
        textSize: textSize ?? this.textSize,
        updated: updated ?? this.updated,
        groupValue: groupValue ?? this.groupValue,
        activePin: activePin ?? this.activePin,
        orderValue: orderValue ?? this.orderValue,
      );
}
