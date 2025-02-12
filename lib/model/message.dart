import 'package:hive/hive.dart';
import 'dart:typed_data';

part 'message.g.dart';

@HiveType(typeId: 1)
class Message {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final bool isUser;

  @HiveField(3)
  final List<int>? image; // Convert Uint8List to List<int>

  Message({
    required this.id,
    required this.content,
    required this.isUser,
    Uint8List? image,
  }) : image = image?.toList(); // Convert Uint8List to List<int>

  Uint8List? getImage() => image != null ? Uint8List.fromList(image!) : null; // Convert back when needed

  @override
  String toString() {
    return 'Message{id: $id, content: $content, isUser: $isUser, hasImage: ${image != null}}';
  }
}
