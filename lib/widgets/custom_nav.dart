import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/bloc/notes/notes_bloc.dart';

class CustomNav extends StatelessWidget {
  final int index;

  const CustomNav({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notesBloc = BlocProvider.of<NotesBloc>(context);

    return Theme(
      data: Theme.of(context)
          .copyWith(splashColor: Colors.transparent, canvasColor: Colors.white),
      child: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
        currentIndex: index,
        onTap: notesBloc.selectedIndex,
        items: const [
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.note_add_rounded,
              color: Colors.black,
            ),
            icon: Icon(
              Icons.note_add_outlined,
              color: Colors.black,
            ),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.check_circle_sharp,
              color: Colors.black,
            ),
            icon: Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.black,
            ),
            label: 'Chats',
          ),
        ],
      ),
    );
  }
}
