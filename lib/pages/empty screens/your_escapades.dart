import 'package:ezcape/constants.dart';
import 'package:ezcape/pages/navigation/joined_escapades.dart';
import 'package:ezcape/pages/navigation/created_by_you.dart';
import 'package:ezcape/pages/empty%20screens/empty_bookmark.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class YourEscapades extends StatefulWidget {
  const YourEscapades({super.key});

  @override
  State<YourEscapades> createState() => _YourEscapadesState();
}

class _YourEscapadesState extends State<YourEscapades> {
  final int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: _currentIndex,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.only(
              left: 20.w,
            ),
            child: SvgPicture.asset(
              'assets/icons/doublestaricon.svg',
            ),
          ),
          title: Text(
            'Escapades',
            style: size24Weight600,
          ),
          centerTitle: false,
          bottom: TabBar(
            tabs: [
              Text(
                'Created by you',
                style: size16Weight600,
              ),
              Text(
                'Bookmark',
                style: size16Weight600,
              ),
              Text(
                'Joined',
                style: size16Weight600,
              )
            ],
            indicatorColor: buttonForegroundColor,
            labelColor: Colors.black87,
          ),
        ),
        body: TabBarView(children: [
          CreatedByYou(),
          const EmptyBookmark(),
          const JoinedEscapades(),
        ]),
      ),
    );
  }
}
