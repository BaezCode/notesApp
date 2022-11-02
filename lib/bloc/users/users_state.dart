part of 'users_bloc.dart';

class UsersState {
  final bool register;
  final String fecha;

  UsersState({this.register = true, this.fecha = ''});

  UsersState copyWith({
    bool? register,
    String? fecha,
  }) =>
      UsersState(
          register: register ?? this.register, fecha: fecha ?? this.fecha);
}
