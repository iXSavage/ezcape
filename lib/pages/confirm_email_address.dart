import 'package:ezcape/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfirmEmailAddress extends StatelessWidget {
  const ConfirmEmailAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset('assets/icons/backbutton.svg'),
        
              Padding(
                padding: EdgeInsets.only(top: 16.h, bottom: 12.h),
                child: Text('Verify your email', style: onboardingHeading,),
              ),
              
              Text('Enter the code we sent to your email czar@gmail.com', style: onboardingBody,),

              Padding(
                padding: EdgeInsets.only(top: 32.h, bottom: 16.h),
                child: TextFormField(
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: fillColor,
                      hintText: 'Code',
                      hintStyle: TextStyle(
                          color: hintTextColor
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: borderRadiusColor)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: borderRadiusColor)
                      )
                  ),
                ),
              ),
              
              Text('Resend code', style: onboardingBody2,),

              SizedBox(height: 438.h,),
              
              const CustomButton(buttonText: 'Verify email'),
              
            ],
          ),
        ),
      ),
    );
  }
}
