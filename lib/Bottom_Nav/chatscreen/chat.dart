import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive_flutter_app/Bottom_Nav/chatscreen/groupchat/group_add.dart';
import 'package:hive_flutter_app/Bottom_Nav/chatscreen/groupchat/group_chatting_screen.dart';
import 'package:hive_flutter_app/Bottom_Nav/chatscreen/userchat/all_userlist.dart';
import 'package:hive_flutter_app/Bottom_Nav/chatscreen/userchat/chatting_screen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // final _secureStorage = const FlutterSecureStorage();
  // String? token;
  // int tileLength = 0;
  // List name = [];
  // List<Map<String, dynamic>> allUserList = [];
  String currentUserId = '';
  String currentUserName = '';
  final _secureStorage = FlutterSecureStorage();

  // initializePrefs() async {
  //   try {
  //     String? storedToken = await _secureStorage.read(key: 'token');
  //     if (storedToken != null) {
  //       setState(() {
  //         token = storedToken;
  //       });
  //       var response2 = await apiValue.userDeatails(token!);
  //       if (response2.containsKey('user')) {
  //         final userData = response2['user'];
  //         currentUserId = userData['id'].toString();
  //       } else {}
  //     } else {
  //       print('token====$token');
  //     }
  //   } catch (e, s) {
  //     print('Error: $e');
  //     print('Stack Trace: $s');
  //     // Optionally, you can show an error message to the user or take appropriate action.
  //   }
  // }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    setState(() {
      currentUserId = userId ?? '';
    });
    String? Currentusername = prefs.getString('currUsername');
    setState(() {
      currentUserName = Currentusername ?? '';
    });
  }

  Future<void> _loadToken() async {
    String? storedToken1 = await _secureStorage.read(key: 'accessToken');
    String? storedToken2 = await _secureStorage.read(key: 'refreshToken');
    if (storedToken1 != null && storedToken2 != null) {
      String token1 = storedToken1;
      String token2 = storedToken2;
      print('==============token1====================\n$token1');
      print('==========================================');
      print('==============token2================\n$token2');
    } else {
      print('error');
      // Handle the case where the token is not found in secure storage
    }
  }

  @override
  void initState() {
    super.initState();
    // _loadToken();
    _loadUserId();
    // initializePrefs();
    getChatsStream();
  }

  // Future<void> _loadToken() async {
  //   String? storedToken = await _secureStorage.read(key: 'token');
  //   if (storedToken != null) {
  //     setState(() {
  //       token = storedToken;
  //     });
  //   } else {
  //     // Handle the case where the token is not found in secure storage
  //   }
  // }

  Stream<QuerySnapshot> getChatsStream() {
    return FirebaseFirestore.instance
        .collection('chats')
        .where('members', arrayContains: currentUserId)
        .orderBy('lastMessageTimestamp', descending: true)
        .snapshots();
  }

  Future<void> resetUnreadCount(String chatDocId) async {
    final chatDocRef =
        FirebaseFirestore.instance.collection('chats').doc(chatDocId);

    await chatDocRef.update({'unreadCount.$currentUserId': 0});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () async {
              await _loadToken();
            },
            child: Icon(
              Icons.abc,
              size: 50,
            ),
          )
        ],
        backgroundColor: Colors.grey,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Chat'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getChatsStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong!'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<DocumentSnapshot> chatDocs = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.only(top: 20),
            shrinkWrap: true,
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              var chatData = chatDocs[index].data() as Map<String, dynamic>;
              print('==================$chatData');
              final groupName = chatData['name'] ?? '';
              final userType = chatData['type'] ?? '';
              final List members = chatData['members'] ?? [];
              final List memberName = chatData['memberNames'] ?? [];
              String userId = '';
              List userGroupIds = [];
              List userIds = [];
              String combinedChatId = '';
              List ids = [];
              String combinedGroupChatId = '';

              // Extract the last message and timestamp from the chatData.
              final lastMessageData =
                  chatData['lastMessage'] as Map<String, dynamic>?;

              final Timestamp lastmessagetimestamp =
                  chatData['lastMessageTimestamp'] ?? [];

              String lastMessageText = "";
              String lastMessageTime = "";

              final unreadCountMap =
                  chatData['unreadCount'] as Map<String, dynamic>?;
              final int unreadCount = unreadCountMap?[currentUserId] ?? 0;

              if (lastMessageData != null && lastmessagetimestamp != null) {
                lastMessageText = lastMessageData['text'] ?? '';
                final timestamp = lastMessageData['timestamp'] as Timestamp?;
                if (timestamp != null) {
                  // Convert the timestamp to your desired format.
                  final dateTime = timestamp.toDate();
                  final timeFormat = DateFormat('hh:mm a');
                  lastMessageTime = timeFormat.format(dateTime);
                }
              }
              String userName = '';
              if (members.contains(currentUserId) && memberName != null) {
                int userIndex = members.indexOf(currentUserId);
                if (userType == 'users') {
                  // For one-to-one chats, show the other user's name.
                  userName = userIndex == 0 ? memberName[1] : memberName[0];
                } else if (userType == 'group') {
                  // Remove current user's name from the list
                  userName =
                      ''; // Join the names with a comma or any other logic you prefer
                }
              }
              if (userType == 'users') {
                userId = members[1];
                if (userId == currentUserId) {
                  userId = members[0];
                }
                userIds = members;
                userIds.sort(); // sort lexicographically
                combinedChatId = userIds.join('_');
              } else if (userType == 'group') {
                userGroupIds = members.sublist(1);
                ids = members;
                ids.sort(); // sort lexicographically
                combinedGroupChatId = ids.join('_');
              }

              // if (userId == currentUserId) {
              //   return const SizedBox.shrink();
              // }

              return Builder(
                builder: (context) {
                  return Container(
                    margin:
                        const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color:
                          userType != 'users' ? Colors.black26 : Colors.black12,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      onTap: () async {
                        await resetUnreadCount(chatDocs[index].id);
                        if (userType == 'users') {
                          print('curr===$currentUserId');
                          print('curr====$userId');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatingPage(
                                sendername: currentUserName,
                                recievername: userName,
                                receiverId: userId,
                                chatDocumentId: combinedChatId,
                                userId: currentUserId,
                                combinedid: combinedChatId,
                              ),
                            ),
                          );
                        } else {
                          print('curr===$currentUserId');
                          print('curr====$userGroupIds');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroupChatingPage(
                                userName: groupName,
                                receiverId: userGroupIds,
                                chatDocumentId: combinedGroupChatId,
                                userId: currentUserId,
                                combinedid: combinedGroupChatId,
                              ),
                            ),
                          );
                        }
                      },
                      leading: CircleAvatar(
                        child: userType == 'users'
                            ? Image(image: AssetImage('images/dummy_dp.png'))
                            // AssetImage('images/dummy_dp.png')
                            // Icon(Icons.person, color: Colors.white)
                            : Icon(
                                Icons.group,
                                color: Colors.white,
                              ),
                      ),
                      title: Row(
                        children: [
                          Text(userType == 'users' ? userName : groupName,
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 20)),
                          SizedBox(
                            width: 50,
                          ),
                          Text(userType == 'users' ? userType : userType,
                              style: TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                      subtitle: Text(lastMessageText,
                          overflow: TextOverflow.ellipsis),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(lastMessageTime),
                          SizedBox(height: 5),
                          if (unreadCount >
                              0) // Only show the unread count if it's greater than 0.
                            Container(
                              height: 18,
                              width: 18,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '$unreadCount',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons
            .menu_close, // This will show a button with an animated icon
        children: [
          SpeedDialChild(
            child: Icon(Icons.group),
            label: 'Make Group',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupAdd(),
                ),
              );
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.list),
            label: 'All User List ',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllUserList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
