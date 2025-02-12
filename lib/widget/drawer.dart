import 'package:flutter/material.dart';
import '../provider/chat_provider.dart';
import 'package:provider/provider.dart';

class DrawerItems extends StatelessWidget {
  const DrawerItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        return ListView.builder(
          reverse: true,
          itemCount: chatProvider.conversations.length,
          itemBuilder: (context, index) {
            final conversation = chatProvider.conversations[index];
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    child: Container(
                      width: double.infinity,
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, bottom: 2),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: chatProvider.currentConversation?.id ==
                                conversation.id
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                              children: [
                                Expanded(
                                  child: Text(conversation.title, overflow: TextOverflow.ellipsis),
                                ),
                                IconButton(onPressed: (){}, icon: Icon(Icons.delete))
                              ],
                            ),


                      //subtitle: Text(conversation.dateTime.toString()),
                    ),
                    onTap: () {
                      chatProvider.setCurrentConversation(conversation.id);
                      // _sliderDrawerKey.currentState!.closeDrawer();
                    },
                  ),
                  SizedBox(
                    height: 10,
                  )
                ]);
          },
        );
      },
    );
  }
}
