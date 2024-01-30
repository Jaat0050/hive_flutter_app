import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive_flutter_app/Login_Screens/login_screen.dart';
import '../../utils/constants.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  OnBoardingScreenState createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentIndex = 0;
  late PageController _controller;

  bool isLoading = false;

  // initializePrefs() async {
  //   setState(() {
  //     SharedPreferencesHelper.setisFirstTime(isFirstTime: false);
  //   });
  // }

  Widget _buildDots() {
    List<Widget> dots = [];
    for (int i = 0; i < board.length; i++) {
      bool isSelected = i == currentIndex;
      Color fillColor = isSelected ? MyColors.primaryColor : Colors.transparent;
      Color borderColor = MyColors.primaryColor;

      dots.add(InkWell(
        onTap: () {
          print('$i');
          setState(() {
            currentIndex = i;
          });
          _controller.animateToPage(
            i,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: isSelected
              ? Container(
                  width: 26, // width of the rectangle
                  height: 10, // height of the rectangle
                  decoration: BoxDecoration(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(5), // rounded corners
                    border: Border.all(
                      color: borderColor,
                      width: 2.0,
                    ),
                  ),
                )
              : Container(
                  width: 20,
                  height: 10,
                  decoration: BoxDecoration(
                    color: fillColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: borderColor,
                      width: 1.0,
                    ),
                  ),
                ),
        ),
      ));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: dots,
    );
  }

  onChanged(int index) {
    setState(() {
      currentIndex = index;
    });

    if (currentIndex == 3) {
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => LoginScreen(),
      //     ),
      //     (route) => false);
      Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
    // initializePrefs();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Text(
                    'Skip',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(77, 77, 77, 1),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'DM Sans',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        height: height,
        color: Colors.white,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //----------------------------------------------page viewer----------------------------------//
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: board.length,
                onPageChanged: onChanged,
                // physics: NeverScrollableScrollPhysics(),
                allowImplicitScrolling: false,
                itemBuilder: (_, index) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        //----------------------------------------------image----------------------------------//
                        Image.asset(
                          board[currentIndex].image,
                          fit: BoxFit.contain,
                          width: 340,
                          height: 340,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        //----------------------------------------------text 1----------------------------------//

                        Padding(
                          padding: const EdgeInsets.only(left: 50, right: 50),
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
                                    setState(() {
                                      isLoading = true;
                                    });
                                    setState(() {
                                      currentIndex == 2
                                          // ? Navigator.of(context)
                                          //     .pushAndRemoveUntil(
                                          //         PageRouteBuilder(
                                          //           pageBuilder: (context,
                                          //               animation,
                                          //               secondaryAnimation) {
                                          //             return const LoginScreen();
                                          //           },
                                          //           transitionsBuilder:
                                          //               (context,
                                          //                   animation,
                                          //                   secondaryAnimation,
                                          //                   child) {
                                          //             return FadeTransition(
                                          //               opacity: animation,
                                          //               child: child,
                                          //             );
                                          //           },
                                          //           transitionDuration:
                                          //               const Duration(
                                          //                   milliseconds: 500),
                                          //         ),
                                          //         (RoutePredicate) => false)
                                          ? Navigator.push<void>(
                                              context,
                                              MaterialPageRoute<void>(
                                                builder:
                                                    (BuildContext context) =>
                                                        const LoginScreen(),
                                              ),
                                            )
                                          : currentIndex++;
                                    });
                                    setState(() {
                                      isLoading = false;
                                    });
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
                                    'Get Started',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Nunito',
                                    ),
                                  ),
                          ),
                        ),

                        //----------------------------------------------text 2----------------------------------//

                        SizedBox(
                          height: height * 0.12,
                        ),
                        //----------------------------------------------dot----------------------------------//
                        Center(child: _buildDots()),
                        SizedBox(
                          height: height * 0.07,
                        ),
                        //----------------------------------------------button----------------------------------//
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UnbordingContent {
  String image;
  String line1;
  String? title;

  UnbordingContent({
    required this.image,
    required this.line1,
    this.title,
  });
}

List<UnbordingContent> board = [
  UnbordingContent(
    image: 'images/h6.png',
    line1: '',
    title: '',
  ),
  UnbordingContent(
    image: 'images/h6.png',
    line1: '',
    title: '',
  ),
  UnbordingContent(
    image: 'images/h6.png',
    line1: '',
    title: '',
  ),
];
