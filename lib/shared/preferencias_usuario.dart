import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia = PreferenciasUsuario._internal();
  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  late SharedPreferences _prefs;

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del nombreUsuario

  String get name {
    return _prefs.getString('name') ?? '';
  }

  set name(String value) {
    _prefs.setString('name', value);
  }

  String get email {
    return _prefs.getString('email') ?? '';
  }

  set email(String value) {
    _prefs.setString('email', value);
  }

  String get pinString {
    return _prefs.getString('pinString') ?? '';
  }

  set pinString(String value) {
    _prefs.setString('pinString', value);
  }

  bool get encrypt {
    return _prefs.getBool('encrypt') ?? false;
  }

  set encrypt(bool value) {
    _prefs.setBool('encrypt', value);
  }

  bool get activepin {
    return _prefs.getBool('activepin') ?? true;
  }

  set activepin(bool value) {
    _prefs.setBool('activepin', value);
  }
}
