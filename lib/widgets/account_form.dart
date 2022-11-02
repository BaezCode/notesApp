import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/helpers/custom_dialog_account.dart';
import 'package:notes/shared/preferencias_usuario.dart';

class AccountForm extends StatefulWidget {
  final bool register;

  const AccountForm({Key? key, required this.register}) : super(key: key);

  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _prefs = PreferenciasUsuario();

  String _user = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: SizedBox(
        width: size.height * 0.40,
        height: size.height * 0.37,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _formularioUser(),
            _formularioSenha(),
            SizedBox(
              width: size.width * 0.45,
              child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.black,
                  child: Text(
                    widget.register ? 'Sing In' : 'Register',
                    style: const TextStyle(color: Colors.white),
                  ),
                  onPressed: _submit),
            )
          ],
        ),
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    try {
      if (widget.register) {
        CustomDialogAccount.loading(context);
        await _auth.signInWithEmailAndPassword(
            email: _user, password: _password);
        _prefs.email = _user;
        _prefs.name = 'User';
        Navigator.of(context)
          ..pop()
          ..pop();
        Fluttertoast.showToast(msg: 'Login Completed');
      } else {
        CustomDialogAccount.loading(context);

        await _auth.createUserWithEmailAndPassword(
            email: _user, password: _password);
        _prefs.email = _user;
        _prefs.name = 'User';
        Navigator.of(context)
          ..pop()
          ..pop();
        Fluttertoast.showToast(msg: 'Login Completed');
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: e.message.toString());
      return null;
    }
  }

  Widget _formularioUser() {
    return TextFormField(
      key: const ValueKey('id'),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        labelText: 'Email',
        suffixIcon: const Icon(
          Icons.email,
          size: 20,
          color: Colors.black,
        ),
      ),
      onChanged: (value) => _user = value,
      validator: (value) {
        if (value == null || value.trim().length < 4) {
          return 'ID deve Contener @ejemplo.id';
        }
        return null;
      },
    );
  }

  Widget _formularioSenha() {
    return TextFormField(
      key: const ValueKey('senha'),
      obscureText: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        labelText: 'Password',
        suffixIcon: const Icon(
          Icons.lock,
          size: 20,
          color: Colors.black,
        ),
      ),
      onChanged: (value) => _password = value,
      validator: (value) {
        if (value == null || value.trim().length < 3) {
          return 'Password deve Contener almenos 3 Caracteres';
        }
        return null;
      },
    );
  }
}
