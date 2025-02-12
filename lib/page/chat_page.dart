import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:image_picker/image_picker.dart';
import '../widget/chat_bubble.dart';
import 'package:provider/provider.dart';
import '../provider/chat_provider.dart';
import '../widget/drawer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  GlobalKey<SliderDrawerState> _sliderDrawerKey = GlobalKey<SliderDrawerState>();
  final ImagePicker _picker = ImagePicker();
  Uint8List? image;

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
        );
      }
    });
  }

 Future<void> _pickImage() async {
    if (kIsWeb) {
      // Web: Use file_picker
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null && result.files.first.bytes != null) {
        setState(() {
          image = result.files.first.bytes; // Store as bytes
          print ("Image selected");
        });
      }
    } else {
      // Mobile: Use image_picker
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
            Uint8List imageBytes = await File(pickedFile.path).readAsBytes(); // Convert File to Uint8List

            setState(() {
              image = imageBytes; // Store as Uint8List
              print("Mobile image selected");
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SliderDrawer(
        key: _sliderDrawerKey,
        isDraggable: false,
        appBar: SliderAppBar(
          config: SliderAppBarConfig(
            trailing: IconButton(
              icon: Icon(Icons.post_add), 
              onPressed: (){
                final chatProvider = Provider.of<ChatProvider>(context, listen:false);
                if (chatProvider.currentConversation == null || chatProvider.currentConversation!.messages.isNotEmpty) {
                    chatProvider.createNewConversation();
                  }

              }),
            title: Text(
              "Chatbot",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
              ),
            ),
          ),
        ),
        sliderOpenSize: 290,
        slider: Container(
          color: Colors.grey[100],
          child: DrawerItems(),
        ),
        child: Column(
          children: [
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, child) {
                  final conversation = chatProvider.currentConversation ??chatProvider.createNewConversation();

                  if (conversation.messages.isEmpty) {
                    return const Center(
                      child: Text("Start a conversation"),
                    );
                  }

                  // Scroll to bottom after UI updates
                  WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: conversation.messages.length,
                    itemBuilder: (context, index) {
                      final message = conversation.messages[index];
                      return ChatBubble(
                        message: message.content,
                        isUser: message.isUser,
                        image: message.getImage(),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.image),
                    onPressed: _pickImage,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(8), 
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey), 
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min, // Makes column wrap content
                              children: [
                                // Image 
                                if (image != null)
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(bottom: 5),
                                    width: double.infinity, // Ensures it fills the container width
                                    height: 50, 
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8), // Rounds corners
                                      child: Image(
                                        image: MemoryImage(image!) as ImageProvider,
                                        fit: BoxFit.contain, 
                                      ),
                                    ),
                                  ),
                                TextField(
                                  controller: _controller,
                                  focusNode: _focusNode,
                                  decoration: const InputDecoration(
                                    hintText: 'Message',
                                    border: InputBorder.none,
                                    isDense: true, 
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  onSubmitted: (value) {
                                      //print("Before sending - Text: $value, WebImage: $image");
                                      final chatProvider = Provider.of<ChatProvider>(context, listen: false);

                                      if (value.isNotEmpty|| image != null) {
                                        print ("URL oijoijroijaoidjoaiwjoidasdawsd");
                                        chatProvider.sendMessage1(
                                          value,
                                          image: image,
                                        );

                                        // Clear input field and image after sending
                                        _controller.clear();
                                        setState(() {
                                          image = null;
                                        });
                                        
                                      }
                                      FocusScope.of(context).requestFocus(_focusNode);
                                      _scrollToBottom();
                                    }
                                    ,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        Provider.of<ChatProvider>(context, listen: false).sendMessage1(_controller.text, image: image);
                      }
                      setState(() {
                        image = null;
                      });
                      _controller.clear();
                      FocusScope.of(context).requestFocus(_focusNode);
                      _scrollToBottom();
                    },
                    icon: const Icon(Icons.arrow_upward),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

