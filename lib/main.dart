import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_planner/screens/home.dart';
import 'package:event_planner/screens/signin.dart';

Future<Widget> selectStartPage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');

  return (email == null) ? const SignInScreen() : const HomeScreen();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp(await selectStartPage()));
}

class MyApp extends StatelessWidget {
  final Widget startPage;
  const MyApp(this.startPage, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Planner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: startPage,
    );
  }
}
