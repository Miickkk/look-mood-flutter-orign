import 'package:look_mood/views/home.dart';
import 'package:look_mood/views/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MaterialApp(
    title: "Look & Mood",
    theme: ThemeData(
      primarySwatch: Colors.orange,
      brightness: Brightness.dark
    ),
    home: AuthStream(), 
  ));
}

class AuthStream extends StatelessWidget {
  const AuthStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      
      builder: (context, snapshot){ 

        if(snapshot.hasData){
          return HomeView();
        }
        return LoginView();
      });
  }
}