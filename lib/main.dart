// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_prescription/blocs/auth.dart';
import 'package:voice_prescription/blocs/patient.dart';
import 'package:voice_prescription/firebase_options.dart';
import 'package:voice_prescription/modals/user.dart';
import 'package:voice_prescription/screens/app.dart';
import 'package:voice_prescription/screens/auth/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //await for startup works here.
  // Future.delayed(const Duration(seconds: 1), () {});
  runApp(MultiProvider(providers: [
    Provider.value(value: AuthServices()),
    Provider.value(value: PatientServices()),
  ], child: MyApp()));
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Prescription',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeApp(),
    );
  }
}

class HomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthServices authServices =
        Provider.of<AuthServices>(context, listen: false);
    return StreamBuilder<User>(
      // Initialize FlutterFire
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User> snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container(
              color: Colors.red,
              child: Center(child: Text(snapshot.error.toString())));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          // Otherwise, show something whilst waiting for initialization to complete
          return Container(
            color: Colors.green[200],
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        // Once complete, show your application
        if (snapshot.hasData) {
          if (authServices.user == null) {
            return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection("users")
                    .doc(snapshot.data.uid)
                    .get(),
                builder: (context, iSnapshot) {
                  if (iSnapshot.hasData) {
                    authServices.user =
                        UserModal.fromMap(iSnapshot.data?.data());
                    return AppScreen(uid: snapshot.data.uid);
                  }
                  return Container(
                    color: Colors.green[200],
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                });
          }
          return AppScreen(uid: snapshot.data.uid);
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
