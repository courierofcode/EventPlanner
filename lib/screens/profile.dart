import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_planner/models/colors.dart';
import 'package:event_planner/models/logo.dart';
import 'package:event_planner/screens/signin.dart';

class Profile extends StatelessWidget {
  Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                Icon(Icons.account_circle, color: Colors.blue[50], size: 100),
                const SizedBox(
                  height: 30,
                ),
                Text("${FirebaseAuth.instance.currentUser?.displayName}",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.purple[900],
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(
                  height: 20,
                ),
                Text("${FirebaseAuth.instance.currentUser?.email}",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.purple[900],
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(
                  height: 20,
                ),
                firebaseUIButton(context, "Logout", () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('email');

                  FirebaseAuth.instance.signOut().then((value) {
                    debugPrint("Signed Out");
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInScreen()));
                  }).onError((error, stackTrace) {
                    debugPrint("Error ${error.toString()}");
                  });
                }),
                firebaseDeleteButton(context, "Delete Account", () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('email');

                  FirebaseAuth.instance.currentUser?.delete().then((value) {
                    debugPrint("Account Deleted");
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInScreen()));
                  }).onError((error, stackTrace) {
                    debugPrint("Error ${error.toString()}");
                  });
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
