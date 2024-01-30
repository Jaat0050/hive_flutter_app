import 'package:flutter/material.dart';

import 'package:hive_flutter_app/Bottom_Nav/chatscreen/chat.dart';
import 'package:hive_flutter_app/Bottom_Nav/explore.dart';
import 'package:hive_flutter_app/Bottom_Nav/mini.dart';
import 'package:hive_flutter_app/Bottom_Nav/profile.dart';
import 'package:hive_flutter_app/Bottom_Nav/wallet.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  List<Widget> pages = [
    const ChatScreen(),
    const ExploreScreen(),
    WalletScreen(),
    const MiniHiveScreen(),
    const ProfileScreen()
  ];

  void _onItemTapped(int index) async {
    if (index >= 0 && index < pages.length) {
      setState(() {
        _selectedIndex = index;
      });
      // await FirebaseAnalytics.instance.logEvent(
      //     name: 'visiting_$index', parameters: {'time': '${DateTime.now()}'});
    }
  }

  @override
  Widget build(BuildContext context) {
    print("hei888ght${MediaQuery.of(context).size.width}");
    return Stack(
      children: [
        Scaffold(
          body: pages.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            unselectedItemColor: const Color.fromRGBO(208, 208, 208, 1),
            selectedItemColor: const Color.fromRGBO(54, 57, 91, 1),
            selectedFontSize: 13,
            unselectedFontSize: 10,
            unselectedLabelStyle: const TextStyle(
              fontFamily: "Poppins",
            ),
            selectedLabelStyle: const TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
            ),
            elevation: 0,
            backgroundColor: const Color.fromRGBO(243, 245, 247, 1),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.chat,
                  color: Color.fromRGBO(35, 170, 73, 1),
                ),
                icon: Icon(
                  Icons.chat,
                  color: Color.fromRGBO(208, 208, 208, 1),
                ),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.explore,
                  color: Color.fromRGBO(35, 170, 73, 1),
                ),
                icon: Icon(
                  Icons.explore,
                  color: Color.fromRGBO(208, 208, 208, 1),
                ),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.wallet,
                  color: Color.fromRGBO(35, 170, 73, 1),
                ),
                icon: Icon(
                  Icons.wallet,
                  color: Color.fromRGBO(208, 208, 208, 1),
                ),
                label: 'Wallet',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.ac_unit_rounded,
                  color: Color.fromRGBO(35, 170, 73, 1),
                ),
                icon: Icon(
                  Icons.ac_unit_rounded,
                  color: Color.fromRGBO(208, 208, 208, 1),
                ),
                label: 'Mini Hive',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.person,
                  color: Color.fromRGBO(35, 170, 73, 1),
                ),
                icon: Icon(
                  Icons.person,
                  color: Color.fromRGBO(208, 208, 208, 1),
                ),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            // selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,
          ),
        ),
      ],
    );
  }
}
