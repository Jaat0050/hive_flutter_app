import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter_app/Bottom_Nav/chatscreen/groupchat/group_chatting_screen.dart';
import 'package:hive_flutter_app/Login_Screens/login_screen.dart';
import 'package:hive_flutter_app/api_values.dart';

class GroupAdd extends StatefulWidget {
  const GroupAdd({
    Key? key,
  }) : super(key: key);

  @override
  State<GroupAdd> createState() => _GroupAddState();
}

class _GroupAddState extends State<GroupAdd> {
  TextEditingController _groupNameController = TextEditingController();
  late List<String> selectedUsers;

  final _secureStorage = const FlutterSecureStorage();
  String? token;
  int tileLength = 0;
  List name = [];
  List allUserList = [];
  String currentUserId = '';

  initializePrefs() async {
    try {
      String? storedToken = await _secureStorage.read(key: 'token');
      if (storedToken != null) {
        setState(() {
          token = storedToken;
        });
        var response2 = await apiValue.getListOfAllUsers(token!);
        if (response2 != null) {
          allUserList = response2;
          print('list============$allUserList');
        } else {
          var response = await apiValue.refresh(token!);
          if (response == null) {
            if (token != null) {
              await _secureStorage.delete(key: 'token');
            }
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (Route<dynamic> route) => false);
          } else {
            if (response['code'] == 'TOKEN_REFRESH') {
              token = response['token'];
              await _saveToken(token!);
              initializePrefs();
            } else {
              if (token != null) {
                await _secureStorage.delete(key: 'token');
              }
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false);
            }
          }
        }
      } else {
        print('token====$token');
      }
    } catch (e, s) {
      print('Error: $e');
      print('Stack Trace: $s');
    }
    try {
      String? storedToken = await _secureStorage.read(key: 'token');
      if (storedToken != null) {
        setState(() {
          token = storedToken;
        });
        var response2 = await apiValue.userDeatails(token!);
        print('response ====$response2');
        if (response2.containsKey('user')) {
          final userData = response2['user'];
          currentUserId = userData['id'].toString();
          if (!selectedUsers.contains(currentUserId)) {
            setState(() {
              selectedUsers.add(currentUserId);
            });
          }
        } else {}
      } else {
        print('token====$token');
      }
    } catch (e, s) {
      print('Error: $e');
      print('Stack Trace: $s');

      // Optionally, you can show an error message to the user or take appropriate action.
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadToken();
    initializePrefs();
    selectedUsers = [];
  }

  Future<void> _saveToken(String token) async {
    await _secureStorage.write(key: 'token', value: token);
  }

  Future<void> _loadToken() async {
    String? storedToken = await _secureStorage.read(key: 'token');
    if (storedToken != null) {
      setState(() {
        token = storedToken;
      });
    } else {
      // Handle the case where the token is not found in secure storage
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text(
          "Create Group",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(
              "Create",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () async {
              List<String> ids = selectedUsers;
              ids.sort(); // sort lexicographically
              String combinedChatId = ids.join('_');

              final members = {currentUserId, ...selectedUsers}.toList();
              await FirebaseFirestore.instance
                  .collection('chats')
                  .doc(combinedChatId)
                  .set({
                'name': _groupNameController.text,
                'members': members,
                'createdOn': Timestamp.now(),
                'type': 'group',
              });

              // Navigator.pop(context);
              // Optionally, navigate to the group chat page here
              if (_groupNameController.text.isNotEmpty) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupChatingPage(
                      combinedid: combinedChatId,
                      userName: _groupNameController.text,
                      receiverId: selectedUsers,
                      chatDocumentId: combinedChatId,
                      userId: currentUserId,
                    ),
                  ),
                );
              } else {
                final snackBar =
                    SnackBar(content: Text('Write group name first!'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: _groupNameController,
                decoration: InputDecoration(
                  labelText: "Group Name",
                ),
              ),
            ),
            SizedBox(height: 20),
            ListView.builder(
              padding: EdgeInsets.only(top: 20),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: allUserList.length,
              itemBuilder: (context, index) {
                final user = allUserList[index];
                final userName = user['name'] ?? '';
                final userId = user['id'].toString();

                if (userId == currentUserId) return SizedBox.shrink();

                return Container(
                  margin:
                      const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: CheckboxListTile(
                    title: Text(userName),
                    value: selectedUsers.contains(userId),
                    onChanged: (checked) {
                      setState(() {
                        if (checked!) {
                          selectedUsers.add(userId);
                          print('idididid=====$selectedUsers');
                        } else {
                          selectedUsers.remove(userId);
                        }
                      });
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
