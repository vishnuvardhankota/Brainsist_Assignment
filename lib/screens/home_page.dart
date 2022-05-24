import 'package:brainsist/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brainsyst'),
        actions: [
          IconButton(onPressed: (){
            FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LogInPage()),
                    (route) => false);
          }, icon: const Icon(Icons.logout))
        ],
      ),
      body: const Center(child: Text('Welcome'),),
    );
  }
}
