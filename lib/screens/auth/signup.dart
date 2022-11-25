import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:provider/provider.dart';
import 'package:voice_prescription/blocs/auth.dart';
import 'package:voice_prescription/modals/user.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var isSelected = [true, false];
  // var textController = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool enabled = true;

  UserModal user = UserModal();
  Widget _buildPageContent(BuildContext context) {
    return Container(
      color: Colors.green.shade100,
      child: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              FloatingActionButton(
                mini: true,
                onPressed: () {
                  Navigator.pop(context);
                },
                backgroundColor: Colors.green,
                child: Icon(Icons.arrow_back),
              )
            ],
          ),
          CircleAvatar(
            child:
                // Center(child: Icon(Icons.medical_services)),
                Image.asset("assets/images/logo.png"),
            maxRadius: 50,
            backgroundColor: Colors.transparent,
          ),
          _buildLoginForm(),
        ],
      ),
    );
  }

  Container _buildLoginForm() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: RoundedDiagonalPathClipper(),
            child: Container(
              height: 550,
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
                          style: TextStyle(color: Colors.green),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            user.name = value;
                          },
                          decoration: InputDecoration(
                              hintText: "Name",
                              hintStyle:
                                  TextStyle(color: Colors.green.shade200),
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.person,
                                color: Colors.green,
                              )),
                        )),
                    Container(
                      child: Divider(
                        color: Colors.green.shade400,
                      ),
                      padding:
                          EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0.0),
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          style: TextStyle(color: Colors.green),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a phone number';
                            } else if (value.length < 10) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            user.phoneNumber = value;
                          },
                          decoration: InputDecoration(
                              hintText: "Phone Number",
                              hintStyle:
                                  TextStyle(color: Colors.green.shade200),
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.call,
                                color: Colors.green,
                              )),
                        )),
                    Container(
                      child: Divider(
                        color: Colors.green.shade400,
                      ),
                      padding:
                          EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0.0),
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          style: TextStyle(color: Colors.green),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter email address';
                            } else if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value.trim())) {
                              return 'Please enter valid email address';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            user.email = value;
                          },
                          decoration: InputDecoration(
                              hintText: "Email address",
                              hintStyle:
                                  TextStyle(color: Colors.green.shade200),
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.email,
                                color: Colors.green,
                              )),
                        )),
                    Container(
                      child: Divider(
                        color: Colors.green.shade400,
                      ),
                      padding:
                          EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0.0),
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter password';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            user.password = value;
                          },
                          controller: _pass,
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
                        )),
                    Container(
                      child: Divider(
                        color: Colors.green.shade400,
                      ),
                      padding:
                          EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0.0),
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter password';
                            } else if (value != _pass.text) {
                              return 'Password doesn\'t match';
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.green),
                          decoration: InputDecoration(
                              hintText: "Confirm password",
                              hintStyle:
                                  TextStyle(color: Colors.green.shade200),
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.lock,
                                color: Colors.green,
                              )),
                        )),
                    Container(
                      child: Divider(
                        color: Colors.green.shade400,
                      ),
                      padding:
                          EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0.0),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: ToggleButtons(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Icon(Icons.person),
                                Text("As Patient"),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Icon(Icons.medical_services),
                                Text("As Doctor")
                              ],
                            ),
                          ),
                        ],
                        onPressed: (int index) {
                          print(isSelected.length);
                          setState(() {
                            for (int buttonIndex = 0;
                                buttonIndex < isSelected.length;
                                buttonIndex++) {
                              if (buttonIndex == index) {
                                isSelected[buttonIndex] = true;
                              } else {
                                isSelected[buttonIndex] = false;
                              }
                            }
                          });
                        },
                        isSelected: isSelected,
                      ),
                    ),
                    Container(
                      child: Divider(
                        color: Colors.green.shade400,
                      ),
                      padding:
                          EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0.0),
                    ),

                    // SizedBox(
                    //   height: 10.0,
                    // ),
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
                  Icons.person_add_alt_1,
                  size: 40,
                ),
              ),
            ],
          ),
          Container(
            height: 572,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: enabled
                    ? () async {
                        setState(() {
                          enabled = enabled ? false : true;
                        });
                        _formKey.currentState.validate();
                        if (isSelected[0]) {
                          user.isPatient = true;
                        } else {
                          user.isPatient = false;
                        }
                        _formKey.currentState.save();
                        AuthServices auth =
                            Provider.of<AuthServices>(context, listen: false);
                        try {
                          await auth.signup(user);
                          setState(() {
                            enabled = enabled ? false : true;
                          });
                          Navigator.pop(context);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            print('The password provided is too weak.');
                          } else if (e.code == 'email-already-in-use') {
                            print('The account already exists for that email.');
                          }
                        } catch (e) {
                          print(e);
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(
                    color: Colors.green,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0)),
                ),
                child: Text("Sign Up", style: TextStyle(color: Colors.white70)),
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
