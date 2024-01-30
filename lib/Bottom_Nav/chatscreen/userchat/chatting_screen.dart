// pages/chat_page.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter_app/Bottom_Nav/chatscreen/chatp.dart';
import 'package:provider/provider.dart';

class ChatingPage extends StatefulWidget {
  final String userId; // This should be the current user's ID
  final String receiverId; // The receiver's ID
  final String chatDocumentId;
  final String sendername;
  final String recievername;
  final String combinedid;

  ChatingPage(
      {required this.userId,
      required this.receiverId,
      required this.sendername,
      required this.chatDocumentId,
      required this.recievername,
      required this.combinedid});

  @override
  _ChatingPageState createState() => _ChatingPageState();
}

class _ChatingPageState extends State<ChatingPage> {
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
                child: Icon(Icons.person, color: Colors.white),
                backgroundColor: Colors.grey,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                widget.recievername,
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
                    chatProvider.refreshChatDetails(); // Refresh chat details
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
                        chatProvider.sendMessage(
                            _messageController.text,
                            widget.userId,
                            widget.receiverId,
                            widget.sendername,
                            widget.recievername);

                        _messageController.clear();
                        chatProvider
                            .refreshChatDetails(); // Refresh chat details
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
