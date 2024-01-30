import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter_app/Login_Screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String? selectedGender;
  List<String> gender = ['Male', 'Female', 'Others'];
  final _secureStorage = const FlutterSecureStorage();

  String? token;

  initializePrefs() async {
    try {
      String? storedToken = await _secureStorage.read(key: 'token');
      if (storedToken != null) {
        setState(() {
          token = storedToken;
          print('==============$token');
        });
        // var response2 = await apiValue.userDeatails(token!);

        var response2;
        if (response2 != null) {
          if (response2.containsKey('user')) {
            final userData = response2['user'];
            nameController.text = userData['name'] ?? '';
            dobController.text = userData['dateofbirth'] ?? '';
            phoneController.text = userData['phone'] ?? '';
            selectedGender = userData['gender'] ?? '';

            _saveUserId(userData['id'].toString(), userData['name'].toString());
          } else {
            nameController.text = 'name';
            dobController.text = 'dateofbirth';
            phoneController.text = 'phone';
            selectedGender = 'gender';
          }
        } else {
          // var response = await apiValue.refresh(token!);

          var response;
          if (response == false) {
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
      // Handle any exceptions that might occur during token retrieval or API call
      // Log the error and stack trace
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

  Future<void> _saveUserId(String userId, String currentname) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
    await prefs.setString('currUsername', currentname);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () async {
              // var response = await apiValue.logout(token!);

              var response;
              if (response) {
                print(response);
                if (token != null) {
                  await _secureStorage.delete(key: 'token');
                }
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (Route<dynamic> route) => false);
              } else {
                print('error');
              }
            },
            child: const Icon(Icons.logout),
          ),
        ],
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Profile'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: SizedBox(
                                height: 210,
                                child: const CircleAvatar(
                                  radius: 85,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage:
                                      AssetImage('images/dummy_dp.png'),
                                )
                                // : CircleAvatar(
                                //     radius: 52,
                                //     backgroundColor:
                                //         const Color.fromARGB(0, 105, 84, 84),
                                //     backgroundImage: Image.asset(
                                //                 "assets/images/profile/camera.png"),
                                //     // CachedNetworkImageProvider(
                                //     //     apiValue.dpDomain +
                                //     //         SharedPreferencesHelper
                                //     //             .getUserProfilePic()),
                                //     child: Stack(
                                //       children: [
                                //         Positioned(
                                //           top: 86,
                                //           left: 68,
                                //           child: SizedBox(
                                //             width: 24,
                                //             child: Image.asset(
                                //                 "assets/images/profile/greenBg.png"),
                                //           ),
                                //         ),
                                //         Positioned(
                                //           top: 93,
                                //           left: 74,
                                //           child: SizedBox(
                                //             width: 13,
                                //             child: Image.asset(
                                //                 "assets/images/profile/camera.png"),
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Full name',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(151, 150, 161, 1),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 50,
                            width: width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Color.fromRGBO(35, 170, 73, 0.21),
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              nameController.text,
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 16.0, // Set text size
                                color: Colors.black, // Set text color
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Mobile no.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(151, 150, 161, 1),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 50,
                            width: width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Color.fromRGBO(35, 170, 73, 0.21),
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              phoneController.text,
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 16.0, // Set text size
                                color: Colors.black, // Set text color
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'DOB',
                                style: TextStyle(
                                  color: Color.fromRGBO(109, 109, 109, 1),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              SizedBox(
                                child: Container(
                                  height: 50,
                                  width: width,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Color.fromRGBO(35, 170, 73, 0.21),
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    dobController.text,
                                    style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 16.0, // Set text size
                                      color: Colors.black, // Set text color
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Gender',
                                style: TextStyle(
                                  color: Color.fromRGBO(109, 109, 109, 1),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              SizedBox(
                                child: Container(
                                  height: 50,
                                  width: width,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Color.fromRGBO(35, 170, 73, 0.21),
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    selectedGender.toString(),
                                    style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 16.0, // Set text size
                                      color: Colors.black, // Set text color
                                    ),
                                  ),
                                ),
                                // DropdownButtonFormField(
                                //   value: selectedGender,
                                //   icon: const Icon(
                                //     Icons.keyboard_arrow_down,
                                //     // Replace with the icon of your choice
                                //     color: Color.fromRGBO(179, 179, 179, 1),
                                //     size: 17,
                                //   ),
                                //   onChanged: (value) {
                                //     setState(() {
                                //       selectedGender = value;
                                //     });
                                //   },
                                //   items: gender.map((String relation) {
                                //     return DropdownMenuItem<String>(
                                //       value: relation,
                                //       child: Text(relation),
                                //     );
                                //   }).toList(),
                                //   decoration: InputDecoration(
                                //     hintText: 'Select option',
                                //     hintStyle: const TextStyle(
                                //       fontFamily: 'Mulish',
                                //       fontWeight: FontWeight.w600,
                                //       fontSize: 12,
                                //       color: Color.fromRGBO(208, 208, 208, 1),
                                //     ),
                                //     filled: true,
                                //     fillColor:
                                //         const Color.fromRGBO(255, 255, 255, 1),
                                //     enabledBorder: OutlineInputBorder(
                                //         borderRadius: BorderRadius.circular(5),
                                //         borderSide: const BorderSide(
                                //           color:
                                //               Color.fromRGBO(35, 170, 73, 0.21),
                                //         )),
                                //     focusedBorder: OutlineInputBorder(
                                //         borderRadius: BorderRadius.circular(5),
                                //         borderSide: const BorderSide(
                                //           color:
                                //               Color.fromRGBO(35, 170, 73, 0.21),
                                //         )),
                                //     contentPadding: const EdgeInsets.symmetric(
                                //         horizontal: 15, vertical: 15),
                                //   ),
                                // ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 100,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
