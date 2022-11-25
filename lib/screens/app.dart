import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_prescription/blocs/auth.dart';
import 'package:voice_prescription/screens/diseases.dart';
import 'package:voice_prescription/screens/doctor_board.dart';
import 'package:voice_prescription/screens/patient_board.dart';
import 'package:voice_prescription/screens/profile.dart';

class AppScreen extends StatefulWidget {
  final String uid;
  AppScreen({this.uid});
  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  AuthServices authServices;
  @override
  void initState() {
    super.initState();
    authServices = Provider.of<AuthServices>(context, listen: false);
    authServices.stackIndex = 0;
  }
  // Page Storage Bucket
  // final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = <Widget>[
      DiseasesScreen(),
      authServices.user.isPatient ? PatientBoard() : DoctorBoard(),
      ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Voice Prescription'),
        // actions: [
        //   TextButton(
        //       child: Text(
        //         "Logout",
        //         style: TextStyle(color: Colors.white),
        //       ),
        //       onPressed: () {
        //         FirebaseAuth.instance.signOut();
        //       })
        // ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - 142.0,
        child: IndexedStack(
          index: authServices.stackIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: authServices.stackIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.apps), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: (int index) {
          setState(() {
            authServices.stackIndex = index;
          });
        },
      ),
    );
  }
}
