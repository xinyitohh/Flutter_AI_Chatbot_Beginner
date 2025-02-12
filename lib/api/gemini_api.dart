import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

final model = GenerativeModel(
  model: 'gemini-1.5-flash',
  apiKey: dotenv.env['API_KEY']!,
);

/// Converts an image file into a DataPart 
Future<DataPart> fileToPart(String mimeType, Uint8List imageData) async {
  return DataPart(mimeType, imageData);
}

/// Returns a stream of messages
Stream<String> sendMessageStream(
  String prompt, 
  List<Content> history,  // Pass history explicitly
  {Uint8List? imageFile}
) async* {
  final List<Part> contentParts = [TextPart(prompt)];

  // Start chat session with the provided history
  final chat = model.startChat(history: history);

  // Add the image if its provided
  if (imageFile != null) {
    final image = await fileToPart('image/jpeg', imageFile);
    contentParts.add(image);
  }

  // Send chat request
  final responseStream = chat.sendMessageStream(Content.multi(contentParts));

  await for (final response in responseStream) {
    if (response.text != null) {
      yield response.text!;
    }
  }
}
