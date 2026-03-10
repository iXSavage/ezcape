import 'package:ezcape/constants.dart';
import 'package:ezcape/pages/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _passwordVisible = false;
  final authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void signIn() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      await authService.signInWithEmailPassword(email, password);
      context.go(
        '/customBottomNavigationBar',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _showForgotPasswordDialog() {
    final resetEmailController =
        TextEditingController(text: _emailController.text);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Enter your email to receive a password reset link.'),
              SizedBox(height: 16.h),
              TextField(
                controller: resetEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email address',
                  filled: true,
                  fillColor: fillColor,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(color: borderRadiusColor)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(color: borderRadiusColor)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black54)),
            ),
            ElevatedButton(
              onPressed: () async {
                final email = resetEmailController.text.trim();
                if (email.isEmpty) return;

                try {
                  await authService.resetPassword(email);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Password reset link sent! Check your inbox.')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: buttonForegroundColor,
              ),
              child: const Text('Send Link'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                          child:
                              SvgPicture.asset('assets/icons/backbutton.svg')),
                      Padding(
                        padding: EdgeInsets.only(top: 16.h, bottom: 12.h),
                        child: Text(
                          'Welcome back',
                          style: onboardingHeading,
                        ),
                      ),
                      Text(
                        'Paintball Battle is better with friends. Invite your friends to join you on this escapade.',
                        style: onboardingBody,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 32.h, bottom: 24.h),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
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
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_passwordVisible,
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        decoration: InputDecoration(
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
                            filled: true,
                            fillColor: fillColor,
                            hintText: 'Password',
                            hintStyle: const TextStyle(color: hintTextColor),
                            border: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: borderRadiusColor)),
                            enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: borderRadiusColor))),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16.h, bottom: 20.h),
                        child: GestureDetector(
                          onTap: _showForgotPasswordDialog,
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(
                              fontFamily: 'ZTTalk',
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20.h, top: 10.h),
                child: CustomButton(
                  buttonText: 'Sign in',
                  onPressed: signIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
