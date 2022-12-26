import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:provider/provider.dart';
import 'package:voice_prescription/blocs/auth.dart';
import 'package:voice_prescription/screens/auth/SignUp.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  Widget _buildPageContent(BuildContext context) {
    return Container(
      color: Colors.green.shade100,
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 30.0,
          ),
          CircleAvatar(
            child:
                // Center(child: Icon(Icons.medical_services)),
                Image.asset("assets/images/logo.png"),
            maxRadius: 50,
            backgroundColor: Colors.transparent,
          ),
          SizedBox(
            height: 20.0,
          ),
          _buildLoginForm(context),
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => SignupScreen()));
            }, //onPressed:
            child: Text("Sign Up",
                style: TextStyle(color: Colors.green, fontSize: 18.0)),
          )
        ],
      ),
    );
  }

  Container _buildLoginForm(BuildContext context) {
    String email;
    String password;
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: RoundedDiagonalPathClipper(),
            child: Container(
              height: 400,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                color: Colors.white,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 90.0,
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Colors.green),
                          decoration: InputDecoration(
                              hintText: "Email address",
                              hintStyle:
                                  TextStyle(color: Colors.green.shade200),
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.email,
                                color: Colors.green,
                              )),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter an email address';
                            } else if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value.trim())) {
                              return "Please enter a valid emial address";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            email = value;
                          },
                        )),
                    Container(
                      child: Divider(
                        color: Colors.green.shade400,
                      ),
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 10.0),
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          style: TextStyle(color: Colors.green),
                          decoration: InputDecoration(
                              hintText: "Password",
                              hintStyle:
                                  TextStyle(color: Colors.green.shade200),
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.lock,
                                color: Colors.green,
                              )),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter password';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            password = value;
                          },
                        )),
                    Container(
                      child: Divider(
                        color: Colors.green.shade400,
                      ),
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 10.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(right: 20.0),
                            child: Text(
                              "Forgot Password",
                              style: TextStyle(color: Colors.black45),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.green.shade600,
                child: Icon(
                  Icons.medical_services,
                  size: 40,
                ),
              ),
            ],
          ),
          Container(
            height: 420,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    final auth =
                        Provider.of<AuthServices>(context, listen: false);
                    log("Here we go");
                    try {
                      await auth.login(email, password);
                    } catch (e) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("OK"))
                          ],
                          content: Text(e.message),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(
                    color: Colors.green,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0)),
                ),
                child: SizedBox(
                  width: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Login", style: TextStyle(color: Colors.white70)),
                      Icon(
                        Icons.login,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPageContent(context),
    );
  }
}
