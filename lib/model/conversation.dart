import 'package:hive/hive.dart';
import 'message.dart';

part 'conversation.g.dart';

@HiveType(typeId: 0)
class Conversation {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final DateTime dateTime;
  @HiveField(2)
  String title;
  @HiveField(3)
  final List<Message> messages;

  Conversation({
    required this.id,
    required this.dateTime,
    required this.title,
    required this.messages,
  });

  void addMessage(Message message) {
    messages.add(message);
  }

  @override
  String toString() {
    return 'Conversation{id: $id, dateTime: $dateTime, title: $title, messages: $messages}';
  }
}
