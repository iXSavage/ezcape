import 'package:ezcape/pages/empty%20screens/your_escapades.dart';
import 'package:ezcape/pages/navigation/account.dart';
import 'package:ezcape/pages/navigation/home.dart';
import 'package:ezcape/pages/navigation/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _currentIndex = 0;
  List pages = [
    const Home(),
    const YourEscapades(),
    const Notifications(),
    const Account()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          selectedItemColor: Colors.black,
          onTap: (index){
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: _currentIndex == 0 ?
              SvgPicture.asset('assets/icons/suggestion_solid.svg') : SvgPicture.asset('assets/icons/suggestion.svg') ,
              label: 'suggestion',),
            BottomNavigationBarItem(
                icon: _currentIndex == 1 ?
                SvgPicture.asset('assets/icons/escapades_solid.svg') : SvgPicture.asset('assets/icons/escapades.svg'),
                label: 'escapades'),
            BottomNavigationBarItem(
                icon: _currentIndex == 2 ?
                SvgPicture.asset('assets/icons/bell_solid.svg') : SvgPicture.asset('assets/icons/bell.svg'),
                label: 'bell'),
            BottomNavigationBarItem(
                icon: _currentIndex == 3 ?
                SvgPicture.asset('assets/icons/user_solid.svg') : SvgPicture.asset('assets/icons/user.svg'),
                label: 'user')
          ]
      ),
    );
  }
}
