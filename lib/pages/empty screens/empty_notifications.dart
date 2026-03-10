import 'package:ezcape/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyNotifications extends StatefulWidget {
  const EmptyNotifications({super.key});

  @override
  State<EmptyNotifications> createState() => _EmptyNotificationsState();
}

class _EmptyNotificationsState extends State<EmptyNotifications> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 48.r,
        leading: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: SvgPicture.asset('assets/icons/bell_notification.svg'),
        ),
        title: Text('Notifications', style: size24Weight600,),
        centerTitle: false,
        actions: [
          IconButton(onPressed: (){},
            icon: SvgPicture.asset('assets/icons/settings.svg'))
        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: 136.w,
                height: 136.h,
                child: Image.asset('assets/images/beachdrink.png')),

            Text('No notifications yet', style: size24Weight600,),

            Padding(
              padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
              child: SizedBox(
                width: 223.w,
                child: Text('When you have a notification, you will find it here',
                  textAlign: TextAlign.center,
                  style: size14Weight500,
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
