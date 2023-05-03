import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nftnotes/services/auth/bloc/auth_bloc.dart';
import 'package:nftnotes/services/cloud/cloud_note.dart';
import 'package:nftnotes/services/cloud/firebase_cloud_storage.dart';
import '../constants/routes.dart';
import '../enums/menu_action.dart';
import '../services/auth/auth_service.dart';
import '../services/auth/bloc/auth_event.dart';
import '../ui/widgets/shared/globals.dart';
import '../utilities/dialogs/logout_dialog.dart';
import 'notes_list_view.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Global.mediumBlue,
          title: const Text('Your Notes'),
          actions: [
            // IconButton(
            //     onPressed: () {
            //       Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            //     },
            //     icon: const Icon(Icons.add)),
            PopupMenuButton(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogOutDialog(context);
                    if (shouldLogout) {
                      // ignore: use_build_context_synchronously
                      context.read<AuthBloc>().add(
                            const AuthEventLogOut(),
                          );
                    }
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                      value: MenuAction.logout, child: Text('Log Out'))
                ];
              },
            )
          ],
        ),
        body: StreamBuilder(
          stream: _notesService.allNotes(ownerUserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allNotes = snapshot.data as Iterable<CloudNote>;
                  return NotesListView(
                    notes: allNotes,
                    onDeleteNote: (note) async {
                      await _notesService.deleteNote(
                          documentId: note.documentId);
                    },
                    onTap: (CloudNote note) {
                      Navigator.of(context).pushNamed(
                        createOrUpdateNoteRoute,
                        arguments: note,
                      );
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }

              default:
                return const CircularProgressIndicator();
            }
          },
        ),
        floatingActionButton: SpeedDial(
          backgroundColor: Global.mediumBlue,

          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: const IconThemeData(size: 22.0),
          // this is ignored if animatedIcon is non null
          // child: Icon(Icons.add),
          // visible: _dialVisible,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          // onOpen: () => print('OPENING DIAL'),
          // onClose: () => print('DIAL CLOSED'),
          tooltip: 'Speed Dial',
          heroTag: 'speed-dial-hero-tag',
          foregroundColor: Colors.black,
          elevation: 8.0,
          shape: const CircleBorder(),

          children: [
            SpeedDialChild(
                child: const Icon(Icons.mic),
                backgroundColor: Colors.red,
                label: 'Audio',
                labelStyle: const TextStyle(),
                onTap: () {
                  Navigator.of(context).pushNamed(recordingStatus);
                }),
            SpeedDialChild(
              child: const Icon(Icons.add),
              backgroundColor: Colors.blue,
              label: 'Add Note',
              labelStyle: const TextStyle(),
              onTap: () {
                Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
              },
            ),
            // SpeedDialChild(
            //   child: const Icon(Icons.keyboard_voice),
            //   backgroundColor: Colors.green,
            //   label: 'Third',
            //   labelStyle: const TextStyle(),

            //   // onTap: () => print('THIRD CHILD'),
            // ),
          ],
        )
        //  FloatingActionButton(
        //   backgroundColor: Global.mediumBlue,
        //   onPressed: () {
        //     Navigator.of(context).pushNamed(recordingStatus);
        //   },
        //   child: const Icon(Icons.mic),
        // )
        );
  }
}
