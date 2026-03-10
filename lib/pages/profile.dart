import 'package:ezcape/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
              centerTitle: true,
              pinned: true,
              floating: false,
              stretch: false,
              expandedHeight: 250.h,
              flexibleSpace: Stack(
                children: [
                  Positioned.fill(child: Image.asset('assets/images/profile_image.png', fit: BoxFit.cover,)),

                  Positioned(
                    top: 50.h, left: 16.w,
                    child: IconButton(
                      onPressed: (){},
                      icon: SvgPicture.asset('assets/icons/backbutton.svg', colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black87,
                      ),
                    ),
                  )
                ],
              )
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('Czar', style: size20Weight600,),

                          SizedBox(width: 8.w,),

                          CircleAvatar(
                            radius: 10.r,
                            backgroundColor: Colors.black87,
                            child: Text('M',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                  color: Colors.white
                              ),
                            ),
                          )
                        ],
                      ),

                      followButton()
                    ],
                  ),

                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/location.svg', width: 10.w, height: 14.h,),

                      SizedBox(width: 8.w,),

                      Text('12 Kingsway Road, Ikoyi', style: size14Weight500,)
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 12.h, bottom: 20.h),
                    child: Text("I love making a splash in the pool and dominating gaming marathons. When I'm not swimming laps or leveling up, I craft mobile apps. Let's swim, play, and create awesome memories together!",
                      style: size16Weight500,
                    ),
                  ),

                  Text('Interests', style: size16Weight500,),

                  Padding(
                    padding: EdgeInsets.only(top: 12.h, bottom: 24.h),
                    child: interestSection(),
                  ),

                  totalEscapades(),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: myFollowers(),
                  ),

                  myFollowing(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
