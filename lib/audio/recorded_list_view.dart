import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../utilities/dialogs/delete_dialog.dart';


class RecordListView extends StatefulWidget {
  final List<String> records;

  const RecordListView({
    Key? key,
    required this.records,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RecordListViewState createState() => _RecordListViewState();
}

class _RecordListViewState extends State<RecordListView> {
  late int _totalDuration;
  late int _currentDuration;
  double _completedPercentage = 0.0;
  bool _isPlaying = false;
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return widget.records.isEmpty
        ? const Center(child: Text('No records yet'))
        : ListView.builder(
            itemCount: widget.records.length,
            shrinkWrap: true,
            reverse: true,
            itemBuilder: (BuildContext context, int i) {
              return ExpansionTile(
                title: Text('New recoding ${widget.records.length - i}'),
                subtitle: Text(_getDateFromFilePatah(
                    filePath: widget.records.elementAt(i))),
                onExpansionChanged: ((newState) {
                  if (newState) {
                    setState(() {
                      _selectedIndex = i;
                    });
                  }
                }),
                trailing: IconButton(
                    onPressed: () async {
                      final shouldDelete = await showDeleteDialog(context);
                      if (shouldDelete) {
                        await _deleteRecord(i, () {
                          setState(() {
                            widget.records.removeAt(i);
                          });
                        } );
                        
                      }
                    },
                    icon: const Icon(Icons.delete)),
                children: [
                  Container(
                    height: 100,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LinearProgressIndicator(
                          minHeight: 5,
                          backgroundColor: Colors.black,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.green),
                          value: _selectedIndex == i ? _completedPercentage : 0,
                        ),
                        IconButton(
                          icon: _selectedIndex == i
                              ? _isPlaying
                                  ? const Icon(Icons.pause)
                                  : const Icon(Icons.play_arrow)
                              : const Icon(Icons.play_arrow),
                          onPressed: () => _onPlay(
                            filePath: widget.records.elementAt(i),
                            index: i,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
  }

  AudioPlayer audioPlayer = AudioPlayer();

  Future<void> _onPlay({required String filePath, required int index}) async {
    if (!_isPlaying) {
      await audioPlayer.play(DeviceFileSource(filePath));
      setState(() {
        _selectedIndex = index;
        _completedPercentage = 0.0;
        _isPlaying = true;
      });

      audioPlayer.onPlayerComplete.listen((_) {
        setState(() {
          _isPlaying = false;
          _completedPercentage = 0.0;
        });
      });
      audioPlayer.onDurationChanged.listen((duration) {
        setState(() {
          _totalDuration = duration.inMicroseconds;
        });
      });

      audioPlayer.onPlayerComplete.listen((duration) {
        setState(() {
          _currentDuration = Duration.microsecondsPerSecond;
          _completedPercentage =
              _currentDuration.toDouble() / _totalDuration.toDouble();
        });
      });
    }
  }

  Future<void> _deleteRecord(int index, void Function() onRecordDeleted) async {
    try {
      // Get the application documents directory
    Directory appDir = await getApplicationDocumentsDirectory();

    // Construct the file path to the recording to delete
    String filePath = widget.records.elementAt(index);
    String fullPath = p.join(appDir.path, filePath);

    // Delete the file if it exists
    File fileToDelete = File(fullPath);
    if (await fileToDelete.exists()) {
      await fileToDelete.delete();
    onRecordDeleted(); // Call the callback function
    } else {
    }
    } catch (e) {
    '';
    }

    
  }

  String _getDateFromFilePatah({required String filePath}) {
    String fromEpoch = filePath.substring(
        filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));

    DateTime recordedDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(fromEpoch));
    int year = recordedDate.year;
    int month = recordedDate.month;
    int day = recordedDate.day;

    return ('$year-$month-$day');
  }
}
