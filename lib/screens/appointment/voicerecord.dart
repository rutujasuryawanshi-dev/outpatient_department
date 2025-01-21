import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  _RecordingScreenState createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  final record = AudioRecorder();

  @override
  void initState() {


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(children: [
            ElevatedButton(onPressed: (){
              start();
            }, child: Text('record')),
            ElevatedButton(onPressed: (){
              stop();
            }, child: Text('Stop'))
          ],)
        ),
      ),
    );
  }
  Future<void> start() async {

    if (await record.hasPermission()) {
      // Get the directory path for the app's documents directory
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/myFile.m4a';

      // Start recording to file
      await record.start(const RecordConfig(), path: filePath);

      // Alternatively, start recording to a stream
      final stream = await record.startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits));
      print('aaa');
    }
  }
  Future<void> stop() async {
    // Stop recording...
    final path = await record.stop();
// ... or cancel it (and implicitly remove file/blob).
    await record.cancel();

    record.dispose();
  }
}