import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import '../model/message.dart';
import '../api/gemini_api.dart';
import '../model/conversation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatProvider with ChangeNotifier {
  final Box<Conversation> _conversationBox = Hive.box('conversations');
  List<Conversation> _conversations = [];
  bool _isLoading = false;
  String? _currentConversationId;

  bool get isLoading => _isLoading;
  List<Conversation> get conversations => _conversations;

  ChatProvider() {
    print("ChatProvider initialized");
    _loadConversations();
    createNewConversation();
  }

  Future<void> _loadConversations() async {
      _conversations = _conversationBox.values.toList();
      //print("Loaded conversations: $_conversations");
      notifyListeners();
  }

  void deleteConversation(String conversationId){
    _conversationBox.delete(conversationId);
    _conversations = _conversationBox.values.toList();
     if (_currentConversationId == conversationId) {
        createNewConversation();
      }
    notifyListeners();
  }

  Future<List<Content>> getHistory({required String chatId}) async {
    List<Content> history = [];

    // Ensure there's a valid conversation
    if (currentConversation == null) return history;

    for (var message in currentConversation!.messages) {
      if (message.isUser) {
        history.add(Content.text(message.content));
      } else {
        history.add(Content.model([TextPart(message.content)]));
      }
    }

    return history;
  }


  Conversation? get currentConversation {
    if (_conversations.isEmpty) {
      return createNewConversation();
    }
    return _conversations.firstWhere(
      (c) => c.id == _currentConversationId,
      orElse: () => _conversations.first,
    );
  }

  void setCurrentConversation(String conversationId) {
    _currentConversationId = conversationId;
    notifyListeners();
  }

  Conversation createNewConversation() {
    final newConversation = Conversation(
      id: DateTime.now().toString(),
      dateTime: DateTime.now(),
      title: 'Conversation: ${_conversations.length + 1}',
      messages: [],
    );
    _conversations.add(newConversation);
    _currentConversationId = newConversation.id;
    notifyListeners();
    return newConversation;
  }

  Future<void> sendMessage1(String prompt, {Uint8List? image}) async {
  if (prompt.isEmpty && image == null) return;
  final history = await getHistory(chatId: currentConversation!.id); // Fetch history

  String userMessageId = '${DateTime.now().millisecondsSinceEpoch}-user';
  String botMessageId = '${DateTime.now().millisecondsSinceEpoch}-bot';

  final conversation = currentConversation ?? createNewConversation();

  // Add user message
  addMessageToCurrentConversation(
    Message(
      id: userMessageId,
      content: prompt,
      isUser: true,
      image: image,
    ),
  );

  print("User message added");
  //print(conversation.messages);

  if (prompt.isNotEmpty) {
    _isLoading = true;
    notifyListeners();

    String accumulatedResponse = '';
    Message botMessage = Message(
      id: botMessageId,
      content: "...",
      isUser: false,
    );

    try {
      final responseStream = sendMessageStream(prompt, history, imageFile: image);
      print('Prompt sent');

      // Add placeholder bot message
      addMessageToCurrentConversation(botMessage);
      //print("Bot placeholder added");

      await for (final chunk in responseStream) {
        if (_isLoading) {
          _isLoading = false;
          notifyListeners();
        }
        accumulatedResponse += chunk + " ";
        notifyListeners();

        // Update bot message
        updateMessage(Message(
          id: botMessage.id,
          content: accumulatedResponse,
          isUser: false,
        ));
      }
    } catch (e) {
      addMessageToCurrentConversation(
        Message(id: DateTime.now().toString(), content: 'Error: $e', isUser: false),
      );
    }
    _isLoading = false;
    notifyListeners();
  }
}


  void addMessageToCurrentConversation(Message message) {
    final conversation = currentConversation ?? createNewConversation();
    conversation.addMessage(message);
    if (conversation.messages.length == 1) {
      conversation.title = message.content;
      notifyListeners();
    }
    if (conversation.messages.isNotEmpty) {
      _conversationBox.put(conversation.id, conversation);
    }
    notifyListeners();
  }

  void updateMessage(Message message) {
    final conversation = currentConversation;
    if (conversation != null) {
      final messageIndex = conversation.messages.indexWhere((m) => m.id == message.id);
      //print (messageIndex);
      //print(conversation);
      if (messageIndex != -1) {
        conversation.messages[messageIndex] = message;
        _conversationBox.put(conversation.id, conversation);
        notifyListeners();
      }
    }
  }
}
