import 'dart:convert';
import 'dart:math' as math;
import 'package:ezcape/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class JoinedEscapades extends StatefulWidget {
  const JoinedEscapades({super.key});

  @override
  State<JoinedEscapades> createState() => _JoinedEscapadesState();
}

class _JoinedEscapadesState extends State<JoinedEscapades> {
  final supabase = Supabase.instance.client;

  // Add a key to refresh the FutureBuilder
  Key _futureKey = UniqueKey();

  Future<List<Map<String, dynamic>>> fetchEscapades() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        return [];
      }

      // For joined escapades, `participant_list` is a JSON String, and it stores emails.
      // So we use .ilike() to search for the user's email inside the text.
      final response = await supabase.from('create_escapade').select().ilike(
          'participant_list',
          '%${user.email!}%'); // Assuming participant_list stores user IDs

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        key: _futureKey, // Add key to refresh when data changes
        future: fetchEscapades(),
        builder: (context, snapshot) {
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
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _futureKey = UniqueKey();
                });
                await fetchEscapades();
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.2), // Push to center
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 136.w,
                          height: 136.h,
                          child: Image.asset('assets/images/beachdrink.png')),
                      Text(
                        'No joined escapades',
                        style: size24Weight600,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16.h),
                        child: TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _futureKey = UniqueKey();
                            });
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Refresh'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          final escapades = snapshot.data!;

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    _futureKey = UniqueKey();
                  });
                  await fetchEscapades();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _escapadesCard(escapades),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Widget _escapadesCard(List<Map<String, dynamic>> escapades) {
    return Expanded(
      child: ListView.separated(
          itemCount: escapades.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final escapade = escapades[index];
            // Extract data from Supabase with fallbacks for missing fields
            final category = escapade['category'] ?? 'CATEGORY';
            final name = escapade['name'] ?? 'NAME';
            final where = escapade['where'] ?? 'Date not specified';
            final when = escapade['when'] ?? 'Location not specified';
            final imageUrl = escapade['image_url'] ?? 'not specified';

            return GestureDetector(
              onTap: () {
                context.push('/escapadeDetails', extra: escapade);
              },
              child: Padding(
                padding: EdgeInsets.only(top: 24.h, left: 20.w, right: 20.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Replace the hardcoded avatars with dynamic participant images
                    _participantsImagesColumn(escapade),

                    Padding(
                      padding: EdgeInsets.only(bottom: 24.h),
                      child: Container(
                        height: 294.h,
                        width: 294.w,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(16.r)),
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 16.w, right: 16.w, top: 16.h, bottom: 4.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [
                                    0.1,
                                    0.75
                                  ],
                                  colors: [
                                    Color(0x10D9D9D9),
                                    Color(0xFF2C2C2C)
                                  ])),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 6.h, horizontal: 8.w),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.r),
                                    color: Colors.white),
                                child: Text(
                                  category,
                                  style: size10Weight700,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: TextStyle(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.h),
                                    child: Text(
                                      when,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14.sp,
                                          color: const Color(0xFFE3F04D)),
                                    ),
                                  ),
                                  Text(
                                    where,
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 6.h, horizontal: 8.w),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4.r),
                                            color: const Color(0xFF4A4A4A)),
                                        child: Text(
                                          'JOIN FOR FREE',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 10.sp,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _participantsImagesColumn(Map<String, dynamic> escapade) {
    final escapadeParticipantsImages = escapade['participants_images'];
    List<String> participantImages = [];

    if (escapadeParticipantsImages is String) {
      try {
        participantImages =
            List<String>.from(jsonDecode(escapadeParticipantsImages));
      } catch (e) {
        participantImages = [];
      }
    } else if (escapadeParticipantsImages is List) {
      participantImages = escapadeParticipantsImages.cast<String>();
    }

    final int participantCount = participantImages.length;
    final int displayCount =
        math.min(participantCount, 3); // Show max 3 avatars
    final int remainingCount = participantCount - displayCount;

    return SizedBox(
      height: 120.h,
      child: Stack(
        children: [
          // First avatar
          if (displayCount >= 1)
            _buildCircleAvatar(
              image: participantImages[0],
              top: 0.h,
            ),

          // Second avatar
          if (displayCount >= 2)
            Positioned(
              top: 25.h,
              child: _buildCircleAvatar(
                image: participantImages[1],
                top: 25.h,
              ),
            ),

          // Third avatar
          if (displayCount >= 3)
            Positioned(
              top: 50.h,
              child: _buildCircleAvatar(
                image: participantImages[2],
                top: 50.h,
              ),
            ),

          // Count indicator (show if more than 3 participants)
          if (remainingCount > 0)
            Positioned(
              top: 75.h,
              child: CircleAvatar(
                radius: 20.r,
                backgroundColor: chipColor,
                child: Text(
                  '+$remainingCount',
                  style: size14Weight700,
                ),
              ),
            ),

          // Empty state - show when no participants
          if (participantCount == 0)
            CircleAvatar(
              radius: 20.r,
              backgroundColor: Colors.grey[200],
              child: Icon(
                Icons.add,
                color: Colors.grey[600],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCircleAvatar({required String image, required double top}) {
    return CircleAvatar(
      radius: 20.r,
      backgroundColor: Colors.grey[200],
      backgroundImage: image.isNotEmpty ? NetworkImage(image) : null,
      onBackgroundImageError: (exception, stackTrace) {},
      child: image.isEmpty
          ? Icon(
              Icons.person,
              color: Colors.grey[600],
            )
          : null,
    );
  }
}
