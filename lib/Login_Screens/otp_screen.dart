import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive_flutter_app/Utils/constants.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class OtpVerify extends StatefulWidget {
  final phoneNumber;
  OtpVerify({
    required this.phoneNumber,
    Key? key,
  }) : super(key: key);

  @override
  State<OtpVerify> createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> with CodeAutoFill {
  final TextEditingController _otpController = TextEditingController();
  bool isLoading = false;
  bool invalidText = false;

  dynamic verificationApi, checkUserExistenceApi;
  bool resendOtpButtonEnabled = false;
  int seconds = 15;
  bool timerRemaining = true;
  // late SharedPreferences _sharedPreferences;
  String resendText = '';
  late StopWatchTimer stopWatchTimer;
  String otptimeRemaining = '';
  String otp1 = '';

  // initializePrefs() async {
  //   _sharedPreferences = await SharedPreferences.getInstance();
  //   // await apiValue.store();
  // }

  void startOTPTimer() {
    if (kDebugMode) {
      print('Stopwatch timer started!');
    }
    stopWatchTimer.onStartTimer();
  }

  void resetOTPTimer() {
    if (kDebugMode) {
      print('Stopwatch timer reset!');
    }
    stopWatchTimer.onResetTimer();
    // Seconds = 15;
    timerRemaining = true;
  }

  void stopOTPTimer() {
    if (kDebugMode) {
      print('Stopwatch timer stopped!');
    }
    setState(() {
      timerRemaining = false;
      resendOtpButtonEnabled = true;
    });
    stopWatchTimer.onStopTimer();
  }

  @override
  void codeUpdated() {
    if (kDebugMode) {
      print("CODE RECIEVED");
    }
    setState(() {
      otp1 = code!;
    });
  }

  @override
  void initState() {
    super.initState();
    SmsAutoFill().listenForCode();
    // initializePrefs();

    stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      presetMillisecond: StopWatchTimer.getMilliSecFromSecond(15),
      // millisecond => minute.
      onChange: (value) => {},
      onChangeRawSecond: (value) => {
        if (mounted)
          {
            setState(() {
              // otptimeRemaining = (value != null) ? value.toString() : '';
              otptimeRemaining = value.toString();
              resendText = '($otptimeRemaining)';
              if (value == 0) {
                resendOtpButtonEnabled = true;
                stopOTPTimer();
              }
              if (kDebugMode) {
                print('otp time remaining: $otptimeRemaining');
              }
            }),
          }
      },
      onChangeRawMinute: (value) => {},
    );
    startOTPTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _otpController.dispose();
    if (kDebugMode) {
      print('Stopping Stopwatch timer!');
    }
    SmsAutoFill().unregisterListener();
    stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
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
                    'assets/icon1.png',
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
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        //----------------------------------image-------------------------------------------------//
                        Center(
                          child: Image.asset(
                            'assets/onboarding/otps.png',
                            height: 200,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        //----------------------------------text , number and edit---------------------------------//
                        Center(
                          child: const Text(
                            'Enter the OTP sent to your number.',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // number and edit
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                ' +91 ${widget.phoneNumber.toString()}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Nunito',
                                  fontSize: 15,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.edit,
                                  size: 16,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        //----------------------------------------textfield----------------------------------------------//
                        SizedBox(
                          width: size.width * 0.5,
                          height: 70,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: PinFieldAutoFill(
                              autoFocus: false,
                              currentCode: otp1,
                              codeLength: 4,
                              // decoration: BoxDecoration(
                              //   borderRadius: BorderRadius.circular(10),
                              //   border: Border.all(
                              //     color: MyColors.primaryColor,
                              //     width: 2,
                              //   ),
                              // ),
                              decoration: UnderlineDecoration(
                                textStyle: TextStyle(
                                    color: MyColors.primaryColor,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'DM_Sans'),
                                gapSpace: 20,
                                colorBuilder: PinListenColorBuilder(
                                  MyColors.primaryColor,
                                  MyColors.primaryColor,
                                ),
                                lineHeight: 2.0,
                              ),
                              controller: _otpController,
                              onCodeChanged: (otp) async {
                                // if (kDebugMode) {
                                //   print('e286r628r826r8686r62386');
                                // }
                                // otp1 = otp!;
                                // if (otp.length == 4) {
                                //   setState(() {
                                //     isLoading = true;
                                //   });
                                //   if (kDebugMode) {
                                //     print('OTP: $otp1');
                                //   }
                                //   if (await apiValue.verifyOTP(otp) ==
                                //       'success') {
                                //     var userExistenceResponse =
                                //         await apiValue.checkUserExistance();

                                //     if (userExistenceResponse != null) {
                                //       setState(() {
                                //         isLoading = false;
                                //       });

                                //       // Extracting the user ID from the API response
                                //       String userId =
                                //           userExistenceResponse['data']['_id']
                                //               .toString();
                                //       print('userid======$userId');

                                //       // _sharedPreferences.setBool('isLoggedIn', true);
                                //       SharedPreferencesHelper.setIsLoggedIn(
                                //           isLoggedIn: true);
                                //       SharedPreferencesHelper.setNewUserId(
                                //           userId: userId);
                                //       await GetUserData()
                                //           .getUserDetails(userId);

                                //       Navigator.popUntil(
                                //           context, (route) => false);
                                //       Navigator.push(
                                //         context,
                                //         PageTransition(
                                //           type: PageTransitionType
                                //               .rightToLeftJoined,
                                //           child: BottomNav(currentIndex: 0),
                                //           duration:
                                //               const Duration(milliseconds: 900),
                                //           reverseDuration:
                                //               const Duration(milliseconds: 400),
                                //           childCurrent: widget,
                                //         ),
                                //       );

                                //       stopOTPTimer();
                                //     } else {
                                //       setState(() {
                                //         isLoading = false;
                                //       });
                                //       Navigator.pushReplacement(
                                //         context,
                                //         PageTransition(
                                //           type: PageTransitionType
                                //               .rightToLeftJoined,
                                //           child:  RegisterationScreen(),
                                //           // duration: Duration(milliseconds: 400),
                                //           // reverseDuration:
                                //           //     Duration(milliseconds: 400),
                                //           childCurrent: widget,
                                //         ),
                                //       );
                                //       stopOTPTimer();
                                //     }
                                //   } else {
                                //     setState(() {
                                //       _otpController.clear();
                                //       isLoading = false;
                                //       invalidText = true;
                                //     });
                                //     Fluttertoast.showToast(
                                //       msg: "Something Went Wrong",
                                //       toastLength: Toast.LENGTH_LONG,
                                //       gravity: ToastGravity.BOTTOM,
                                //       timeInSecForIosWeb: 1,
                                //       backgroundColor: MyColors.primaryColor,
                                //       textColor: Colors.white,
                                //       fontSize: 16.0,
                                //     );
                                //   }
                                //   setState(() {
                                //     isLoading = false;
                                //   });
                                // }
                              },
                              onCodeSubmitted: (otp) async {
                                // if (kDebugMode) {
                                //   print(
                                //       '.........................................');
                                // }
                                // otp1 = otp;
                                // if (kDebugMode) {
                                //   print('message: OTP submitted');
                                // }
                                // if (otp.length == 4) {
                                //   setState(() {
                                //     isLoading = true;
                                //   });
                                //   if (await apiValue.verifyOTP(otp) ==
                                //       'success') {
                                //     var userExistenceResponse =
                                //         await apiValue.checkUserExistance();

                                //     if (userExistenceResponse != null) {
                                //       setState(() {
                                //         isLoading = false;
                                //       });

                                //       // Extracting the user ID from the API response
                                //       String userId =
                                //           userExistenceResponse['data']['_id']
                                //               .toString();
                                //       print('userid======$userId');

                                //       // _sharedPreferences.setBool('isLoggedIn', true);
                                //       SharedPreferencesHelper.setIsLoggedIn(
                                //           isLoggedIn: true);
                                //       SharedPreferencesHelper.setNewUserId(
                                //           userId: userId);
                                //       await GetUserData()
                                //           .getUserDetails(userId);

                                //       Navigator.popUntil(
                                //           context, (route) => false);
                                //       Navigator.push(
                                //         context,
                                //         PageTransition(
                                //           type: PageTransitionType
                                //               .rightToLeftJoined,
                                //           child: BottomNav(currentIndex: 0),
                                //           duration:
                                //               const Duration(milliseconds: 900),
                                //           reverseDuration:
                                //               const Duration(milliseconds: 400),
                                //           childCurrent: widget,
                                //         ),
                                //       );
                                //       stopOTPTimer();
                                //     } else {
                                //       setState(() {
                                //         isLoading = false;
                                //       });
                                //       Navigator.pushReplacement(
                                //         context,
                                //         PageTransition(
                                //           type: PageTransitionType
                                //               .rightToLeftJoined,
                                //           child:  RegisterationScreen(),
                                //           childCurrent: widget,
                                //         ),
                                //       );
                                //       stopOTPTimer();
                                //     }
                                //   } else {
                                //     Fluttertoast.showToast(
                                //       msg: "Something Went Wrong",
                                //       toastLength: Toast.LENGTH_LONG,
                                //       gravity: ToastGravity.BOTTOM,
                                //       timeInSecForIosWeb: 1,
                                //       backgroundColor: MyColors.primaryColor,
                                //       textColor: Colors.white,
                                //       fontSize: 16.0,
                                //     );

                                //     setState(() {
                                //       _otpController.clear();
                                //       invalidText = true;
                                //       isLoading = false;
                                //     });
                                //   }
                                //   setState(() {
                                //     isLoading = false;
                                //   });
                                // }
                              },
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 15,
                        ),
                        //----------------------------------------text , resend button and invalid code-------------------------------//
                        Center(
                          child: const Text(
                            "Didn't receive the code?",
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Color.fromRGBO(92, 92, 92, 1)),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (!resendOtpButtonEnabled)
                                  ? () {}
                                  : () async {
                                      if (kDebugMode) {
                                        print('Resending OTP');
                                      }
                                      resetOTPTimer();
                                      setState(() {
                                        resendOtpButtonEnabled = false;
                                        _otpController.clear();
                                      });
                                      startOTPTimer();

                                      // await apiValue.sendOTP(
                                      //   // _sharedPreferences
                                      //   //     .getString('userMobNum')
                                      //   //     .toString(),
                                      //   SharedPreferencesHelper.getUserPhone(),
                                      //   await SmsAutoFill().getAppSignature,
                                      // );

                                      // print("debug : " + TimerRemaining.toString());
                                    },
                              child: Text(
                                'Resend OTP',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "DM-Sans",
                                  fontWeight: FontWeight.w500,
                                  color: MyColors.primaryColor,
                                  decoration: TextDecoration.underline,
                                  decorationColor: MyColors.primaryColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            !resendOtpButtonEnabled
                                ? Text(
                                    resendText,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Nunito",
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromRGBO(53, 53, 53, 1),
                                    ),
                                  )
                                : SizedBox()
                          ],
                        ),

                        // invalid code
                        if (invalidText)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
                            child: Text(
                              'Invalid code, please enter the correct OTP',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(255, 0, 0, 1),
                              ),
                            ),
                          ),
                        //--------------------------------button---------------------------------------//
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyColors.primaryColor,
                              disabledBackgroundColor: MyColors.primaryColor,
                              minimumSize: Size(double.infinity, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: isLoading
                                ? null
                                : () async {
                                    // if (_otpController.text.isEmpty) {
                                    //   Fluttertoast.showToast(
                                    //     msg: "Please Enter OTP",
                                    //     toastLength: Toast.LENGTH_LONG,
                                    //     gravity: ToastGravity.BOTTOM,
                                    //     timeInSecForIosWeb: 1,
                                    //     backgroundColor: MyColors.primaryColor,
                                    //     textColor: Colors.white,
                                    //     fontSize: 16.0,
                                    //   );
                                    // } else {
                                    //   setState(() {
                                    //     isLoading = true;
                                    //   });
                                    //   if (kDebugMode) {
                                    //     print(
                                    //         '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1');
                                    //   }

                                    //   verificationApi =
                                    //       await apiValue.verifyOTP(
                                    //     otp1,
                                    //   );
                                    //   if (verificationApi == 'success') {
                                    //     var userExistenceResponse =
                                    //         await apiValue.checkUserExistance();

                                    //     if (userExistenceResponse != null) {
                                    //       setState(() {
                                    //         isLoading = false;
                                    //       });

                                    //       // Extracting the user ID from the API response
                                    //       String userId =
                                    //           userExistenceResponse['data']
                                    //                   ['_id']
                                    //               .toString();
                                    //       print('userid======$userId');

                                    //       // _sharedPreferences.setBool('isLoggedIn', true);
                                    //       // SharedPreferencesHelper.setIsLoggedIn(
                                    //       //     isLoggedIn: true);
                                    //       // SharedPreferencesHelper.setNewUserId(
                                    //       //     userId: userId);
                                    //       // await GetUserData()
                                    //       //     .getUserDetails(userId);

                                    //       Navigator.popUntil(
                                    //           context, (route) => false);
                                    //       Navigator.push(
                                    //         context,
                                    //         PageTransition(
                                    //           type: PageTransitionType
                                    //               .rightToLeftJoined,
                                    //           child: BottomNav(),
                                    //           duration: const Duration(
                                    //               milliseconds: 900),
                                    //           reverseDuration: const Duration(
                                    //               milliseconds: 400),
                                    //           childCurrent: widget,
                                    //         ),
                                    //       );
                                    //     } else {
                                    //       setState(() {
                                    //         isLoading = false;
                                    //       });
                                    //       Navigator.pushReplacement(
                                    //         context,
                                    //         PageTransition(
                                    //           type: PageTransitionType
                                    //               .rightToLeftJoined,
                                    //           child: const RegisterScreen(),
                                    //           childCurrent: widget,
                                    //         ),
                                    //       );
                                    //     }
                                    //   } else {
                                    //     Fluttertoast.showToast(
                                    //       msg: "Something Went Wrong",
                                    //       toastLength: Toast.LENGTH_LONG,
                                    //       gravity: ToastGravity.BOTTOM,
                                    //       timeInSecForIosWeb: 1,
                                    //       backgroundColor: MyColors.primaryColor,
                                    //       textColor: Colors.white,
                                    //       fontSize: 16.0,
                                    //     );
                                    //     setState(() {
                                    //       isLoading = false;
                                    //     });
                                    //   }
                                    // }
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
                                    'Proceed',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Nunito',
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    )),
              ),
            ]),
          ),
        ],
      ),
    ));
  }
}
