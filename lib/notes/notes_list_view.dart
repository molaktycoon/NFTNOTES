import 'package:flutter/material.dart';
import 'package:nftnotes/services/cloud/cloud_note.dart';
import 'package:nftnotes/utilities/dialogs/delete_dialog.dart';

import '../ui/widgets/shared/globals.dart';

typedef NoteCallBack = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallBack onDeleteNote;
  final NoteCallBack onTap;

  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> items = List<String>.generate(10000, (i) => '$i');

    return ListView.separated(    
             
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes.elementAt(index);
        return ListTile(
leading: CircleAvatar(
        backgroundColor: const Color(0xff764abc),
        child: Text(items[index]),
      ),
           
          onTap: () {
            onTap(note);
          },
          title: Text(
            
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
              onPressed: () async {
                final shouldDelete = await showDeleteDialog(context);
                if (shouldDelete) {
                  onDeleteNote(note);
                }
              },
              icon: const Icon(Icons.delete)
              ),
        );
      },
        separatorBuilder: (context, index) {
           // <-- SEE HERE
    return const Divider(

      color: Global.mediumBlue,
    );
  },
    );
  }
}
