import 'dart:convert';
import 'dart:math' as math;
import 'package:ezcape/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EscapadeDetails extends StatefulWidget {
   const EscapadeDetails({super.key, required this.escapade});

  final Map<String, dynamic> escapade;

  @override
  State<EscapadeDetails> createState() => _EscapadeDetailsState();
}

class _EscapadeDetailsState extends State<EscapadeDetails> {
  final currentUserEmail = Supabase.instance.client.auth.currentUser?.email;

  void addToBookmark(){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        content: Text('Bookmark feature coming soon, please stay tuned!', style: size14Weight500,),
        actions: [
          TextButton(onPressed: (){
            context.pop();
          },
              child: const Text('Ok'))
        ],
      );
    }
    );
  }

  void leaveFunction() async {
    try {
      final rawParticipantList = widget.escapade['participant_list'];
      final rawParticipantImages = widget.escapade['participants_images'];
      final escapadeName = widget.escapade['name'];

      if (escapadeName == null || currentUserEmail == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error: Missing required information")),
        );
        return;
      }

      List<String> participantList = [];
      List<String> participantImages = [];

      // Parse participant list
      if (rawParticipantList is String) {
        try {
          participantList = List<String>.from(jsonDecode(rawParticipantList));
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error loading participant data")),
          );
          return;
        }
      } else if (rawParticipantList is List) {
        participantList = rawParticipantList.cast<String>();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error: Invalid participant data")),
        );
        return;
      }

      // Parse existing participant images
      if (rawParticipantImages is String) {
        try {
          participantImages = List<String>.from(jsonDecode(rawParticipantImages));
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error loading participant images")),
          );
          return;
        }
      } else if (rawParticipantImages is List) {
        participantImages = rawParticipantImages.cast<String>();
      } else {
        participantImages = [];
      }

      // Check if user is in the list before attempting to remove
      if (!participantList.contains(currentUserEmail)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You're not part of this escapade")),
        );
        return;
      }

      // Get user's current image to match it correctly
      String? currentUserImage;
      try {
        final imageResponse = await supabase
            .from('user_interests')
            .select('image')
            .eq('email', currentUserEmail!)
            .single();

        currentUserImage = imageResponse['image'];
      } catch (e) {
        // Continue - we can still remove by email
      }

      // Remove user from participant list
      participantList.remove(currentUserEmail!);

      // Remove user's image from participant images
      // Use image matching instead of index-based removal for better accuracy
      if (currentUserImage != null && currentUserImage.isNotEmpty) {
        participantImages.remove(currentUserImage);
      } else {
      }

      // Update database
      final response = await supabase
          .from('create_escapade')
          .update({
        'participant_list': jsonEncode(participantList), // Encode as JSON string
        'participants_images': jsonEncode(participantImages) // Encode as JSON string
      })
          .eq('name', escapadeName)
          .select();

      // Check if update was successful
      if (response.isNotEmpty) {
        context.go('/customBottomNavigationBar');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Successfully left the escapade"),
            backgroundColor: Colors.orange,
          ),
        );

        // Optional: Navigate back or refresh the UI
        // Navigator.of(context).pop();

      } else {
        throw Exception('No rows updated - escapade may not exist');
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to leave escapade. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

   void joinFunction() async {
     try {
       final rawParticipantList = widget.escapade['participant_list'];
       final rawParticipantImages = widget.escapade['participants_images'];
       final escapadeName = widget.escapade['name'];

       if (escapadeName == null || currentUserEmail == null) {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text("Error: Missing required information")),
         );
         return;
       }

       List<String> participantList = [];
       List<String> participantImages = [];

       // Parse participant list
       if (rawParticipantList is String) {
         try {
           participantList = List<String>.from(jsonDecode(rawParticipantList));
         } catch (e) {
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text("Error loading participant data")),
           );
           return;
         }
       } else if (rawParticipantList is List) {
         participantList = rawParticipantList.cast<String>();
       } else {
         // Initialize empty list if null
         participantList = [];
       }

       // Parse existing participant images
       if (rawParticipantImages is String) {
         try {
           participantImages = List<String>.from(jsonDecode(rawParticipantImages));
         } catch (e) {
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text("Error loading participant images")),
           );
           return;
         }
       } else if (rawParticipantImages is List) {
         participantImages = rawParticipantImages.cast<String>();
       } else {
         // Initialize empty list if null
         participantImages = [];
       }

       // Check if user is already in the list
       if (participantList.contains(currentUserEmail)) {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text("You're already part of this escapade!")),
         );
         return;
       }

       // Get current user's image
       String? userImage;
       try {
         final imageResponse = await supabase
             .from('user_interests')
             .select('image')
             .eq('email', currentUserEmail!)
             .single();

         userImage = imageResponse['image'];
       } catch (e) {
         // Continue without image - this is not a critical error
       }

       // Add user to lists
       participantList.add(currentUserEmail!);
       if (userImage != null && userImage.isNotEmpty) {
         participantImages.add(userImage);
       }

       // Update database - store as JSON strings if that's your schema requirement
       final response = await supabase
           .from('create_escapade')
           .update({
         'participant_list': jsonEncode(participantList), // Encode as JSON string
         'participants_images': jsonEncode(participantImages) // Encode as JSON string
       })
           .eq('name', escapadeName)
           .select();

       // Check if update was successful
       if (response.isNotEmpty) {
         context.go('/customBottomNavigationBar');
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(
             content: Text("Successfully joined the escapade!"),
             backgroundColor: Colors.green,
           ),
         );
       } else {
         throw Exception('No rows updated - escapade may not exist');
       }

     } catch (e) {
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(
           content: Text("Failed to join escapade. Please try again."),
           backgroundColor: Colors.red,
         ),
       );
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
                          image: DecorationImage(image: NetworkImage(widget.escapade['image_url']), fit: BoxFit.cover
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
                                    icon: SvgPicture.asset('assets/icons/backbutton.svg', colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn))
                                ),

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

                                _bookmarkButton(),

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
                                  backgroundImage: NetworkImage(widget.escapade['created_by']),
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

                                _participantsImagesRow()
                              ],
                            ),
                          ),

                          Text('Rules', style: size16Weight500,),

                          SizedBox(height: 12.h,),

                          Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('▪️'),
                                Expanded(
                                    child: Text(widget.escapade['rules'],
                                      style: size16Weight500,
                                    )
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(
              color: chipColor,
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: _buildActionButton()
            )
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(){
    final escapadeParticipants = widget.escapade['participant_list'];
    List<String> participants = [];

    if (escapadeParticipants is String){
      //make sure it is converted to a list
      participants = List<String>.from(jsonDecode(escapadeParticipants));
    } else
    if (escapadeParticipants is List){
      //make sure all the items in the list are treated as a string
      participants = escapadeParticipants.cast<String>();
    }

    final bool isParticipant = participants.contains(currentUserEmail);

    if (isParticipant == true) {
      return CustomButton(buttonText: 'Leave', onPressed: leaveFunction,);
    } else if (participants.length < widget.escapade['max_limit']){
      return CustomButton(buttonText: 'Join', onPressed:  joinFunction,);
    } else {
      return const CustomButton(buttonText: 'Limit reached', onPressed: null,);
    }

  }

  Widget _participantsImagesRow(){
    final escapadeParticipantsImages = widget.escapade['participants_images'];
    List<String> participantImages = [];

    if (escapadeParticipantsImages is String) {
      try {
        participantImages = List<String>.from(jsonDecode(escapadeParticipantsImages));
      } catch (e) {
        participantImages = [];
      }
    } else if (escapadeParticipantsImages is List) {
      participantImages = escapadeParticipantsImages.cast<String>();
    }

    final int participantCount = participantImages.length;
    final int displayCount = math.min(participantCount, 3); // Show max 3 avatars
    final int remainingCount = participantCount - displayCount;


    return SizedBox(
      width: 120.w,
      child: Stack(
        children: [

          if (displayCount >= 1)
            _buildCircleAvatar(image: participantImages[0],),

          if (displayCount >= 2)
            Positioned(
              left: 25.w,
                child: _buildCircleAvatar(image: participantImages[1],)
            ),

          if (displayCount >= 3)
            Positioned(
                left: 50.w,
                child: _buildCircleAvatar(image: participantImages[2],)
            ),

          if (remainingCount > 0)
            Positioned(
              left: 75.w,
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
            Center(
              child: CircleAvatar(
                radius: 20.r,
                backgroundColor: Colors.grey[200],
                child: Icon(
                  Icons.add,
                  color: Colors.grey[600],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCircleAvatar({required String image,}) {
    return CircleAvatar(
      radius: 20.r,
      backgroundColor: Colors.grey[200],
      backgroundImage: image.isNotEmpty ? NetworkImage(image) : null,
      child: image.isEmpty ? const Icon(Icons.add) : null,
    );
  }

  Widget _bookmarkButton(){

    final escapadeParticipants = widget.escapade['participant_list'];
    List<String> participants = [];

    if (escapadeParticipants is String){
      //make sure it is converted to a list
      participants = List<String>.from(jsonDecode(escapadeParticipants));
    } else
    if (escapadeParticipants is List){
      //make sure all the items in the list are treated as a string
      participants = escapadeParticipants.cast<String>();
    }

    if (participants.length < widget.escapade['max_limit']){
      return BookmarkButton(onPressed: addToBookmark);
    } else {
      return const BookmarkButton();
    }

   }
}
