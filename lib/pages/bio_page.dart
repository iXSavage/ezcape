import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants.dart';

class BioPage extends StatefulWidget {
  const BioPage({super.key});

  @override
  State<BioPage> createState() => _BioPageState();
}

class _BioPageState extends State<BioPage> {
  TextEditingController _profileNameController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  String? selectedGenderValue;
  final _formKey = GlobalKey<FormState>();
  File? image;
  String? publicUrl;
  bool isLoading = false;

  @override
  void dispose() {
    _profileNameController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void saveAndFinishUp() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    if (selectedGenderValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a gender')),
      );
      return;
    }

    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image')));
      return;
    }

    // Show loading indicator first
    setState(() {
      isLoading = true; // Add this boolean to your state variables
    });

    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      return;
    }

    final email = user.email;
    final file = File(image!.path);
    final fileName = '${email}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    try {
      // Upload to Supabase Storage
      final storageResponse = await supabase.storage
          .from('escapade-images') // replace with your bucket name
          .upload('profile_pictures/$fileName', file);

      if (storageResponse.isEmpty) {
        throw Exception('Image upload failed');
      }

      // Get the public URL
      publicUrl = supabase.storage
          .from('escapade-images')
          .getPublicUrl('profile_pictures/$fileName');
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Upload failed")),
      );
      return;
    }

    try {
      final response = await supabase.from('user_interests').upsert({
        'email': email,
        'profile_name': _profileNameController.text,
        'gender': selectedGenderValue,
        'location': _locationController.text,
        'bio': _bioController.text,
        'image': publicUrl
      });

      context.go('/customBottomNavigationBar');
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 16.h, bottom: 12.h),
                    child: Text(
                      'Fill in your bio',
                      style: onboardingHeading,
                    ),
                  ),
                  Text(
                    'Please ensure you fill out your bio, so others can connect with you.',
                    style: onboardingBody,
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  Center(
                      child: GestureDetector(
                    onTap: pickImage,
                    child: CircleAvatar(
                      radius: 75.r,
                      backgroundImage: image != null ? FileImage(image!) : null,
                      child: image == null
                          ? const Text('Select a profile picture')
                          : null,
                    ),
                  )),
                  SizedBox(
                    height: 20.h,
                  ),
                  TextFormField(
                    controller: _profileNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a profile name"; // No error
                      }
                      return null;
                    },
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: fillColor,
                        hintText: 'Profile Name',
                        hintStyle: TextStyle(color: hintTextColor),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: borderRadiusColor)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: borderRadiusColor))),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  DropdownMenu(
                    hintText: 'Gender',
                    width: MediaQuery.of(context).size.width - 40.w,
                    initialSelection: selectedGenderValue,
                    onSelected: (String? value) {
                      setState(() {
                        selectedGenderValue = value;
                      });
                      // print('$value');
                    },
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(value: 'M', label: 'Male'),
                      DropdownMenuEntry(value: 'F', label: 'Female'),
                    ],
                    // inputDecorationTheme: InputDecorationTheme(
                    //   border: OutlineInputBorder(),
                    //   constraints: BoxConstraints.tight(Size.fromHeight(60.h))
                    // ),
                  ),
                  Visibility(
                      visible: selectedGenderValue == null,
                      child: const Text(
                        'Please select a gender',
                        style: TextStyle(color: Colors.red),
                      )),
                  SizedBox(
                    height: 20.h,
                  ),
                  TextFormField(
                    controller: _locationController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a location";
                      }
                      return null; // No error
                    },
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: fillColor,
                        hintText: 'Location',
                        hintStyle: TextStyle(color: hintTextColor),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: borderRadiusColor)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: borderRadiusColor))),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  TextFormField(
                    controller: _bioController,
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Bio is required";
                      }
                      return null; // No error
                    },
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: fillColor,
                        hintText: 'Bio',
                        hintStyle: TextStyle(color: hintTextColor),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: borderRadiusColor)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: borderRadiusColor))),
                  ),
                  SizedBox(
                    height: 90.h,
                  ),
                  ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : saveAndFinishUp, // Can be null, making it optional
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
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 2.0,
                              ),
                            )
                          : const Text('Save and finish up')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
