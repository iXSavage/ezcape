import 'package:ezcape/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChooseInterest extends StatefulWidget {
  const ChooseInterest({super.key});

  @override
  State<ChooseInterest> createState() => _ChooseInterestState();
}

class _ChooseInterestState extends State<ChooseInterest> {
  final List<String> interestsselectedItems = [];
  final List<String> sportsselectedItems = [];
  final List<String> interests = ['Swimming', 'Adventure', 'Video Games', 'Hiking', 'EA SPORTS FC 24'];
  final List<String> sports = ['Swimming', 'Adventure', 'Video Games', 'Hiking', 'EA SPORTS FC 24'];
  bool isLoading = false;

  void save() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      return;
    }

    final email = user.email;
    final interests = interestsselectedItems.toList();
    final sports = sportsselectedItems.toList();

    if (interests.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose an interest')),
      );
      return;
    }

    if (sports.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose a sport')),
      );
      return;
    }

    // Show loading indicator first
    setState(() {
      isLoading = true; // Add this boolean to your state variables
    });

    try {
      final response = await supabase
          .from('user_interests')
          .upsert({
        'email': email,
        'interests': interests,
        'sports': sports,
      });

      context.go('/bioPage');
      // Show loading indicator first
      setState(() {
        isLoading = false; // Add this boolean to your state variables
      });
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20.h, bottom: 12.h),
                    child: Text('What are you into?', style: onboardingHeading,),
                  ),

                  Text('Pick up to 5 interests or sports you enjoy that you want to show on your profile.', style: onboardingBody,),

                  Padding(
                    padding: EdgeInsets.only(top: 32.h, bottom: 32.h),
                    child: _interestChipSection('Interests', interests),
                  ),

                  _sportsChipSection('Sports', sports),

                ],
              ),
            ),

            Column(
              children: [
                const Divider(),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: ElevatedButton(
                      onPressed: isLoading ? null : save, // Can be null, making it optional
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
                      child: isLoading ?
                      const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2.0,
                        ),
                      ) : const Text('Save')
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _interestChipSection(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          children: options.map((option) {
            return FilterChip(
              label: Text(option),
              selected: interestsselectedItems.contains(option),
              onSelected: (bool isSelected) {
                setState(() {
                  if (isSelected) {
                    if (interestsselectedItems.length < 3) {
                      interestsselectedItems.add(option);
                    }
                  } else {
                    interestsselectedItems.remove(option);
                  }
                });
              },
              backgroundColor: chipColor,
              selectedColor: Colors.grey.shade400,
              checkmarkColor: Colors.black,
              labelStyle: TextStyle(
                color: interestsselectedItems.contains(option) ? Colors.black : Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 14.sp
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r)
              )
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _sportsChipSection(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.sp
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          children: options.map((option) {
            return FilterChip(
                label: Text(option),
                selected: sportsselectedItems.contains(option),
                onSelected: (bool isSelected) {
                  setState(() {
                    if (isSelected) {
                      if (sportsselectedItems.length < 3) {
                        sportsselectedItems.add(option);
                      }
                    } else {
                      sportsselectedItems.remove(option);
                    }
                  });
                },
                backgroundColor: chipColor,
                selectedColor: Colors.grey.shade400,
                checkmarkColor: Colors.black,
                labelStyle: TextStyle(
                    color: sportsselectedItems.contains(option) ? Colors.black : Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r)
                )
            );
          }).toList(),
        ),
      ],
    );
  }
}

