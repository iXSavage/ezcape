import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class BucketList extends StatelessWidget {
  const BucketList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/shivendu-shukla-3yoTPuYR9ZY-unsplash.jpg',),
          fit: BoxFit.fill
      )
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text('Page Construction Ongoing',
          style: TextStyle(
            fontSize: 26.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white
          ),
        ),
      ),
    );
  }
}
