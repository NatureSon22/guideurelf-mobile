import 'dart:io';
import 'package:dio/dio.dart';

class AudioTranscriptionService {
  final Dio _dio = Dio();
  final String baseUrl = "https://bot-backend-1-k7la.onrender.com";

  Future<String?> uploadAudio(File file) async {
    try {
      final formData = FormData.fromMap({
        'audio': await MultipartFile.fromFile(file.path,
            filename: file.path.split('/').last),
      });

      final response = await _dio.post(
        "$baseUrl/upload-audio",
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response
            .data['data']; // Assuming `data` contains the transcription result
      } else {
        print("Failed to transcribe audio: ${response.statusMessage}");
        return null;
      }
    } catch (e) {
      print("Error uploading audio: $e");
      return null;
    }
  }
}
