import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_prescription/blocs/auth.dart';
import 'package:voice_prescription/modals/user.dart';
// import 'package:voice_prescription/screens/complete_profile.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  String oPassword;
  String nPassword;

  bool enabled = true;
  bool opened = false;

  @override
  void initState() {
    opened = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthServices authServices =
        Provider.of<AuthServices>(context, listen: false);
    UserModal user = authServices.user;
    if ((user.age == null || user.gender == null) &&
        authServices.stackIndex == 2 &&
        !opened) {
      opened = true;
      // SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      //   // return CompleteProfile();
      //   await showModalBottomSheet<void>(
      //     context: context,
      //     isScrollControlled: true,
      //     builder: (BuildContext context) {
      //       return CompleteProfile();
      //     },
      //   );
      //   opened = false;
      // });
    }

    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ProfileHeader(
                avatar: AssetImage("assets/images/avatar.png"),
                // NetworkImage(
                //     "https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F1.jpg?alt=media"),
                coverImage:
                    // AssetImage("assets/images/banner.jpg"),
                    NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F2.jpg?alt=media"),
                title: user.name,
                subtitle: user.isPatient ? "Patient" : "Doctor",
                actions: <Widget>[
                  MaterialButton(
                    color: Colors.white,
                    shape: CircleBorder(),
                    elevation: 0,
                    child: Icon(Icons.edit),
                    onPressed: () {},
                  )
                ],
              ),
              const SizedBox(height: 10.0),
              buildUserInfo(user),
              buildAccount(context, authServices),
            ],
          ),
        ));
  }

  Widget buildUserInfo(UserModal user) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
            alignment: Alignment.topLeft,
            child: Text(
              "User Information",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Card(
            child: Container(
              child: Column(
                children: <Widget>[
                  ...ListTile.divideTiles(
                    color: Colors.grey,
                    tiles: [
                      if (user.gender != null)
                        ListTile(
                          leading: Icon(Icons.accessibility_new),
                          title: Text("Gender"),
                          subtitle: Text(user.gender.toString()),
                        ),
                      ListTile(
                        leading: Icon(Icons.email),
                        title: Text("Email"),
                        subtitle: Text(user.email.toString()),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text("Phone"),
                        subtitle: Text(user.phoneNumber.toString()),
                      ),
                      if (user.age != null)
                        ListTile(
                          leading: Icon(Icons.date_range),
                          title: Text("Age"),
                          subtitle: Text(user.age.toString()),
                        ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildAccount(context, AuthServices authServices) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
            alignment: Alignment.topLeft,
            child: Text(
              "User Settings",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Card(
            child: Container(
              child: Column(
                children: <Widget>[
                  ...ListTile.divideTiles(
                    color: Colors.grey,
                    tiles: [
                      ListTile(
                        leading: Icon(Icons.lock),
                        title: Text("Change Password"),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              actions: [
                                TextButton(
                                  onPressed: enabled
                                      ? () async {
                                          setState(() {
                                            enabled = false;
                                          });
                                          if (_formKey.currentState
                                              .validate()) {
                                            _formKey.currentState.save();
                                            try {
                                              await authServices.changePassword(
                                                  oPassword, nPassword);
                                              setState(() {
                                                enabled = true;
                                              });
                                              _formKey.currentState.reset();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Password changed")));
                                              Navigator.pop(context);
                                            } catch (e) {
                                              print(e);
                                            }
                                            enabled = true;
                                          }
                                        }
                                      : null,
                                  child: Text("OK"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("CANCEL"),
                                ),
                              ],
                              title: Text("Change password"),
                              content: ListView(
                                shrinkWrap: true,
                                children: [
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(bottom: 16.0),
                                          child: TextFormField(
                                            style:
                                                TextStyle(color: Colors.green),
                                            decoration: InputDecoration(
                                              hintText: "Old password",
                                              hintStyle: TextStyle(
                                                  color: Colors.green.shade200),
                                            ),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Please enter your old password';
                                              }
                                              return null;
                                            },
                                            onSaved: (value) {
                                              oPassword = value;
                                            },
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(bottom: 16.0),
                                          child: TextFormField(
                                            style:
                                                TextStyle(color: Colors.green),
                                            decoration: InputDecoration(
                                              hintText: "New passsword",
                                              hintStyle: TextStyle(
                                                  color: Colors.green.shade200),
                                            ),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Please enter new password';
                                              }
                                              nPassword = value;
                                              return null;
                                            },
                                            onSaved: (value) {
                                              nPassword = value;
                                            },
                                          ),
                                        ),
                                        Container(
                                          child: TextFormField(
                                            style:
                                                TextStyle(color: Colors.green),
                                            decoration: InputDecoration(
                                              hintText: "Confirm passsword",
                                              hintStyle: TextStyle(
                                                  color: Colors.green.shade200),
                                            ),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Please confirm your password';
                                              }
                                              if (value != nPassword) {
                                                return 'Password mismatch';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.delete),
                        title: Text("Delete Account"),
                        onTap: () async {
                          if (await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                      },
                                      child: Text("CANCEL")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: Text("OK")),
                                ],
                                content: Text(
                                    "Are you sure want to delete your account and logout?")),
                          )) {
                            try {
                              authServices.deleteAccount();
                            } catch (e) {
                              print(e);
                            }
                          }
                        },
                      ),
                      ListTile(
                          leading: Icon(Icons.logout),
                          title: Text("Logout"),
                          onTap: () async {
                            await authServices.logout();
                          }),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final ImageProvider<dynamic> coverImage;
  final ImageProvider<dynamic> avatar;
  final String title;
  final String subtitle;
  final List<Widget> actions;

  const ProfileHeader(
      {Key key,
      @required this.coverImage,
      @required this.avatar,
      @required this.title,
      this.subtitle,
      this.actions})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Ink(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(image: coverImage, fit: BoxFit.cover),
          ),
        ),
        Ink(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black38,
          ),
        ),
        if (actions != null)
          Container(
            width: double.infinity,
            height: 200,
            padding: const EdgeInsets.only(bottom: 0.0, right: 0.0),
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            ),
          ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 160),
          child: Column(
            children: <Widget>[
              Avatar(
                image: avatar,
                radius: 40,
                backgroundColor: Theme.of(context).primaryColor,
                borderColor: Colors.grey.shade300,
                borderWidth: 4.0,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.headline6,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 5.0),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ]
            ],
          ),
        )
      ],
    );
  }
}

class Avatar extends StatelessWidget {
  final ImageProvider<dynamic> image;
  final Color borderColor;
  final Color backgroundColor;
  final double radius;
  final double borderWidth;

  const Avatar(
      {Key key,
      @required this.image,
      this.borderColor = Colors.grey,
      this.backgroundColor,
      this.radius = 30,
      this.borderWidth = 5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius + borderWidth,
      backgroundColor: borderColor,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor != null
            ? backgroundColor
            : Theme.of(context).primaryColor,
        child: CircleAvatar(
          radius: radius - borderWidth,
          backgroundImage: image,
        ),
      ),
    );
  }
}
