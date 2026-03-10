import 'package:ezcape/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        context.go('/authGate');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Stack(
        children: [
          SvgPicture.asset('assets/icons/Vector.svg'),
          SvgPicture.asset('assets/icons/Vector2.svg'),
          Align(
              alignment: Alignment.bottomRight,
              child: SvgPicture.asset('assets/icons/Vector3.svg')),
          Align(
              alignment: Alignment.bottomRight,
              child: SvgPicture.asset('assets/icons/Vector4.svg')),
          Center(child: SvgPicture.asset('assets/icons/Ezcape.svg')),
          Padding(
            padding: EdgeInsets.only(bottom: 60.h),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Text('The best place to find fun escapades',
                    style: TextStyle(
                        fontFamily: 'ZTTalk',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600))),
          ),
        ],
      ),
    );
  }
}
