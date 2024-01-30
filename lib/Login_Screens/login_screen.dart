import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController mobNumController = TextEditingController();
  // SharedPreferences? _sharedPreferences;
  bool isLoading = false;
  bool isWhatsapp = false;

  // Future<void> initializePrefs() async {
  //   // _auth = FirebaseAuth.instance;
  //   _sharedPreferences = await SharedPreferences.getInstance();
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   initializePrefs();
  // }

  @override
  void dispose() {
    super.dispose();
    mobNumController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.07,
            ),
            Container(
                height: size.height * 0.13,
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(
                    //   height: size.height * 0.2,
                    // ),
                    Image.asset(
                      'images/logo.png',
                      // height: size.height * 0.4,
                      width: size.width * 0.1,
                      // fit: BoxFit.contain,
                    ),
                    SizedBox(
                      width: size.width * 0.02,
                    ),
                    Text(
                      "Mitra Fintech",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: MyColors.primaryColor),
                    ),
                  ],
                )),
            Container(
              height: size.height * 0.8,
              child: Stack(children: [
                Container(
                  height: size.height * 0.1,
                  width: size.width,
                  color: MyColors.primaryColor,
                ),
                Positioned(
                  top: size.height * 0.02,
                  left: (size.width - size.width * 0.9) / 2,
                  child: Container(
                      height: size.height * 0.7,
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 2.0,
                          ),
                        ],
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage('images/h6.png'),
                              width: size.width * 0.5,
                            ),
                            Container(
                              height: size.height * 0.4,
                              padding: EdgeInsets.all(20),
                              child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(" Login/Signup"),
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    IntlPhoneField(
                                      keyboardType: TextInputType.number,
                                      cursorColor: Colors.black,
                                      controller: mobNumController,
                                      showCountryFlag: false,
                                      showDropdownIcon: false,
                                      initialCountryCode: 'IN',
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      textAlign: TextAlign.justify,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(0),
                                        counterText: '',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: MyColors.primaryColor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: size.height * 0.03,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: MyColors.primaryColor,
                                        disabledBackgroundColor:
                                            MyColors.primaryColor,
                                        minimumSize: Size(double.infinity, 45),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: isLoading
                                          ? null
                                          : () async {
                                              // if (mobNumController
                                              //     .text.isEmpty) {
                                              //   Fluttertoast.showToast(
                                              //     msg:
                                              //         "Please Enter Your Mobile Number",
                                              //     toastLength:
                                              //         Toast.LENGTH_LONG,
                                              //     gravity: ToastGravity.BOTTOM,
                                              //     timeInSecForIosWeb: 1,
                                              //     backgroundColor:
                                              //         MyColors.blue,
                                              //     textColor: Colors.white,
                                              //     fontSize: 16.0,
                                              //   );
                                              // } else if (mobNumController
                                              //         .text.length !=
                                              //     10) {
                                              //   Fluttertoast.showToast(
                                              //     msg:
                                              //         "Please Enter a valid Mobile Number",
                                              //     toastLength:
                                              //         Toast.LENGTH_LONG,
                                              //     gravity: ToastGravity.BOTTOM,
                                              //     timeInSecForIosWeb: 1,
                                              //     backgroundColor:
                                              //         MyColors.blue,
                                              //     textColor: Colors.white,
                                              //     fontSize: 16.0,
                                              //   );
                                              // } else {
                                              //   SharedPreferencesHelper
                                              //       .setUserPhone(
                                              //     userPhone: mobNumController
                                              //         .text
                                              //         .toString(),
                                              //   );
                                              //   setState(() {
                                              //     isLoading = true;
                                              //   });

                                              //   if (await apiValue.sendOTP(
                                              //           mobNumController.text
                                              //               .toString(),
                                              //           await SmsAutoFill()
                                              //               .getAppSignature) ==
                                              //       'success') {
                                              //     setState(() {
                                              //       isLoading = false;
                                              //     });
                                              //     Navigator.push(
                                              //       context,
                                              //       PageTransition(
                                              //         type: PageTransitionType
                                              //             .rightToLeftJoined,
                                              //         child: OtpVerify(
                                              //           phoneNumber:
                                              //               mobNumController
                                              //                   .text,
                                              //         ),
                                              //         duration: const Duration(
                                              //             milliseconds: 900),
                                              //         reverseDuration:
                                              //             const Duration(
                                              //                 milliseconds:
                                              //                     400),
                                              //         childCurrent: widget,
                                              //       ),
                                              //     );
                                              //   } else {
                                              //     Fluttertoast.showToast(
                                              //       msg: "Something Went Wrong",
                                              //       toastLength:
                                              //           Toast.LENGTH_LONG,
                                              //       gravity:
                                              //           ToastGravity.BOTTOM,
                                              //       timeInSecForIosWeb: 1,
                                              //       backgroundColor:
                                              //           MyColors.blue,
                                              //       textColor: Colors.white,
                                              //       fontSize: 16.0,
                                              //     );
                                              //     setState(() {
                                              //       isLoading = false;
                                              //     });
                                              //     // }
                                              //   }
                                              //   setState(() {
                                              //     isLoading = false;
                                              //   });
                                              // }
                                              Navigator.push<void>(
                                                context,
                                                MaterialPageRoute<void>(
                                                  builder:
                                                      (BuildContext context) =>
                                                          const LoginScreen(),
                                                ),
                                              );
                                            },
                                      child: isLoading
                                          ? const Align(
                                              alignment: Alignment.center,
                                              child: SpinKitThreeBounce(
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            )
                                          : Text(
                                              'Request OTP',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Nunito',
                                              ),
                                            ),
                                    ),
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    Text(
                                        "By continuing, you agree to our Terms of Use and Privacy Policy.")
                                  ]),
                            )
                          ])),
                ),
              ]),
            ),
          ],
        ),
      ),
    ));
  }
}
