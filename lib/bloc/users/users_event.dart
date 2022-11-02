part of 'users_bloc.dart';

@immutable
abstract class UsersEvent {}

class SetdataRegister extends UsersEvent {
  final bool register;

  SetdataRegister(this.register);
}

class SetFecha extends UsersEvent {
  final String fecha;

  SetFecha(this.fecha);
}
