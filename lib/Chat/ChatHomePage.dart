import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:zego_zimkit/zego_zimkit.dart";

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: Text("Messages"),
        backgroundColor: Colors.red[200],
        toolbarHeight: 100.0,
        elevation: 0,
        actions:[
          PopupMenuButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),

            itemBuilder: (context){
              return[
                PopupMenuItem(
                  value: "New Chat",
                  child: ListTile(
                    leading: Icon(CupertinoIcons.chat_bubble_2_fill),
                    title: Text("New Chat", maxLines: 1,),
                  ),
                  onTap: ()=>ZIMKit().showDefaultNewPeerChatDialog(context),
                )
              ];
            },)
        ],
      ),
      body: ZIMKitConversationListView(
        onPressed: (context, conversation, defaultAction){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ZIMKitMessageListPage(conversationID: conversation.id,
              conversationType: conversation.type,
            );
          },
          ));
        },
      ),
    );
  }
}

