import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';




class RecorderView extends StatefulWidget {
  final Function onSaved;

  const RecorderView({Key? key, required this.onSaved}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _RecorderViewState createState() => _RecorderViewState();
}

enum RecordingState {
  unSet,
  set,
  recording,
  stopped,
}

class _RecorderViewState extends State<RecorderView> {
  
  IconData _recordIcon = Icons.mic_none;
  String _recordText = 'Click To Start';
  RecordingState _recordingState = RecordingState.unSet;

  // Recorder properties
  late FlutterAudioRecorder2 audioRecorder;



  @override
  void initState() {
    super.initState();

    FlutterAudioRecorder2.hasPermissions.then((hasPermision) async{
          // await Permission.microphone.request();

      if (hasPermision!) {
        _recordingState = RecordingState.set;
        _recordIcon = Icons.mic;
        _recordText = 'Record';
      }
    });
  }

  @override
  void dispose() {
    _recordingState = RecordingState.unSet;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        MaterialButton(
          onPressed: () async {
            await _onRecordButtonPressed();
            setState(() {});
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: SizedBox(
            width: 150,
            height: 150,
            child: Icon(
              _recordIcon,
              size: 50,
            ),
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8),
                            child: Text(_recordText),

            ))
      ],
    );
  }

  Future<void> _onRecordButtonPressed() async {
    switch (_recordingState) {
      case RecordingState.set:
        await _recordVoice();
        break;

      case RecordingState.recording:
        await _stopRecording();
        _recordingState = RecordingState.stopped;
        _recordIcon = Icons.fiber_manual_record;
        _recordText = 'Record new one';
        break;

      case RecordingState.stopped:
        await _recordVoice();
        break;

      case RecordingState.unSet:
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:  Text('Please allow recording from settings.'),
        ));
        break;
    }
  }

  _initRecorder() async {
    
    Directory appDirectory = await getApplicationDocumentsDirectory();
   final String filePath = '${appDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.aac';
    audioRecorder =
        FlutterAudioRecorder2(filePath, audioFormat: AudioFormat.AAC);
    await audioRecorder.initialized;
  }

  

  _startRecording() async {
    await audioRecorder.start();
    
// D/AndroidAudioRecorder(23346): handleHasPermission false;
  }

  _stopRecording() async {
    await audioRecorder.stop();

    widget.onSaved();
  }



  Future<void> _recordVoice() async {
    
              // await Permission.microphone.request();

    final hasPermission = await FlutterAudioRecorder2.hasPermissions;
    if (hasPermission ?? false) {
      await _initRecorder();

      await _startRecording();
      _recordingState = RecordingState.recording;
      _recordIcon = Icons.stop;
      _recordText = 'Recording';
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please allow recording from settings.'),
      ));
    }
  }

//   Future<void> _requestMicrophonePermission() async {
//   final status = await Permission.microphone.request();
//   if (status == PermissionStatus.granted) {
//     // Microphone permission granted
//   } else if (status == PermissionStatus.denied) {
//     // Microphone permission denied
//   } else if (status == PermissionStatus.permanentlyDenied) {
//     // Microphone permission permanently denied, take the user to app settings
//     await openAppSettings();
//   }
// }


}
