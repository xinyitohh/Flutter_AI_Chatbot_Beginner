import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_markdown_selectionarea/flutter_markdown.dart';


class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final Uint8List? image;
  const ChatBubble({ Key? key, required this.message, required this.isUser, this.image }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isUser?MediaQuery.of(context).size.width * 0.7 : MediaQuery.of(context).size.width * 0.95,
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: isUser?Radius.circular(10):Radius.zero,
              bottomRight: isUser?Radius.zero:Radius.circular(10),
            ),
            color: isUser? Color(0xFFF2F2F2) : Colors.transparent,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (image != null)
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6,
                    maxHeight: 200, 
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8), 
                    child: Image.memory(
                      image!,
                      fit: BoxFit.cover, 
                    ),
                  ),
                ),

                SelectionArea(
                  child: MarkdownBody(
                      
                          data: message.trim(),
                          // new start
                          styleSheet: MarkdownStyleSheet(
                            h1: const TextStyle(fontSize: 24, color: Colors.blue), 
                            code: const TextStyle(fontSize: 14, color: Colors.green),// new end
                          ),
                        ),
                ),
                    
            ],
          ))
        )
    );
  }
}

//generate all kind of markdown for testing