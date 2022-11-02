part of 'notes_bloc.dart';

@immutable
abstract class NotesEvent {}

class SetNotes extends NotesEvent {
  final List<FolderModel> archives;

  SetNotes(this.archives);
}

class SelectIndex extends NotesEvent {
  final int selectIndex;

  SelectIndex(this.selectIndex);
}

class SetTitulo extends NotesEvent {
  final String titulo;

  SetTitulo(this.titulo);
}

class AppBarActive extends NotesEvent {
  final bool appBarActive;

  AppBarActive(this.appBarActive);
}

class SetTextSize extends NotesEvent {
  final double textSize;

  SetTextSize(this.textSize);
}

class SetContent extends NotesEvent {
  final String contenido;

  SetContent(this.contenido);
}

class ChargeData extends NotesEvent {
  final String titulo;
  final bool updated;

  ChargeData(this.titulo, this.updated);
}

class ClearNotes extends NotesEvent {}

class GroupValue extends NotesEvent {
  final int groupValue;

  GroupValue(this.groupValue);
}

class ActivePin extends NotesEvent {
  final bool activePin;

  ActivePin(this.activePin);
}

class OrderValue extends NotesEvent {
  final int orderValue;

  OrderValue(this.orderValue);
}
