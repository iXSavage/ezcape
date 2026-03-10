import 'package:ezcape/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JoinedEscapades extends StatelessWidget {
  const JoinedEscapades({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        left: false,
        right: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Container(
                      height: 275.h,
                      decoration: const BoxDecoration(
                          image: DecorationImage(image: AssetImage('assets/images/paintball_image.png'), fit: BoxFit.fill
                          )
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 44.h, left: 12.w, right: 12.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(onPressed: (){},
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.black,
                                ),
                                icon: SvgPicture.asset('assets/icons/backbutton.svg', colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn))),

                            IconButton(onPressed: (){},
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black,
                              ),
                              icon: SvgPicture.asset('assets/icons/share.svg', colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),),
                            )
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 8.h, top: 10.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Paintball Battle Royale', style: size20Weight600,),

                                // bookmarkButton(),

                              ],
                            ),
                          ),

                          Row(
                            children: [
                              SvgPicture.asset('assets/icons/location.svg', width: 10.w, height: 14.h,),

                              SizedBox(width: 8.w,),

                              Text('12 Kingsway Road, Ikoyi', style: size14Weight500,)
                            ],
                          ),

                          Padding(
                            padding: EdgeInsets.only(top: 10.h, bottom: 15.h),
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/icons/calendar.svg', width: 10.w, height: 14.h,),

                                SizedBox(width: 8.w,),

                                Text('Friday, August 09, 2024 at 10:00 AM', style: size14Weight500,)
                              ],
                            ),
                          ),

                          Text("I love making a splash in the pool and dominating gaming marathons. When I'm not swimming laps or leveling up, I craft mobile apps. Let's swim, play, and create awesome memories together!",
                            style: size16Weight500,
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: const AssetImage('assets/images/profile_image.png'),
                                  radius: 20.r,
                                ),

                                SizedBox(width: 10.w),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Created by', style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: text1Color
                                    ),),

                                    Text('Czar', style: size16Weight600,)
                                  ],
                                ),

                                const Spacer(),

                                SizedBox(
                                  width: 120.w,
                                  child: Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 20.r,
                                        backgroundImage: const AssetImage('assets/images/Ellipse 1.png'),
                                      ),

                                      Positioned(
                                        left: 25.w,
                                        child: CircleAvatar(
                                          radius: 20.r,
                                          backgroundImage: const AssetImage('assets/images/Ellipse 2.png'),
                                        ),
                                      ),

                                      Positioned(
                                        left: 50.w,
                                        child: CircleAvatar(
                                          radius: 20.r,
                                          backgroundImage: const AssetImage('assets/images/Ellipse 3.png'),
                                        ),
                                      ),

                                      Positioned(
                                        left: 75.w,
                                        child: CircleAvatar(
                                          radius: 20.r,
                                          backgroundColor: chipColor,
                                          child: Text('+25', style: size14Weight700,),
                                        ),
                                      ),


                                      // CircleAvatar(
                                      //   backgroundColor: Colors.black,
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Text('Rules', style: size16Weight500,),

                          SizedBox(height: 12.h,),

                          Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('▪️'),
                                Expanded(
                                    child: Text('All players must wear approved safety gear, including masks and protective clothing.',
                                      style: size16Weight500,
                                    )
                                )
                              ],
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('▪️'),
                                Expanded(
                                    child: Text('No removal of masks during gameplay within the field.',
                                      style: size16Weight500,
                                    )
                                )
                              ],
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('▪️'),
                                Expanded(
                                    child: Text('A player is eliminated when hit by a paintball that breaks on their body, gear, or marker.',
                                      style: size16Weight500,
                                    )
                                )
                              ],
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('▪️'),
                                Expanded(
                                    child: Text('Upon elimination, players must raise their hand, shout "Hit!" and exit the field immediately.',
                                      style: size16Weight500,
                                    )
                                )
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(
              color: chipColor,
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const CustomButton(buttonText: 'Leave escapade'),
            )
          ],
        ),
      ),
    );
  }
}
