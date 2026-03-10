import 'dart:convert';
import 'package:ezcape/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {

  Future<List<Map<String, dynamic>>> fetchBio() async{
  try {
  // Using the newer Supabase SDK syntax
  final response = await supabase
      .from('user_interests')
      .select();

  // Convert the response to the expected format
  return List<Map<String, dynamic>>.from(response);
  } catch (error) {
  // Re-throw to be caught by the FutureBuilder
  rethrow;
  }
}

  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
      context.pop();
      context.go('/walkthrough');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signed out successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign out unsuccessful'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(future: fetchBio(),
        builder: (context, snapshot){
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle error state
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Handle empty data
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No escapades found'));
          }

          final biography = snapshot.data!;

          final rawInterests = biography[0]['interests'];

          //Convert the interests to a list of strings we can use
          List<String> interests = [];

          if (rawInterests is String){
            //make sure it is converted to a list
            interests = List<String>.from(jsonDecode(rawInterests));
          } else
            if (rawInterests is List){
              //make sure all the items in the list are treated as a string
              interests = rawInterests.cast<String>();
            }


          return CustomScrollView(
            slivers: [
              SliverAppBar(
                  centerTitle: true,
                  pinned: true,
                  floating: false,
                  stretch: false,
                  expandedHeight: 250.h,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(child: Image.network(biography[0]['image'], fit: BoxFit.cover,)),

                      Positioned(
                        top: 50.h, right: 16.w,
                        child: IconButton(
                          onPressed: (){
                            showDialog(context: context, builder: (context){
                              return AlertDialog(
                                content: const Text('Are you sure you want to log out?'),
                                actions: [
                                  TextButton(onPressed: (){
                                    context.pop();
                                  }, child: const Text('No')),
                                  TextButton(onPressed: signOut, child: const Text('Yes')),
                                ],
                              );
                            });
                          },
                          icon: const Icon(Icons.logout),
                          color: Colors.white,
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
                  padding:  EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(biography[0]['profile_name'], style: size20Weight600,),

                              SizedBox(width: 8.w,),

                              CircleAvatar(
                                radius: 10.r,
                                backgroundColor: Colors.black87,
                                child: Text(biography[0]['gender'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.sp,
                                      color: Colors.white
                                  ),
                                ),
                              )
                            ],
                          ),

                          ElevatedButton(onPressed: (){
                            showDialog(context: context, builder: (context){
                              return AlertDialog(
                                content: Text('Are you sure you want to proceed? You cannot go back once started till you are done',
                                  style: size14Weight500,
                                ),
                                actions: [
                                  TextButton(onPressed: (){
                                    context.pop();
                                  }, child: const Text('No')),
                                  TextButton(onPressed: (){
                                    context.go('/chooseInterest');
                                  }, child: const Text('Proceed'))
                                ],
                              );
                            });
                          },
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: chipColor,
                                textStyle: size12Weight600,
                                minimumSize: Size(77.w, 28.h),
                                padding: EdgeInsets.zero,
                                side: const BorderSide(color: Colors.black)
                            ),
                            child: const Text('Edit profile'),
                          )
                        ],
                      ),

                      Row(
                        children: [
                          SvgPicture.asset('assets/icons/location.svg', width: 10.w, height: 14.h,),

                          SizedBox(width: 8.w,),

                          Text(biography[0]['location'], style: size14Weight500,)
                        ],
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 16.h, bottom: 24.h),
                        child: Text(biography[0]['bio'],
                          style: size16Weight500,
                        ),
                      ),

                      Text('Interests', style: size16Weight500,),

                      Padding(
                        padding: EdgeInsets.only(top: 12.h, bottom: 24.h),
                        child: interestSection(interests),
                      ),

                      totalEscapades(),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: myFollowers(),
                      ),

                      myFollowing(),

                      SizedBox(height: 12.h,),

                      accountSettings(),

                      inviteFriends(),

                      helpAndSupport(),

                      aboutEzcape()

                    ],
                  ),
                ),
              )
            ],
          );
        }
      )
    );
  }

  Widget interestSection (List<String> interests){
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: interests.map((interest) {
        return Container(
            padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 12.w),
            decoration: BoxDecoration(
                color: chipColor,
                borderRadius: BorderRadius.circular(24.r)
            ),
            child: Text(interest, style: size14Weight500,),
          );
      }
      ).toList(),
    );
  }
}
