import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String filePath;
  const AudioPlayerWidget({super.key, required this.filePath});

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  bool _fileExists = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _checkFileExists();
  }

  Future<void> _checkFileExists() async {
    final file = File(widget.filePath);
    if (await file.exists()) {
      setState(() {
        _fileExists = true;
      });
    } else {
      debugPrint("File does not exist at path: ${widget.filePath}");
    }
  }

  Future<void> _playAudio() async {
    if (_fileExists) {
      await _audioPlayer.setFilePath(widget.filePath);
      _audioPlayer.play();
    } else {
      debugPrint("Cannot play audio: file does not exist.");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _fileExists ? _playAudio : null,
          child: const Text("Play Recording"),
        ),
        if (!_fileExists)
          const Text(
            "Recording file not found.",
            style: TextStyle(color: Colors.red),
          ),
      ],
    );
  }
}
