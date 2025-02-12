import 'package:flutter/material.dart';
import 'package:flutter_chatbot/model/conversation.dart';
import 'package:flutter_chatbot/model/message.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'provider/chat_provider.dart';
import 'page/chat_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  Hive.registerAdapter(ConversationAdapter());
  Hive.registerAdapter(MessageAdapter());
  await Hive.openBox<Conversation>('conversations');
  runApp(
    ChangeNotifierProvider(
      create: (context) => ChatProvider(),
      child: const MyApp(), // Wrap with MaterialApp
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatPage(),
    );
  }
}
