import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter_app/Bottom_Nav/chatscreen/userchat/chatting_screen.dart';
import 'package:hive_flutter_app/Login_Screens/login_screen.dart';
import 'package:hive_flutter_app/api_values.dart';

class AllUserList extends StatefulWidget {
  const AllUserList({super.key});

  @override
  State<AllUserList> createState() => _AllUserListState();
}

class _AllUserListState extends State<AllUserList> {
  final _secureStorage = const FlutterSecureStorage();
  String? token;
  int tileLength = 0;
  List name = [];
  List allUserList = [];
  String currentUserId = '';
  String sendername = '';

  initializePrefs() async {
    try {
      String? storedToken = await _secureStorage.read(key: 'token');
      if (storedToken != null) {
        setState(() {
          token = storedToken;
        });
        var response2 = await apiValue.getListOfAllUsers(token!);
        print('-----------------------');
        if (response2 != null) {
          allUserList = response2;
        } else {
          print('tokenmck all users====$token');
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
          sendername = userData['name'].toString();
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
        elevation: 0,
        centerTitle: true,
        title: const Text('All Users'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          padding: EdgeInsets.only(top: 20),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: allUserList.length,
          itemBuilder: (context, index) {
            final userName = allUserList[index]['name'] ?? '';
            final userNumber = allUserList[index]['phone'] ?? '';
            final userId = allUserList[index]['id'].toString();

// If the user ID from the list matches the current user ID, return an empty container
            if (userId == currentUserId) {
              return const SizedBox
                  .shrink(); // This will not display anything for this item in the list
            }
            return Builder(
              builder: (context) {
                return Container(
                  margin:
                      const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    onTap: () async {
                      List<String> ids = [currentUserId, userId];
                      ids.sort();
                      String combinedChatId = ids.join('_');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatingPage(
                            combinedid: combinedChatId,
                            sendername: sendername,
                            receiverId: userId,
                            chatDocumentId: combinedChatId,
                            userId: currentUserId,
                            recievername: userName,
                          ),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      // Using dummy icon as profile picture
                      child: CircleAvatar(
                        radius: 85,
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage('images/dummy_dp.png'),
                      ),
                      backgroundColor: Colors.grey,
                    ),
                    title: Text(
                      userName,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    subtitle: Text(
                      userNumber,
                      // "Last message...", // Dummy text for the last message preview
                      overflow: TextOverflow.ellipsis,
                    ),
                    // trailing: Column(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text("12:34 PM"), // Dummy time for the message
                    //     SizedBox(height: 5),
                    //     Container(
                    //       height: 15,
                    //       width: 15,
                    //       decoration: BoxDecoration(
                    //         color: Colors.green,
                    //         shape: BoxShape.circle,
                    //       ),
                    //       child: Center(
                    //         child: Text(
                    //           '2',
                    //           style: TextStyle(color: Colors.white),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
