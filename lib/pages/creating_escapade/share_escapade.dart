import 'package:ezcape/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ShareEscapade extends StatelessWidget {
  final Map<String, dynamic> escapade;
  const ShareEscapade({super.key, required this.escapade,});

  @override
  Widget build(BuildContext context) {

    void goToEscapade(){
      context.push('/escapade', extra: escapade);
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Text('Invite friends', style: onboardingHeading,),
              ),

              Text('Paintball Battle is better with friends. Invite your friends to join you on this escapade.', style: onboardingBody,),

              Padding(
                padding: EdgeInsets.only(top: 32.h, bottom: 24.h),
                child: ElevatedButton(onPressed: (){},
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 68.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      side: const BorderSide(
                        color: chipColor
                      )
                    ),
                    backgroundColor: Colors.white
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Share via...', style: onboardingBody,),

                      SvgPicture.asset('assets/icons/share.svg')
                    ],
                  ),
                ),
              ),

              ElevatedButton(onPressed: (){},
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 68.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        side: const BorderSide(
                            color: chipColor
                        )
                    ),
                    backgroundColor: Colors.white
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Copy invite link', style: onboardingBody,),

                    SvgPicture.asset('assets/icons/copy.svg')
                  ],
                ),
              ),

              const Spacer(),

              CustomButton(buttonText: 'Go to escapade', onPressed:goToEscapade,)
            ],
          ),
        ),
      ),
    );

  }
}
