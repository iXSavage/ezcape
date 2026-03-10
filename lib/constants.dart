import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


final List<String> interests = ['Swimming', 'Adventure', 'EA SPORTS FC 24', 'Video Games', 'Hiking'];
final List followers = [
  {'image': 'assets/images/Ellipse 1.png', 'name': 'Joeburg', 'location': '12 Kingsway Road, Ikoyi', 'status': 'Follow'},
  {'image': 'assets/images/Ellipse 2.png', 'name': 'Joeburg', 'location': '12 Kingsway Road, Ikoyi', 'status': 'Unfollow'},
  {'image': 'assets/images/Ellipse 3.png', 'name': 'Joeburg', 'location': '12 Kingsway Road, Ikoyi', 'status': 'Follow'},
  {'image': 'assets/images/Ellipse 4.png', 'name': 'Joeburg', 'location': '12 Kingsway Road, Ikoyi', 'status': 'Follow'},
  {'image': 'assets/images/Ellipse 5.png', 'name': 'Joeburg', 'location': '12 Kingsway Road, Ikoyi', 'status': 'Follow'},{'image': 'assets/images/Ellipse 1.png', 'name': 'Joeburg', 'location': '12 Kingsway Road, Ikoyi', 'status': 'Follow'},
  {'image': 'assets/images/Ellipse 2.png', 'name': 'Joeburg', 'location': '12 Kingsway Road, Ikoyi', 'status': 'Unfollow'},
  {'image': 'assets/images/Ellipse 3.png', 'name': 'Joeburg', 'location': '12 Kingsway Road, Ikoyi', 'status': 'Unfollow'},
  {'image': 'assets/images/Ellipse 4.png', 'name': 'Joeburg', 'location': '12 Kingsway Road, Ikoyi', 'status': 'Follow'},
  {'image': 'assets/images/Ellipse 5.png', 'name': 'Joeburg', 'location': '12 Kingsway Road, Ikoyi', 'status': 'Unfollow'},{'image': 'assets/images/Ellipse 1.png', 'name': 'Joeburg', 'location': '12 Kingsway Road, Ikoyi', 'status': 'Follow'},
  {'image': 'assets/images/Ellipse 2.png', 'name': 'Joeburg', 'location': '12 Kingsway Road, Ikoyi', 'status': 'Unfollow'},
  {'image': 'assets/images/Ellipse 3.png', 'name': 'Joeburg', 'location': '12 Kingsway Road, Ikoyi', 'status': 'Follow'},
  {'image': 'assets/images/Ellipse 4.png', 'name': 'Joeburg', 'location': '12 Kingsway Road, Ikoyi', 'status': 'Unfollow'},
  {'image': 'assets/images/Ellipse 5.png', 'name': 'Joeburg', 'location': '12 Kingsway Road, Ikoyi', 'status': 'Follow'},
];
final supabase = Supabase.instance.client;


const Color primaryColor = Color(0xFF90D956);
const Color hintTextColor = Color(0xFF888888);
const Color fillColor = Color(0xFFF9F9F9);
const Color borderRadiusColor = Color(0xFFEBEBEB);
const Color buttonForegroundColor = Color(0xFF101415);
const Color text1Color = Color(0xFF4A4A4A);
const Color chipColor = Color(0xFFEBECF2);




TextStyle onboardingBody = TextStyle(
  fontSize: 16.sp,
  fontFamily: 'ZTTalk',
  fontWeight: FontWeight.w500,
  color: text1Color
);

TextStyle onboardingBody2 = TextStyle(
    fontSize: 16.sp,
    fontFamily: 'ZTTalk',
    fontWeight: FontWeight.w500,
    color: const Color(0xFF101415)
);

TextStyle onboardingHeading = TextStyle(
    fontSize: 32.sp,
    fontFamily: 'ZTTalk',
    fontWeight: FontWeight.w600,
    color: const Color(0xFF101415)
);

TextStyle size24Weight600 = TextStyle(
    fontSize: 24.sp,
    fontFamily: 'ZTTalk',
    fontWeight: FontWeight.w600,
);

TextStyle size14Weight500 = TextStyle(
    fontSize: 14.sp,
    fontFamily: 'ZTTalk',
    fontWeight: FontWeight.w500,
);

TextStyle size14Weight600 = TextStyle(
    fontSize: 14.sp,
    fontFamily: 'ZTTalk',
    fontWeight: FontWeight.w600,
);

TextStyle size16Weight600 = TextStyle(
    fontSize: 16.sp,
    fontFamily: 'ZTTalk',
    fontWeight: FontWeight.w600,
);

TextStyle size20Weight600 = TextStyle(
    fontSize: 20.sp,
    fontFamily: 'ZTTalk',
    fontWeight: FontWeight.w600,
);

TextStyle size12Weight600 = TextStyle(
    fontSize: 12.sp,
    fontFamily: 'ZTTalk',
    fontWeight: FontWeight.w600,
);

TextStyle size18Weight600 = TextStyle(
    fontSize: 18.sp,
    fontFamily: 'ZTTalk',
    fontWeight: FontWeight.w600,
);

TextStyle size16Weight500 = TextStyle(
    fontSize: 16.sp,
    fontFamily: 'ZTTalk',
    fontWeight: FontWeight.w500,
);

TextStyle size14Weight700 = TextStyle(
    fontSize: 14.sp,
    fontFamily: 'ZTTalk',
    fontWeight: FontWeight.w700,
);

TextStyle size10Weight700 = TextStyle(
    fontSize: 10.sp,
    fontFamily: 'ZTTalk',
    fontWeight: FontWeight.w700,
);


class CustomButton extends StatelessWidget{
  final String buttonText;
  final VoidCallback? onPressed; // Nullable onPressed function

  const CustomButton({
    super.key,
    required this.buttonText,
    this.onPressed, // Default value is null
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, // Can be null, making it optional
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18.sp,
          fontFamily: 'ZTTalk',
        ),
        foregroundColor: buttonForegroundColor,
        backgroundColor: primaryColor,
        minimumSize: Size(double.infinity, 60.h),
      ),
      child: Text(buttonText),
    );
  }
}

Widget interestSection (){
  return Wrap(
    spacing: 8.w,
    runSpacing: 8.h,
    children: interests.map((interest) =>
        Container(
          padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 12.w),
          decoration: BoxDecoration(
              color: chipColor,
              borderRadius: BorderRadius.circular(24.r)
          ),
          child: Text(interest, style: size14Weight500,),
        )
    ).toList(),
  );
}

Widget totalEscapades (){
  return GestureDetector(
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      height: 56.h,
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12.r)
      ),
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/streak.svg', colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),),

          SizedBox(width: 8.w,),

          Text('Total escapades',
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white
            ),
          ),

          const Spacer(),

          Text('12',
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white
            ),
          )
        ],
      ),
    ),
  );
}

Widget myFollowers (){
  return Builder(
    builder: (context){
      return GestureDetector(
        onTap: (){
          showModalBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              useSafeArea: true,
              isScrollControlled: true,
              showDragHandle: true,
              builder: (BuildContext context){
                return SizedBox(
                    height: 784.h,
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          TextField(
                            onTapOutside: (event){
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFF5F5F5),
                              prefixIcon: IconButton(
                                icon: SvgPicture.asset(
                                  'assets/icons/search.svg',
                                  height: 18.h,
                                  width: 18.w,
                                ),
                                onPressed: () {
                                  // Handle button click
                                },
                              ),
                              hintText: 'Search followers',
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

                          Expanded(child: followersTile())

                        ],
                      ),
                    )
                );
              });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          height: 56.h,
          decoration: BoxDecoration(
              color: chipColor,
              borderRadius: BorderRadius.circular(12.r)
          ),
          child: Row(
            children: [
              SvgPicture.asset('assets/icons/followers.svg',),

              SizedBox(width: 8.w,),

              Text('Followers (58)', style: size16Weight600,),

              const Spacer(),

              SvgPicture.asset('assets/icons/arrow_down.svg')
            ],
          ),
        ),
      );
    },
  );
}

Widget myFollowing (){
  return Builder(builder: (context){
    return GestureDetector(
      onTap: (){
        showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white,
            useSafeArea: true,
            isScrollControlled: true,
            showDragHandle: true,
            builder: (BuildContext context){
              return SizedBox(
                  height: 784.h,
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        TextField(
                          onTapOutside: (event){
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFF5F5F5),
                            prefixIcon: IconButton(
                              icon: SvgPicture.asset(
                                'assets/icons/search.svg',
                                height: 18.h,
                                width: 18.w,
                              ),
                              onPressed: () {
                                // Handle button click
                              },
                            ),
                            hintText: 'Search followings',
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

                        Expanded(child: followingsTile())

                      ],
                    ),
                  )
              );
            });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        height: 56.h,
        decoration: BoxDecoration(
            color: chipColor,
            borderRadius: BorderRadius.circular(12.r)
        ),
        child: Row(
          children: [
            SvgPicture.asset('assets/icons/following.svg',),

            SizedBox(width: 8.w,),

            Text('Following (62)', style: size16Weight600,),

            const Spacer(),

            SvgPicture.asset('assets/icons/arrow_down.svg')
          ],
        ),
      ),
    );
  });
}

Widget accountSettings(){
  return GestureDetector(
    child: SizedBox(
      height: 56.h,
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/settings.svg'),

          SizedBox(width: 16.w,),

          Text('Account settings', style: size18Weight600,),

          const Spacer(),

          SvgPicture.asset('assets/icons/arrow_right.svg'),
        ],
      ),
    ),
  );
}

Widget inviteFriends(){
  return GestureDetector(
    child: SizedBox(
      height: 56.h,
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/user_plus.svg'),

          SizedBox(width: 16.w,),

          Text('Invite friends', style: size18Weight600,),

          const Spacer(),

          SvgPicture.asset('assets/icons/arrow_right.svg'),
        ],
      ),
    ),
  );
}

Widget helpAndSupport(){
  return GestureDetector(
    child: SizedBox(
      height: 56.h,
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/headset_help.svg'),

          SizedBox(width: 16.w,),

          Text('Help & Support', style: size18Weight600,),

          const Spacer(),

          SvgPicture.asset('assets/icons/arrow_right.svg'),
        ],
      ),
    ),
  );
}

Widget aboutEzcape(){
  return GestureDetector(
    child: SizedBox(
      height: 56.h,
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/info.svg'),

          SizedBox(width: 16.w,),

          Text('About Ezcape', style: size18Weight600,),

          const Spacer(),

          SvgPicture.asset('assets/icons/arrow_right.svg'),
        ],
      ),
    ),
  );
}

Widget followersTile(){
  return ListView.builder(
      itemCount: followers.length,
      itemBuilder: (context, index){
        return Padding(
          padding: EdgeInsets.only(top: 24.h),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(followers[index]['image']),
                radius: 24.r,
              ),

              SizedBox(width: 12.w,),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(followers[index]['name'], style: size16Weight600,),

                  Text(followers[index]['location'], style: size14Weight500,),
                ],
              ),

              const Spacer(),

              if (followers[index]['status'] == 'Follow')
                followButton() else
                unfollowButton()
            ],
          ),
        );
      });
}

Widget followingsTile(){
  return ListView.builder(
      itemCount: followers.length,
      itemBuilder: (context, index){
        return Padding(
          padding: EdgeInsets.only(top: 24.h),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(followers[index]['image']),
                radius: 24.r,
              ),

              SizedBox(width: 12.w,),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(followers[index]['name'], style: size16Weight600,),

                  Text(followers[index]['location'], style: size14Weight500,),
                ],
              ),

              const Spacer(),

              if (followers[index]['status'] == 'Follow')
                followButton() else
                unfollowButton()
            ],
          ),
        );
      });
}

Widget followButton(){
  return ElevatedButton(onPressed: (){},
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.zero,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      minimumSize: Size(55.w, 28.h),

    ),
    child: Text('Follow', style: size12Weight600,),
  );
}

class BookmarkButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const BookmarkButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(onPressed: onPressed,
      icon: SvgPicture.asset('assets/icons/bookmark.svg'),
      label: Text('Bookmark', style: size12Weight600,),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        minimumSize: Size(91.w, 28.h),

      ),
    );
  }
}

Widget unfollowButton(){
  return ElevatedButton(onPressed: (){},
    style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: chipColor,
        foregroundColor: Colors.black,
        minimumSize: Size(67.w, 28.h),
        side: const BorderSide(
            color: Colors.black
        )
    ),
    child: const Text('Unfollow'),
  );
}

