import 'package:ezcape/bottom_navigation_bar.dart';
import 'package:ezcape/pages/walkthrough.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()
            ),
          );
        }

        //Check for valid session
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null){
          return CustomBottomNavigationBar();
        } else {
          return const Walkthrough();
        }

      }
      );
  }
}
