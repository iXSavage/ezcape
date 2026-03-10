import 'dart:io';
import 'package:ezcape/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateEscapade extends StatefulWidget {
  const CreateEscapade({super.key});

  @override
  State<CreateEscapade> createState() => _CreateEscapadeState();
}

class _CreateEscapadeState extends State<CreateEscapade> {
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController rulesController = TextEditingController();
  final TextEditingController whereController = TextEditingController();
  final TextEditingController maxLimitController = TextEditingController();
  final TextEditingController whenController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? image;
  String? selectedCategoryValue;
  bool makePublic = false;
  String? publicUrl;
  bool isLoading = false;

  @override
  void dispose() {
    categoryController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    rulesController.dispose();
    whereController.dispose();
    maxLimitController.dispose();
    whenController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) {
      return;
    }

    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage == null) {
        // User canceled the picker
        return;
      }

      final imageTemporary = File(pickedImage.path);
      setState(() {
        image = imageTemporary; // this.image refers to your global File? image
      });
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image picking failed: $e')),
      );
    }
  }

  Future uploadImage() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) {
      return;
    }
    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image')));
      return;
    }
    final email = user.email;

    final file = File(image!.path);
    final fileName = '${email}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    try {
      // Upload to Supabase Storage
      final storageResponse = await supabase.storage
          .from('escapade-images') // replace with your bucket name
          .upload('profiles/$fileName', file);

      if (storageResponse.isEmpty) {
        throw Exception('Image upload failed');
      }

      // Get the public URL
      final publicUrl = supabase.storage
          .from('escapade-images')
          .getPublicUrl('profiles/$fileName');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Upload successful")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Upload failed")),
      );
    }
  }

  void publishEscapade() async {
    // Show loading indicator first
    setState(() {
      isLoading = true; // Add this boolean to your state variables
    });

    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image')));
      setState(() {
        isLoading = false;
      });
      return;
    }

    // Removed unused query here

    final email = user.email;

    final file = File(image!.path);
    final fileName = '${email}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    if (_formKey.currentState!.validate() && selectedCategoryValue != null) {
      try {
        // Upload to Supabase Storage
        final storageResponse = await supabase.storage
            .from('escapade-images') // replace with your bucket name
            .upload('profiles/$fileName', file);

        if (storageResponse.isEmpty) {
          throw Exception('Image upload failed');
        }

        // Get the public URL
        publicUrl = supabase.storage
            .from('escapade-images')
            .getPublicUrl('profiles/$fileName');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Upload failed")),
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      try {
        if (email == null) {
          throw Exception('User email is null');
        }
        final interest =
            await supabase.from('user_interests').select().eq('email', email);
        if (interest.isEmpty) {
          throw Exception('User profile not found. Please complete your bio.');
        }
        final profileName = interest[0]['profile_name'];
        final profileImage = interest[0]['image'];
        final response = await supabase
            .from('create_escapade')
            .upsert({
              'user_id': user.id,
              'email': email,
              'category': categoryController.text,
              'name': nameController.text,
              'description': descriptionController.text,
              'where': whereController.text,
              'when': whenController.text,
              'rules': rulesController.text,
              'make_public': makePublic.toString(),
              'image_url': publicUrl,
              'profile_name': profileName,
              'created_by': profileImage,
              'max_limit': maxLimitController.text
            })
            .select()
            .single();

        final Map<String, dynamic> escapade = response;

        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Upload successful")),
        );

        context.go('/shareEscapade', extra: escapade);
      } catch (e) {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ensure all forms are filled')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isLoading,
      child: Scaffold(
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: [
              SliverAppBar(
                  centerTitle: true,
                  pinned: true,
                  floating: false,
                  stretch: false,
                  expandedHeight: 250.h,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                        child: image == null
                            ? Image.asset(
                                'assets/images/Cover_photo.png',
                                fit: BoxFit.fill,
                              )
                            : Image.file(image!, fit: BoxFit.cover),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton.icon(
                          onPressed: pickImage,
                          label: Text(
                            'Cover photo',
                            style: size14Weight600,
                          ),
                          icon: SvgPicture.asset('assets/icons/image_plus.svg'),
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(127.w, 40.h),
                              foregroundColor: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 35.h, horizontal: 10.w),
                        child: IconButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  context.pop();
                                },
                          style: IconButton.styleFrom(
                            backgroundColor:
                                isLoading ? Colors.grey : Colors.black,
                          ),
                          icon: SvgPicture.asset('assets/icons/backbutton.svg',
                              colorFilter: ColorFilter.mode(
                                  isLoading
                                      ? Colors.grey.shade400
                                      : Colors.white,
                                  BlendMode.srcIn)),
                        ),
                      ),
                    ],
                  )),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownMenu(
                        controller: categoryController,
                        hintText: 'Category',
                        width: MediaQuery.of(context).size.width - 40.w,
                        initialSelection: selectedCategoryValue,
                        onSelected: (String? value) {
                          setState(() {
                            selectedCategoryValue = value;
                          });
                          // print('$value');
                        },
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(value: 'Outdoor', label: 'Outdoor'),
                          DropdownMenuEntry(value: 'Sport', label: 'Sport'),
                          DropdownMenuEntry(
                              value: 'Adventure', label: 'Adventure'),
                          DropdownMenuEntry(value: 'Gaming', label: 'Gaming'),
                        ],
                        // inputDecorationTheme: InputDecorationTheme(
                        //   border: OutlineInputBorder(),
                        //   constraints: BoxConstraints.tight(Size.fromHeight(60.h))
                        // ),
                      ),
                      Visibility(
                          visible: selectedCategoryValue == null,
                          child: const Text(
                            'Please select a category',
                            style: TextStyle(color: Colors.red),
                          )),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        child: TextFormField(
                          controller: nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter name of event';
                            } else {
                              return null;
                            }
                          },
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: fillColor,
                            hintStyle: size16Weight500,
                            hintText: 'Name',
                            enabled: true,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.r)),
                                borderSide:
                                    const BorderSide(color: borderRadiusColor)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.r)),
                                borderSide:
                                    const BorderSide(color: borderRadiusColor)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 120.h,
                        child: TextFormField(
                          maxLines: null,
                          expands: true,
                          textAlign: TextAlign.start,
                          textAlignVertical: TextAlignVertical.top,
                          controller: descriptionController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter a description';
                            } else {
                              return null;
                            }
                          },
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(left: 16.w, top: 22.h),
                            filled: true,
                            fillColor: fillColor,
                            hintStyle: size16Weight500,
                            hintText: 'Description',
                            enabled: true,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.r)),
                                borderSide:
                                    const BorderSide(color: borderRadiusColor)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.r)),
                                borderSide:
                                    const BorderSide(color: borderRadiusColor)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        child: TextFormField(
                          controller: whereController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter where';
                            } else {
                              return null;
                            }
                          },
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: fillColor,
                            hintStyle: size16Weight500,
                            hintText: 'Where',
                            enabled: true,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.r)),
                                borderSide:
                                    const BorderSide(color: borderRadiusColor)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.r)),
                                borderSide:
                                    const BorderSide(color: borderRadiusColor)),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: whenController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter when';
                          } else {
                            return null;
                          }
                        },
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: fillColor,
                          hintStyle: size16Weight500,
                          hintText: 'when',
                          enabled: true,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.r)),
                              borderSide:
                                  const BorderSide(color: borderRadiusColor)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.r)),
                              borderSide:
                                  const BorderSide(color: borderRadiusColor)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        child: SizedBox(
                          height: 120.h,
                          child: TextFormField(
                            maxLines: null,
                            expands: true,
                            textAlign: TextAlign.start,
                            textAlignVertical: TextAlignVertical.top,
                            controller: rulesController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter a Rule';
                              } else {
                                return null;
                              }
                            },
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 16.w, top: 22.h),
                              filled: true,
                              fillColor: fillColor,
                              hintStyle: size16Weight500,
                              hintText: 'Rules',
                              enabled: true,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.r)),
                                  borderSide: const BorderSide(
                                      color: borderRadiusColor)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.r)),
                                  borderSide: const BorderSide(
                                      color: borderRadiusColor)),
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: maxLimitController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter a max limit of users';
                          }
                          final number = int.tryParse(value);
                          if (number == null) {
                            return 'Please enter a valid number';
                          }
                          if (number <= 0 || number >= 100) {
                            return 'Value must be between 1 and 99';
                          }
                          return null;
                        },
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: fillColor,
                          hintStyle: size16Weight500,
                          hintText: 'Max Limit',
                          enabled: true,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.r)),
                              borderSide:
                                  const BorderSide(color: borderRadiusColor)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.r)),
                              borderSide:
                                  const BorderSide(color: borderRadiusColor)),
                        ),
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 22.h, horizontal: 20.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: borderRadiusColor),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Make escapade public',
                                    style: size16Weight500,
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Text(
                                    'Making your escapade public allows anyone on Ezcape to see and join.',
                                    style: size14Weight500,
                                  )
                                ],
                              ),
                            ),
                            Switch(
                                value: makePublic,
                                onChanged: (value) {
                                  setState(() {
                                    makePublic = value;
                                  });
                                })
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : publishEscapade, // Can be null, making it optional
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
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                    strokeWidth: 2.0,
                                  ),
                                )
                              : const Text('Publish Escapade')),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
