// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes/bloc/pdfs/pdfs_bloc.dart';
import 'package:notes/bloc/users/users_bloc.dart';
import 'package:notes/services/apple_singIn.dart';
import 'package:notes/services/google_singin.dart';
import 'package:notes/shared/preferencias_usuario.dart';
import 'package:notes/widgets/account_form.dart';
import 'package:flutter_gen/gen_l10n/notes.dart';
import 'package:notes/widgets/menu_pop_pin.dart';

class CustomDialogAccount {
  CustomDialogAccount._();

  static buildMenuRegister(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userBloc = BlocProvider.of<UsersBloc>(context);
    final _prefs = PreferenciasUsuario();
    final location = AppLocalizations.of(context)!;

    showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return BlocBuilder<UsersBloc, UsersState>(
            builder: (context, state) {
              return SizedBox(
                height: size.height * 0.85,
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.cancel))
                      ],
                    ),
                    Text(
                      location.hello,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 25),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: size.width * 0.60,
                      child: Text(
                        location.introText,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 13),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    AccountForm(
                      register: state.register,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: Platform.isIOS
                          ? MainAxisAlignment.spaceEvenly
                          : MainAxisAlignment.center,
                      children: [
                        if (Platform.isIOS)
                          const SizedBox(
                            width: 10,
                          ),
                        CircleAvatar(
                            backgroundColor: Colors.red[700],
                            child: IconButton(
                                onPressed: () async {
                                  loading(context);
                                  final GoogleSignInAccount? account =
                                      await GoogleSingInService
                                          .singInWithGoogle();
                                  if (account == null) {
                                    Navigator.pop(context);
                                    Fluttertoast.showToast(msg: 'Login Error');
                                  } else {
                                    _prefs.name = account.displayName!;
                                    _prefs.email = account.email;
                                    Navigator.of(context)
                                      ..pop()
                                      ..pop();
                                    Fluttertoast.showToast(
                                        msg: 'Login Completed');
                                  }
                                },
                                icon: const Icon(
                                  FontAwesomeIcons.google,
                                  color: Colors.white,
                                ))),
                        if (Platform.isIOS)
                          CircleAvatar(
                              backgroundColor: Colors.black,
                              child: IconButton(
                                onPressed: () async {
                                  await AppleSinginService.singIn();
                                  Navigator.pop(context);
                                  Fluttertoast.showToast(
                                      msg: 'Login Completed');
                                },
                                icon: const Icon(
                                  FontAwesomeIcons.apple,
                                  color: Colors.white,
                                ),
                              )),
                        if (Platform.isIOS)
                          const SizedBox(
                            width: 10,
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.register ? location.miembro : location.have),
                        TextButton(
                            onPressed: () {
                              if (state.register) {
                                userBloc.add(SetdataRegister(false));
                              } else {
                                userBloc.add(SetdataRegister(true));
                              }
                            },
                            child: Text(state.register
                                ? location.register
                                : location.loginow))
                      ],
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  static builUserInterface(BuildContext context) {
    final pdfsBloc = BlocProvider.of<PdfsBloc>(context);
    final User? user = FirebaseAuth.instance.currentUser;
    final userBlock = BlocProvider.of<UsersBloc>(context);
    final _pref = PreferenciasUsuario();
    final location = AppLocalizations.of(context)!;

    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10), topLeft: Radius.circular(10))),
        context: context,
        builder: (BuildContext bc) {
          return ListView(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        location.free,
                        style: TextStyle(color: Colors.blue[700]),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.cancel,
                          size: 20,
                        )),
                  )
                ],
              ),
              ListTile(
                leading: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.account_box_rounded,
                      color: Colors.black,
                      size: 40,
                    )),
                title: Text(
                  _pref.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Email: ${_pref.email}'),
              ),
              ListTile(
                  leading: const Icon(
                    Icons.lock,
                    color: Colors.black,
                  ),
                  title: Text(location.pin),
                  trailing: const MenuPopPin()),
              ListTile(
                onTap: () async {
                  loading(context);
                  await FirebaseFirestore.instance
                      .collection('usuarios')
                      .doc(user!.uid)
                      .get()
                      .then((value) {
                    try {
                      userBlock.add(SetFecha(value['fecha']));
                      Navigator.pushReplacementNamed(context, 'backup');
                    } catch (e) {
                      userBlock.add(SetFecha(''));
                      Navigator.pushReplacementNamed(context, 'backup');
                    }
                  });
                },
                leading: const Icon(
                  Icons.backup,
                  color: Colors.black,
                ),
                title: Text(location.copysecu),
              ),
              ListTile(
                onTap: () {
                  pdfsBloc.cargarArchivos();
                  Navigator.pushNamed(context, 'pdfs');
                },
                leading: const Icon(
                  Icons.picture_as_pdf,
                  color: Colors.black,
                ),
                title: Text(location.pdfGenerates),
              ),
              ListTile(
                onTap: () async {
                  if (Platform.isAndroid) GoogleSingInService.signOut();
                  await FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                  Fluttertoast.showToast(msg: location.singOut);
                },
                leading: const Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
                title: Text(location.logout),
              ),
            ],
          );
        });
  }

  static buildEncryptDialog(BuildContext context) {
    String content = '';
    final location = AppLocalizations.of(context)!;
    final _formKey = GlobalKey<FormState>();
    final User? user = FirebaseAuth.instance.currentUser;

    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              setState(
                () {},
              );
              return AlertDialog(
                actions: [
                  TextButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;
                        _formKey.currentState!.save();
                        FirebaseFirestore.instance
                            .collection('usuarios')
                            .doc(user!.uid)
                            .set({'Encrypt': true}, SetOptions(merge: true));
                        Navigator.of(context)
                          ..pop()
                          ..pop();
                        Fluttertoast.showToast(msg: location.creado);
                      },
                      child: Text(location.confirm))
                ],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                content: Form(
                  key: _formKey,
                  child: TextFormField(
                    obscureText: true,
                    style: const TextStyle(color: Colors.black),
                    autofocus: true,
                    keyboardType: TextInputType.multiline,
                    key: const ValueKey('contenido'),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: location.password,
                        hintStyle: const TextStyle(color: Colors.black)),
                    onChanged: (value) => setState(
                      () {
                        content = value;
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return location.min6;
                      }
                      return null;
                    },
                  ),
                ),
              );
            },
          );
        });
  }

  static loading(BuildContext context) {
    showCupertinoModalPopup(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext bc) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        });
  }
}
