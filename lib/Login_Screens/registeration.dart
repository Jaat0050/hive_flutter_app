import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class RegisterationScreen extends StatefulWidget {
  // String tokenData;
  RegisterationScreen({
    super.key,
    // required this.tokenData
  });

  @override
  State<RegisterationScreen> createState() => _RegisterationScreenState();
}

class _RegisterationScreenState extends State<RegisterationScreen> {
  bool isLoading = false;
  String? token;
  final _secureStorage = FlutterSecureStorage();
  TextEditingController nameController = TextEditingController();

  String? selectedGender;
  List<String> gender = ['Male', 'Female', 'Others'];

  List<int> days = List.generate(31, (index) => index + 1);
  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  List<int> years = List.generate(21, (index) => 1990 + index);

  int? selectedDay;
  String? selectedMonth;
  int? selectedYear;

  File? imageFile;
  XFile? compressedFile;
  String compressedFilePath = '';
  XFile? selectedImage;
  bool imageUploaded = false;
  Uint8List imageBytes = Uint8List(0);

  String? selectedDate;

  void updateDate() {
    if (selectedDay != null && selectedMonth != null && selectedYear != null) {
      selectedDate = '$selectedDay-$selectedMonth-$selectedYear';
    }
  }

  Future<void> getImage() async {
    try {
      var image;
      var imageNormal = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );

      var croppedFile = await ImageCropper().cropImage(
          sourcePath: imageNormal!.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxHeight: 1800,
          maxWidth: 1800,
          compressFormat: ImageCompressFormat.jpg,
          uiSettings: [
            AndroidUiSettings(
              toolbarColor: Colors.green,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
            ),
            IOSUiSettings(
              minimumAspectRatio: 1.0,
            ),
          ]);

      if (croppedFile == null) {
        image = imageNormal;
      } else {
        image = XFile(croppedFile.path);
      }
      print('Image =========== : $image');
      log(image!.path);
      int fileSizeInBytes = await File(image.path).length();
      double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

      log('Original image size: ${fileSizeInMB.toStringAsFixed(2)} MB');
      print('Original image size: ${fileSizeInMB.toStringAsFixed(2)} MB');

      List<int> compressedImageBytes =
          await FlutterImageCompress.compressWithList(
        File(image.path).readAsBytesSync(),
        quality: 20,
      );
      print('==========================');
      print('============================');
      Uint8List compressedUint8List = Uint8List.fromList(compressedImageBytes);
      XFile compressedImage =
          XFile.fromData(compressedUint8List, name: image.path.split('/').last);

      int compressedFileSizeInBytes = await compressedImage.length();
      double compressedFileSizeInMB = compressedFileSizeInBytes / (1024 * 1024);

      log('Compressed image size: ${compressedFileSizeInMB.toStringAsFixed(2)} MB');
      print(
          'Compressed image size: ${compressedFileSizeInMB.toStringAsFixed(2)} MB');
      log(compressedImage.path);
      setState(() {
        selectedImage = image;
        imageFile = File(image.path);
        compressedFile = compressedImage;
        imageBytes = compressedUint8List;
      });

      Directory galleryDir = await getApplicationDocumentsDirectory();
      String galleryPath = galleryDir.path;
      // image.saveTo("$galleryPath\\original1.jpg");
      compressedFile!.saveTo("$galleryPath\\${image.path.split('/').last}");
      compressedFilePath = "$galleryPath\\${image.path.split('/').last}";
      print(galleryPath);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize token value from secure storage when the screen is first loaded
    _loadToken();
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registeration Screen'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
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
                          GestureDetector(
                            onTap: () {
                              getImage();
                              setState(() {
                                imageUploaded = true;
                              });
                            },
                            child: SizedBox(
                                height: 110,
                                child: selectedImage != null
                                    ? Row(
                                        children: [
                                          Container(
                                              height: 116,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color:
                                                          const Color.fromRGBO(
                                                              208,
                                                              208,
                                                              208,
                                                              1))),
                                              child: Image.file(
                                                imageFile!,
                                                fit: BoxFit.cover,
                                              )),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    imageUploaded = false;
                                                    selectedImage = null;
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.close_rounded,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              SizedBox()
                                            ],
                                          )
                                        ],
                                      )
                                    : const CircleAvatar(
                                        radius: 55,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage:
                                            AssetImage('images/dummy_dp.png'),
                                      )),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Registration",
                                      style: TextStyle(
                                        fontFamily: 'DM_Sans',
                                        fontSize: 37,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
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
                          TextFormField(
                            controller: nameController,
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: const Color.fromRGBO(0, 0, 0, 1),
                            decoration: InputDecoration(
                              hintText: 'Enter your name',
                              hintStyle: const TextStyle(
                                color: Color.fromRGBO(196, 196, 196, 1),
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromRGBO(35, 170, 73, 1)),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromRGBO(238, 238, 238, 1)),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          const SizedBox(
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  DropdownButton<int>(
                                    borderRadius: BorderRadius.circular(10.0),
                                    padding: EdgeInsets.all(10),
                                    hint: Text("Day"),
                                    value: selectedDay,
                                    items: days.map((int value) {
                                      return DropdownMenuItem<int>(
                                        value: value,
                                        child: Text(value.toString()),
                                      );
                                    }).toList(),
                                    onChanged: (int? value) {
                                      setState(() {
                                        selectedDay = value;
                                        updateDate();
                                      });
                                    },
                                  ),
                                  DropdownButton<String>(
                                    hint: Text("Month"),
                                    value: selectedMonth,
                                    items: months.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedMonth = value;
                                        updateDate();
                                      });
                                    },
                                  ),
                                  DropdownButton<int>(
                                    hint: Text("Year"),
                                    value: selectedYear,
                                    items: years.map((int value) {
                                      return DropdownMenuItem<int>(
                                        value: value,
                                        child: Text(value.toString()),
                                      );
                                    }).toList(),
                                    onChanged: (int? value) {
                                      setState(() {
                                        selectedYear = value;
                                        updateDate();
                                      });
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              if (selectedDate != null)
                                Text('Selected Date: $selectedDate'),
                            ],
                          ),
                          const SizedBox(
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
                                child: DropdownButtonFormField(
                                  value: selectedGender,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    // Replace with the icon of your choice
                                    color: Color.fromRGBO(179, 179, 179, 1),
                                    size: 17,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value;
                                    });
                                  },
                                  items: gender.map((String relation) {
                                    return DropdownMenuItem<String>(
                                      value: relation,
                                      child: Text(relation),
                                    );
                                  }).toList(),
                                  decoration: InputDecoration(
                                    hintText: 'Select option',
                                    hintStyle: const TextStyle(
                                      fontFamily: 'Mulish',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: Color.fromRGBO(208, 208, 208, 1),
                                    ),
                                    filled: true,
                                    fillColor:
                                        const Color.fromRGBO(255, 255, 255, 1),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(35, 170, 73, 0.21),
                                        )),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(35, 170, 73, 0.21),
                                        )),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          Center(
                            child: SizedBox(
                              height: 58,
                              width: 248,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(35, 170, 73, 1),
                                    elevation: 3,
                                    disabledBackgroundColor:
                                        const Color.fromRGBO(35, 170, 73, 1),
                                    shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                          color: Color.fromRGBO(35, 170, 73, 1),
                                          width: 2,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                  ),
                                  onPressed: () async {
                                    // setState(() {
                                    //   isLoading = true;
                                    // });
                                    // var response = await apiValue.registerUser(
                                    //   token: widget.tokenData,
                                    //   name: nameController.text,
                                    //   dob: selectedDate.toString(),
                                    //   gender: selectedGender.toString(),
                                    // );

                                    // if (response['message'] ==
                                    //     'Details Added Successfully') {
                                    //   Navigator.of(context).pushAndRemoveUntil(
                                    //       MaterialPageRoute(
                                    //           builder: (context) =>
                                    //               BottomNav()),
                                    //       (Route<dynamic> route) => false);
                                    // } else if (response['message'] ==
                                    //     'Token has expired') {
                                    //   String? storedToken = await _secureStorage
                                    //       .read(key: 'token');
                                    //   var response =
                                    //       await apiValue.refresh(storedToken!);
                                    //   if (response['code'] == 'TOKEN_REFRESH') {
                                    //     token = response['token'];
                                    //     await _saveToken(token!);
                                    //   } else {
                                    //     Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //           builder: (context) =>
                                    //               const LoginPage()),
                                    //     );
                                    //   }
                                    // } else {
                                    //   Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             const LoginPage()),
                                    //   );
                                    // }
                                    // setState(() {
                                    //   isLoading = false;
                                    // });
                                  },
                                  child: isLoading
                                      ? SizedBox(
                                          width: 200,
                                          child: const Center(
                                            child: SpinKitThreeBounce(
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          width: 200,
                                          child: Center(
                                            child: Text(
                                              'Register',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                          ),
                                        )),
                            ),
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
