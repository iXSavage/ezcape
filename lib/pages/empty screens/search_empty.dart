import 'package:ezcape/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchEmpty extends StatelessWidget {
  const SearchEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: TextField(
                onTapOutside: (event){
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: fillColor,
                  prefixIcon: IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/secondbackbutton.svg',
                      height: 18.h,
                      width: 18.w,
                    ),
                    onPressed: () {
                      // Handle button click
                    },
                  ),
                  suffixIcon: IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/cancel.svg',
                      height: 32.h,
                      width: 32.w,
                    ),
                    onPressed: () {
                      // Handle button click
                    },
                  ),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(color: fillColor),
                      borderRadius: BorderRadius.circular(40.r)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: fillColor),
                    borderRadius: BorderRadius.circular(40.r)
                  ),
                ),
              ),
            ),

            const Divider(),
            
            Padding(
              padding: EdgeInsets.only(top: 199.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 136.w,
                      height: 136.h,
                      child: Image.asset('assets/images/beachdrink.png')),

                  Text('Escapade not found', style: size24Weight600,),

                  SizedBox(height: 8.h,),

                  SizedBox(
                    width: 271.w,
                    child: Text('The escapade doesn’t exist or has been removed. Check your search term to make sure you entered the right term.',
                      textAlign: TextAlign.center,
                      style: size14Weight500,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
