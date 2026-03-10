import 'package:ezcape/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> categories = [
    'Explore',
    'Adventure',
    'Gaming',
    'Outdoor',
    'Swimming',
    'Sport'
  ];
  String selectedCategory = 'Explore';
  final supabase = Supabase.instance.client;

  // Add state variable to store user data
  String userName = 'Guest'; // Default fallback
  bool isLoadingUser = true;

  // Add variables for filtering and refresh
  List<Map<String, dynamic>> allEscapades = [];
  List<Map<String, dynamic>> filteredEscapades = [];
  bool isLoadingEscapades = false;

  @override
  void initState() {
    super.initState();
    // Fetch user data when widget initializes
    _loadUserData();
    // Load escapades data
    _loadEscapades();
  }

  Future<void> _loadUserData() async {
    try {
      final userEmail = supabase.auth.currentUser?.email;
      if (userEmail == null) throw Exception('Not logged in');

      final userResponse =
          await supabase.from('user_interests').select().eq('email', userEmail);

      if (userResponse.isNotEmpty && userResponse[0]['profile_name'] != null) {
        setState(() {
          userName = userResponse[0]['profile_name'];
          isLoadingUser = false;
        });
      } else {
        setState(() {
          userName = 'Guest';
          isLoadingUser = false;
        });
      }
    } catch (error) {
      setState(() {
        userName = 'Guest';
        isLoadingUser = false;
      });
    }
  }

  Future<void> _loadEscapades() async {
    setState(() {
      isLoadingEscapades = true;
    });

    try {
      final response = await supabase.from('create_escapade').select();

      final escapades = List<Map<String, dynamic>>.from(response);

      setState(() {
        allEscapades = escapades;
        _filterEscapades(); // Apply current filter
        isLoadingEscapades = false;
      });
    } catch (error) {
      setState(() {
        isLoadingEscapades = false;
      });
    }
  }

  void _filterEscapades() {
    if (selectedCategory == 'Explore') {
      // Show all escapades for 'Explore'
      filteredEscapades = List.from(allEscapades);
    } else {
      // Filter by selected category (case-insensitive)
      filteredEscapades = allEscapades.where((escapade) {
        final category = escapade['category']?.toString().toLowerCase() ?? '';
        return category == selectedCategory.toLowerCase();
      }).toList();
    }
  }

  Future<void> _refreshData() async {
    // Refresh both user data and escapades
    await Future.wait([
      _loadUserData(),
      _loadEscapades(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: isLoadingUser
              ? Text('Good morning...', style: size24Weight600)
              : Text('Good morning, $userName', style: size24Weight600),
          actions: [
            IconButton(
                onPressed: () {
                  context.push('/createEscapade');
                },
                icon: SvgPicture.asset('assets/icons/plus.svg'))
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: isLoadingEscapades
              ? const Center(child: CircularProgressIndicator())
              : allEscapades.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 136.w,
                              height: 136.h,
                              child:
                                  Image.asset('assets/images/beachdrink.png')),
                          Text(
                            'No escapade found',
                            style: size24Weight600,
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 20.w, bottom: 4.h, top: 8.h),
                              child: _categoriesChipSection(categories),
                            )),
                        filteredEscapades.isEmpty
                            ? Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.search_off,
                                        size: 64,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No escapades found for "$selectedCategory"',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : _escapadesCard(filteredEscapades),
                      ],
                    ),
        ));
  }

  Widget _categoriesChipSection(List<String> options) {
    return Wrap(
      spacing: 8,
      children: categories.map((category) {
        return ChoiceChip(
            visualDensity: VisualDensity.compact,
            label: Text(category),
            selected: selectedCategory == category,
            selectedColor: Colors.black87,
            showCheckmark: false,
            onSelected: (bool selected) {
              setState(() {
                selectedCategory = category;
                _filterEscapades(); // Apply filter when category changes
              });
            },
            labelStyle: TextStyle(
                color: selectedCategory == category
                    ? Colors.white
                    : Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 14.sp),
            backgroundColor: chipColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r)));
      }).toList(),
    );
  }

  Widget _escapadesCard(List<Map<String, dynamic>> escapades) {
    return Expanded(
      child: ListView.builder(
          itemCount: escapades.length,
          itemBuilder: (context, index) {
            final escapade = escapades[index];

            final category = escapade['category'] ?? 'CATEGORY';
            final name = escapade['name'] ?? 'NAME';
            final where = escapade['where'] ?? 'Location not specified';
            final when = escapade['when'] ?? 'Date not specified';
            final imageUrl = escapade['image_url'] ?? 'not specified';

            return Padding(
              padding: EdgeInsets.only(top: 24.h, left: 20.w, right: 20.w),
              child: GestureDetector(
                onTap: () {
                  context.push('/escapadeDetails', extra: escapade);
                },
                child: Container(
                  height: 350.h,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(imageUrl), fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(16.r)),
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 16.w, right: 16.w, top: 16.h, bottom: 4.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.1, 0.75],
                            colors: [Color(0x10D9D9D9), Color(0xFF2C2C2C)])),
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
                          child: Text(category, style: size10Weight700),
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
                              padding: EdgeInsets.symmetric(vertical: 8.h),
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
                            SizedBox(height: 12.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 6.h, horizontal: 8.w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.r),
                                      color: const Color(0xFF4A4A4A)),
                                  child: Text(
                                    'JOIN FOR FREE',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 10.sp,
                                        color: Colors.white),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Text(
                                              'Bookmark feature coming soon, please stay tuned!',
                                              style: size14Weight500,
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    context.pop();
                                                  },
                                                  child: const Text('Ok'))
                                            ],
                                          );
                                        });
                                  },
                                  icon: SvgPicture.asset(
                                      'assets/icons/bookmark.svg'),
                                  style: IconButton.styleFrom(
                                      backgroundColor: const Color(0xFF4A4A4A)),
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
            );
          }),
    );
  }
}
