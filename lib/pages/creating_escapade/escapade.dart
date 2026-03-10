import 'package:ezcape/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class Escapade extends StatefulWidget {
  final Map<String, dynamic> escapade;

  const Escapade({super.key, required this.escapade,});

  @override
  State<Escapade> createState() => _EscapadeState();
}

class _EscapadeState extends State<Escapade> {

  void startEscapade() async {
    try {
      final response = await supabase
          .from('escapade_notifications')
          .upsert({
        'email': widget.escapade['email'],
        'profile_image': widget.escapade['created_by'],
        'escapade_name': widget.escapade['name'],
        'profile_name': widget.escapade['profile_name']
      })
          .select()
          .single();

      if (response.isNotEmpty){
        context.go('/customBottomNavigationBar');
      } else {
      }

    } catch (e) {
      // Continue - we can still remove by email
    }
  }

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
                      decoration: BoxDecoration(
                        image: DecorationImage(image: NetworkImage(widget.escapade['image_url']), fit: BoxFit.fill
                        )
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 44.h, left: 12.w, right: 12.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(onPressed: (){
                                  context.pop();
                                },
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

                            Padding(
                              padding: EdgeInsets.only(bottom: 16.5.h),
                              child: Container(
                                height: 23.h,
                                width: 58.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4.r)
                                ),
                                child: Center(child: Text(widget.escapade['category'])),
                              ),
                            ),
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
                                Text(widget.escapade['name'], style: size20Weight600,),

                                // ElevatedButton.icon(onPressed: (){},
                                //   label: Text('Edit', style: size12Weight600,),
                                //   icon: Icon(Icons.edit_outlined, size: 14.r,),
                                //   style: ElevatedButton.styleFrom(
                                //       minimumSize: Size(61.w, 28.h),
                                //       backgroundColor: chipColor,
                                //       foregroundColor: Colors.black,
                                //       side: BorderSide(color: Colors.black),
                                //       shape: RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.circular(24.r),
                                //       )
                                //   ),
                                // )

                              ],
                            ),
                          ),

                          Row(
                            children: [
                              SvgPicture.asset('assets/icons/location.svg', width: 10.w, height: 14.h,),

                              SizedBox(width: 8.w,),

                              Text(widget.escapade['where'], style: size14Weight500,)
                            ],
                          ),

                          Padding(
                          padding: EdgeInsets.only(top: 10.h, bottom: 15.h),
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/icons/calendar.svg', width: 10.w, height: 14.h,),

                              SizedBox(width: 8.w,),

                              Text(widget.escapade['when'], style: size14Weight500,)
                            ],
                          ),
                        ),

                          Text(widget.escapade['description'],
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

                                    Text(widget.escapade['profile_name'], style: size16Weight600,)
                                  ],
                                ),

                                const Spacer(),
                              ],
                            ),
                          ),

                          Text('Rules', style: size16Weight500),

                          Text('▪️ ${widget.escapade['rules']}', style: size16Weight500,),

                          SizedBox(height: 12.h,),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w),
              child: TextButton.icon(onPressed: startEscapade,
                label: Text('Start escapade', style: size18Weight600,),
                icon: Icon(Icons.play_arrow, size: 18.r,),
                style: TextButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 60.h)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
