import 'package:ezcape/constants.dart';
import 'package:ezcape/pages/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  final authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final String? session = supabase.auth.currentUser?.email;

  void signUp() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      await authService.signUpWithEmailPassword(
        email,
        password,
      );
      context.go(
        '/chooseInterest',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                            onTap: () {
                              context.pop();
                            },
                            child: SvgPicture.asset(
                                'assets/icons/backbutton.svg')),
                        Padding(
                          padding: EdgeInsets.only(top: 16.h, bottom: 12.h),
                          child: Text(
                            'Create an account',
                            style: onboardingHeading,
                          ),
                        ),
                        Text(
                          'Paintball Battle is better with friends. Invite your friends to join you on this escapade.',
                          style: onboardingBody,
                        ),
                        SizedBox(
                          height: 32.h,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email is required";
                            } else if (!RegExp(
                                    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                                .hasMatch(value)) {
                              return "Enter a valid email";
                            }
                            return null; // No error
                          },
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: fillColor,
                              hintText: 'Email address',
                              hintStyle: TextStyle(color: hintTextColor),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: borderRadiusColor)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: borderRadiusColor))),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.h),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: !_passwordVisible,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password is required";
                              } else if (value.length < 6) {
                                return "Password must be at least 6 characters";
                              } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                return "Must contain at least one uppercase letter";
                              } else if (!RegExp(r'[a-z]').hasMatch(value)) {
                                return "Must contain at least one lowercase letter";
                              } else if (!RegExp(r'[0-9]').hasMatch(value)) {
                                return "Must contain at least one number";
                              } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                                  .hasMatch(value)) {
                                return "Must contain at least one special character";
                              }
                              return null; // No error
                            },
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: fillColor,
                                hintText: 'Password',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                                hintStyle:
                                    const TextStyle(color: hintTextColor),
                                border: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: borderRadiusColor)),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: borderRadiusColor))),
                          ),
                        ),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: !_confirmPasswordVisible,
                          validator: (value) {
                            if (_passwordController.text !=
                                _confirmPasswordController.text) {
                              return 'Password does not match';
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
                              hintText: 'Confirm Password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _confirmPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _confirmPasswordVisible =
                                        !_confirmPasswordVisible;
                                  });
                                },
                              ),
                              hintStyle: const TextStyle(color: hintTextColor),
                              border: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: borderRadiusColor)),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: borderRadiusColor))),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20.h, top: 10.h),
                  child: CustomButton(
                    buttonText: 'Create account',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        signUp();
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => const AlertDialog(
                            title: Text('Ensure all forms are filled'),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
