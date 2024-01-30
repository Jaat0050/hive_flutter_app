import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter_app/Login_Screens/onboarding.dart';
import 'package:hive_flutter_app/Utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyD4kRcg14Lrl7AAkSEeJMQ6L1sOwdKNUiI",
      authDomain: "hive-app-flutter.firebaseapp.com",
      projectId: "hive-app-flutter",
      storageBucket: "hive-app-flutter.appspot.com",
      messagingSenderId: "1082730042884",
      appId: "1:1082730042884:android:2e38f49e7f7887e8a80751",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          title: 'Hive',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
            useMaterial3: false,
          ),
          home: AnimatedSplashScreen(
            splash: 'images/logo.png',
            centered: true,
            splashIconSize: double.infinity,
            nextScreen: Scaffold(
              body: DoubleBackToCloseApp(
                // snackBar: const SnackBar(content: Text('double tap to exit app')),
                snackBar: SnackBar(
                  backgroundColor: const Color(0xffF3F5F7),
                  shape: ShapeBorder.lerp(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(2.0), // Starting shape
                    ),
                    const StadiumBorder(), // Ending shape
                    0.2, // Interpolation factor (0.0 to 1.0)
                  )!,
                  width: 200,
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                    'double tap to exit app',
                    style: TextStyle(
                      color: MyColors.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  duration: const Duration(seconds: 1),
                ),
                // child: SharedPreferencesHelper.getisFirstTime() == true
                //     ? const OnBoardingScreen()
                //     : BottomNav(
                //         currentIndex: 0,
                //       ),
                child: OnBoardingScreen(),
              ),
            ),
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: Colors.white,
          ),
        );
      },
    );
  }
}
