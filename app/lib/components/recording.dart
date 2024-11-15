import 'dart:io';
import 'dart:math';
import 'package:app/data/chat_instance.dart';
import 'package:app/service/speech.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class Recording extends ConsumerStatefulWidget {
  final Function sendMessageRecord;
  const Recording({super.key, required this.sendMessageRecord});

  @override
  ConsumerState<Recording> createState() => _RecordingState();
}

class _RecordingState extends ConsumerState<Recording> {
  bool isRecording = false;
  late final AudioRecorder _audioRecorder;
  String? _audioPath;
  final api = AudioTranscriptionService();

  @override
  void initState() {
    _audioRecorder = AudioRecorder();
    super.initState();
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(
      10,
      (index) => chars[random.nextInt(chars.length)],
      growable: false,
    ).join();
  }

  Future<void> _startRecording() async {
    try {
      String filePath = await getApplicationDocumentsDirectory()
          .then((value) => '${value.path}/${_generateRandomId()}.wav');

      await _audioRecorder.start(
        const RecordConfig(
          // specify the codec to be `.wav`
          encoder: AudioEncoder.wav,
        ),
        path: filePath,
      );
    } catch (e) {
      debugPrint('ERROR WHILE RECORDING: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      String? path = await _audioRecorder.stop();

      setState(() {
        _audioPath = path!;
      });
    } catch (e) {
      debugPrint('ERROR WHILE STOP RECORDING: $e');
    }
  }

  void _record(String conversationId) async {
    if (isRecording == false) {
      final status = await Permission.microphone.request();

      if (status == PermissionStatus.granted) {
        setState(() {
          isRecording = true;
        });
        await _startRecording();
      } else if (status == PermissionStatus.permanentlyDenied) {
        debugPrint('Permission permanently denied');
      }
    } else {
      await _stopRecording();
      setState(() {
        isRecording = false;
      });
      print("Recording");
      final file = File(_audioPath!);
      final transcription = await api.uploadAudio(file);
      print(transcription);
      widget.sendMessageRecord(conversationId, transcription);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatRef = ref.watch(chatInstance);

    return GestureDetector(
      onTap: () => _record(chatRef["id"] ?? ""),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15.0),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isRecording ? Colors.red.shade400 : Colors.blue.shade700,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
        ),
        child: const Icon(Icons.mic, color: Colors.white),
      ),
    );
  }
}
