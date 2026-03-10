import 'package:ezcape/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  late Future<List<Map<String, dynamic>>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = _loadNotifications();
  }

  Future<List<Map<String, dynamic>>> _loadNotifications() async {
    try {
      final response = await supabase
          .from('escapade_notifications')
          .select()
          .order('created_at', ascending: false); // Order by newest first

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw error;
    }
  }

  // Method to refresh notifications
  Future<void> _refreshNotifications() async {
    setState(() {
      _notificationsFuture = _loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 48.r,
        leading: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: SvgPicture.asset('assets/icons/bell_notification.svg'),
        ),
        title: Text('Notifications', style: size24Weight600),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              // Handle settings action
            },
            icon: SvgPicture.asset('assets/icons/settings.svg'),
          )
        ],
      ),

      body: RefreshIndicator(
        onRefresh: _refreshNotifications,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _notificationsFuture,
          builder: (context, snapshot) {
            // Handle loading state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Handle error state
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48.r,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Failed to load notifications',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    ElevatedButton(
                      onPressed: _refreshNotifications,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            // Handle empty data
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
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
              );
            }

            final notifications = snapshot.data!;
            return _buildNotificationsList(notifications);
          },
        ),
      ),
    );
  }

  Widget _buildNotificationsList(List<Map<String, dynamic>> notifications) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: notifications.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: Colors.grey[200],
      ),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationTile(notification);
      },
    );
  }

  Widget _buildNotificationTile(Map<String, dynamic> notification) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      leading: CircleAvatar(
        radius: 24.r,
        backgroundColor: Colors.grey[200],
        child: ClipOval(
          child: notification['profile_image'] != null
              ? Image.network(
            notification['profile_image'],
            width: 48.r,
            height: 48.r,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.person,
                size: 24.r,
                color: Colors.grey[400],
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return CircularProgressIndicator(
                strokeWidth: 2,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
              );
            },
          )
              : Icon(
            Icons.person,
            size: 24.r,
            color: Colors.grey[400],
          ),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              notification['escapade_name'] ?? 'Unknown Event',
              style: size16Weight600,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            (notification['created_at'] ?? ''),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFAAA8A8),
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: 4.h),
        child: Text(
          '${notification['profile_name'] ?? 'Someone'} created a new escapade, check it out!',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF4A4A4A),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}