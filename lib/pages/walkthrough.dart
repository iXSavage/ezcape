import 'package:ezcape/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class Walkthrough extends StatelessWidget {
  const Walkthrough({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/walkthrough-image.png'), fit: BoxFit.cover),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black
                    ],
                    stops: [0.1, 0.6]
                  )
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 464.h),
                  child: Column(
                    children: [
                      Text('EZCAPE YOUR HOUSE AND GO HAVE SOME FUN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0,
                        fontSize: 34.sp,
                        color: Colors.white,
                        fontFamily: 'ZTTALK'
                      ),
                      ),

                      Text('Ezcape your house by finding and participating in fun activities and sports all around you',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: Colors.white
                      ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 56.h, bottom: 29.h),
                        child: CustomButton(buttonText: 'Sign Up', onPressed: (){
                          context.push('/signUp');
                        },),
                      ),

                      ElevatedButton(
                        onPressed: (){
                          context.push('/signIn');
                        },
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                            fontFamily: 'ZTTalk',
                          ),
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                          minimumSize: Size(double.infinity, 60.h),
                        ),
                        child: Text('Sign in instead'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

          //Image.asset('assets/images/walkthrough-image.png', fit: BoxFit.cover,)
        ],
      ),
    );
  }
  Widget signInTextButton(){
      return TextButton(onPressed: (){},
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          textStyle: size18Weight600,
        ),
        child: const Text('Sign in instead'),
      );
  }

}
