// pages/chat_page.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter_app/Bottom_Nav/chatscreen/chatp.dart';
import 'package:provider/provider.dart';

class GroupChatingPage extends StatefulWidget {
  final String userId; // This should be the current user's ID
  final List receiverId; // The receiver's ID
  final String chatDocumentId;
  final String userName;
  final String combinedid;

  GroupChatingPage(
      {required this.userId,
      required this.receiverId,
      required this.userName,
      required this.chatDocumentId,
      required this.combinedid});

  @override
  _GroupChatingPageState createState() => _GroupChatingPageState();
}

class _GroupChatingPageState extends State<GroupChatingPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatProvider(widget.chatDocumentId),
      child: Scaffold(
        appBar: AppBar(
          elevation: 10,
          backgroundColor: Colors.green,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                child: Icon(Icons.group, color: Colors.white),
                backgroundColor: Colors.grey,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                widget.userName,
                style: const TextStyle(fontSize: 25, color: Colors.white),
              )
            ],
          ),
        ),
        body: Consumer<ChatProvider>(
          builder: (context, chatProvider, _) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    'Members: ${chatProvider.chatDetails?.members.join(', ') ?? widget.combinedid}'),
              ),
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final message = chatProvider.messages[index];
                    final bool isMe = message.senderId == widget.userId;

                    return MessageBubble(
                      text: message.text,
                      isMe: isMe,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: "Enter your message...",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        chatProvider.sendGroupMessage(_messageController.text,
                            widget.userId, widget.receiverId, widget.userName);

                        _messageController.clear();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;

  MessageBubble({required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            borderRadius: BorderRadius.circular(30.0),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15.0,
                  color: isMe ? Colors.white : Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
