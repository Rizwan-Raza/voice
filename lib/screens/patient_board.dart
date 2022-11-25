import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:voice_prescription/blocs/auth.dart';
import 'package:voice_prescription/blocs/patient.dart';
import 'package:voice_prescription/modals/disease.dart';
import 'package:voice_prescription/modals/user.dart';

class PatientBoard extends StatefulWidget {
  @override
  _PatientBoardState createState() => _PatientBoardState();
}

class _PatientBoardState extends State<PatientBoard> {
  final _formKey = GlobalKey<FormState>();

  bool enabled = true;

  TextEditingController _dateCtl = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2200));
    if (picked != null && picked != DateTime.now()) {
      _dateCtl.text = DateFormat('dd-MM-yyyy').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    DiseaseModal diseaseModal = DiseaseModal();
    AuthServices authServices =
        Provider.of<AuthServices>(context, listen: false);
    UserModal user = authServices.user;
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        ...ListTile.divideTiles(
          color: Colors.grey,
          tiles: [
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Add new Disease"),
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
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();

                                    diseaseModal.puid = user.uid;
                                    diseaseModal.user = user;
                                    diseaseModal.diagnosed = false;

                                    PatientServices patientServices =
                                        Provider.of<PatientServices>(context,
                                            listen: false);
                                    patientServices
                                        .addDisease(diseaseModal)
                                        .then((value) {
                                      setState(() {
                                        enabled = true;
                                      });
                                      _formKey.currentState.reset();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text("Disease added")));
                                      Navigator.pop(context);
                                    });
                                  } else {
                                    setState(() {
                                      enabled = true;
                                    });
                                  }
                                }
                              : null,
                          child: Text("OK"))
                    ],
                    title: Text("Add new disease"),
                    content: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            style: TextStyle(color: Colors.green),
                            decoration: InputDecoration(
                                hintText: "Disease",
                                hintStyle:
                                    TextStyle(color: Colors.green.shade200),
                                border: InputBorder.none,
                                icon: Icon(
                                  Icons.opacity,
                                  color: Colors.green,
                                )),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a disease';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              diseaseModal.disease = value;
                            },
                          ),
                          Divider(
                            color: Colors.green.shade400,
                          ),
                          InkWell(
                            onTap: () => _selectDate(context),
                            child: IgnorePointer(
                              child: TextFormField(
                                controller: _dateCtl,
                                style: TextStyle(color: Colors.green),
                                decoration: InputDecoration(
                                    hintText: "Since when?",
                                    hintStyle:
                                        TextStyle(color: Colors.green.shade200),
                                    border: InputBorder.none,
                                    icon: Icon(
                                      Icons.event,
                                      color: Colors.green,
                                    )),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter a date';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  diseaseModal.kabSeH = value;
                                },
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.green.shade400,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
