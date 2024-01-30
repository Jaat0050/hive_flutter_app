// providers/chat_provider.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  final String chatDocumentId;
  Chat? chatDetails; // <-- Add this to store the chat details
  List<ChatMessage> messages = [];

  ChatProvider(this.chatDocumentId) {
    _fetchMessages();
    _fetchChatDetails(); // <-- Fetch chat details too
  }

  _fetchMessages() async {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatDocumentId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      messages = snapshot.docs
          .map((doc) => ChatMessage(
                senderId: doc['sender_id'],
                text: doc['text'],
                timestamp: doc['timestamp'],
                readCount: doc['readCount'],
              ))
          .toList();
      if (this.hasListeners) {
        notifyListeners();
      }
    });
  }

  sendMessage(String text, String userId, String receiverId, String senderName,
      String receiverName) async {
    if (text.trim().isNotEmpty) {
      final chatDocRef =
          FirebaseFirestore.instance.collection('chats').doc(chatDocumentId);

      DocumentSnapshot chatDoc = await chatDocRef.get();

      if (!chatDoc.exists) {
        // If it doesn't exist, initialize the chat details.
        await chatDocRef.set({
          'members': [userId, receiverId],
          'memberNames': [senderName, receiverName],
          'type': 'users',
          'createdOn': Timestamp.now(),
          // 'name': username,
          'lastMessage': {
            'text': text,
            'sender_id': userId,
            'timestamp': Timestamp.now(),
          },
          'lastMessageTimestamp': Timestamp.now(),
          'unreadCount': {
            userId:
                0, // Current user has read the message (it's 0 because the sender knows the message)
            receiverId: 1, // Receiver has 1 unread message
          },
        });
      } else {
        // If the chat document already exists, just update the lastMessage field.
        await chatDocRef.update({
          'lastMessage': {
            'text': text,
            'sender_id': userId,
            'timestamp': Timestamp.now(),
          },
          'lastMessageTimestamp': Timestamp.now(),
          'unreadCount.$receiverId': FieldValue.increment(1),
        });
      }

      await chatDocRef.collection('messages').add({
        'text': text,
        'sender_id': userId,
        'timestamp': Timestamp.now(),
        'readCount': 1,
      });
    }
  }

  sendGroupMessage(
      String text, String userId, List receiverId, String groupname) async {
    if (text.trim().isNotEmpty) {
      final chatDocRef =
          FirebaseFirestore.instance.collection('chats').doc(chatDocumentId);

      DocumentSnapshot chatDoc = await chatDocRef.get();

      Map<String, dynamic> unreadCountMap = {};
      for (String id in receiverId) {
        if (id != userId) {
          // Sender should not have unread messages
          unreadCountMap[id] =
              1; // Initialize unread count as 1 for all receivers
        } else {
          unreadCountMap[id] = 0; // Sender's unread count should be 0
        }
      }

      if (!chatDoc.exists) {
        // If it doesn't exist, initialize the chat details.
        await chatDocRef.set({
          'members': [
            ...[userId],
            ...receiverId
          ],
          'type': 'group',
          'createdOn': Timestamp.now(),
          'name': groupname,
          'lastMessage': {
            'text': text,
            'sender_id': userId,
            'timestamp': Timestamp.now(),
          },
          'lastMessageTimestamp': Timestamp.now(),
          'unreadCount': unreadCountMap
        });
      } else {
        // If the chat document already exists, just update the lastMessage field.
        await chatDocRef.update({
          'lastMessage': {
            'text': text,
            'sender_id': userId,
            'timestamp': Timestamp.now(),
          },
          'lastMessageTimestamp': Timestamp.now(),
        });
        for (String id in receiverId) {
          if (id != userId) {
            await chatDocRef.update({
              'unreadCount.$id': FieldValue.increment(1),
            });
          }
        }
      }

      await chatDocRef.collection('messages').add({
        'text': text,
        'sender_id': userId,
        'timestamp': Timestamp.now(),
        'readCount': 1,
      });
    }
  }

  _fetchChatDetails() async {
    var chatDoc = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatDocumentId)
        .get();
    chatDetails = Chat(
      members: List<String>.from(chatDoc.data()?['members'] ?? []),
      type: chatDoc.data()?['type'],
      name: chatDoc.data()?['name'] ?? '',
    );

    // notifyListeners();
  }

  // Function to refresh chat details
  void refreshChatDetails() {
    _fetchChatDetails();
  }
}

// models/chat_message.dart

class ChatMessage {
  final String senderId;
  final String text;
  final Timestamp timestamp;
  final int readCount;

  ChatMessage({
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.readCount,
  });
}

// models/chat.dart

class Chat {
  final List<String> members;
  final String type;
  final String name;

  Chat({required this.members, required this.type, required this.name});
}
