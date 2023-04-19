import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:event_planner/models/colors.dart';
import 'package:event_planner/models/logo.dart';
import 'package:event_planner/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexStringToColor("7645c4"),
            hexStringToColor("5d8df4"),
            hexStringToColor("dee6f4")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter UserName", Icons.person_outline, false,
                    _userNameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Email Id", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outlined, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                firebaseUIButton(context, "Sign Up", () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('email', _emailTextController.text);

                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) async {
                    final document = await FirebaseFirestore.instance
                        .collection("users")
                        .doc(value.user?.uid)
                        .get();
                    if (!document.exists) {
                      // FirebaseAuth user name
                      value.user
                          ?.updateDisplayName(_userNameTextController.text);
                      // Create user's collection of events
                      await FirebaseFirestore.instance
                          .collection("events")
                          .doc(value.user?.uid)
                          .set({
                        "event0": "Join Event",
                        "description0": "Date user started using application",
                        "email0": _emailTextController.text,
                        "username0": _userNameTextController.text,
                        "date0": DateTime.now(),
                      });
                      debugPrint("Created New Account");
                    } else {
                      throw Exception(
                          "[Local error] User ${_emailTextController.text} already exists");
                    }
                    if (context.mounted) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                    }
                  }).onError((error, stackTrace) {
                    debugPrint("Error ${error.toString()}");
                    prefs.remove('email');
                  });
                })
              ],
            ),
          ))),
    );
  }
}