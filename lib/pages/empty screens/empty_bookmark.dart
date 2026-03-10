import 'package:ezcape/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyBookmark extends StatefulWidget {
  const EmptyBookmark({super.key});

  @override
  State<EmptyBookmark> createState() => _EmptyBookmarkState();
}

class _EmptyBookmarkState extends State<EmptyBookmark> {



  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Feature coming soon', style: size24Weight600,),

        Padding(
          padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
          child: SizedBox(
            width: 271.w,
            child: Text('This feature is coming soon, enable notifications to get alerted when it is live!',
              textAlign: TextAlign.center,
              style: size14Weight500,
            ),
          ),
        ),

        ElevatedButton(onPressed: (){},
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
            minimumSize: Size(160.w, 42.h),
            textStyle: size14Weight600
          ),
          child: const Text('Enable notifications'),
        )
      ],
    );
  }
}
