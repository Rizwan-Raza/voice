import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_prescription/blocs/auth.dart';
import 'package:voice_prescription/blocs/patient.dart';
import 'package:voice_prescription/modals/disease.dart';
import 'package:voice_prescription/modals/user.dart';

class DiagnoseScreen extends StatefulWidget {
  final DiseaseModal disease;
  DiagnoseScreen({this.disease, Key key}) : super(key: key);
  @override
  _DiagnoseScreenState createState() => _DiagnoseScreenState();
}

class _DiagnoseScreenState extends State<DiagnoseScreen> {
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = '';
  int resultListened = 0;
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (!_hasSpeech) {
      initSpeechState();
    }
  }

  Future<void> initSpeechState() async {
    var hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener, debugLogging: true);
    if (hasSpeech) {
      _localeNames = await speech.locales();

      // var systemLocale = await speech.systemLocale();
      // _currentLocaleId = systemLocale.localeId;
      _currentLocaleId = "en_IN";
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  @override
  Widget build(BuildContext context) {
    var enabled = true;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make Prescription'),
      ),
      body: Container(
        child: Column(children: [
          // Center(
          //   child: Text(
          //     'Speech recognition available',
          //     style: TextStyle(fontSize: 22.0),
          //   ),
          // ),
          Container(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    // TextButton(
                    //   child: Text('Start'),
                    //   onPressed: null
                    // ),
                    TextButton(
                      child: Text('Stop'),
                      onPressed: speech.isListening ? stopListening : null,
                    ),
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: speech.isListening ? cancelListening : null,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    DropdownButton(
                      onChanged: (selectedVal) => _switchLang(selectedVal),
                      value: _currentLocaleId,
                      items: _localeNames
                          .map(
                            (localeName) => DropdownMenuItem(
                              value: localeName.localeId,
                              child: Text(localeName.name),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: <Widget>[
                // Text(
                //   'Prescription made',
                //   style: TextStyle(fontSize: 22.0),
                // ),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        color: Theme.of(context).selectedRowColor,
                        child: Center(
                          child: Text(
                            lastWords,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        bottom: 10,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 80,
                            height: 80,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: .26,
                                    spreadRadius: level * 1.5,
                                    color: Colors.black.withOpacity(.05))
                              ],
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(80)),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.mic),
                              iconSize: 40.0,
                              onPressed: !_hasSpeech || speech.isListening
                                  ? null
                                  : startListening,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: <Widget>[
                // Center(
                //   child: Text(
                //     'Error Status',
                //     style: TextStyle(fontSize: 22.0),
                //   ),
                // ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          textStyle: TextStyle(
                            color: Colors.white,
                          )),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            actions: [
                              TextButton(
                                  onPressed: enabled
                                      ? () async {
                                          if (formKey.currentState.validate()) {
                                            formKey.currentState.save();
                                            setState(() {
                                              enabled = false;
                                            });
                                            UserModal user =
                                                await Provider.of<AuthServices>(
                                                        context,
                                                        listen: false)
                                                    .user;
                                            widget.disease.duid = user.uid;
                                            widget.disease.prescribedBy =
                                                user.name;
                                            widget.disease.prescription =
                                                lastWords.replaceAll(
                                                    "\n\n", " *-*-*");
                                            await Provider.of<PatientServices>(
                                                    context,
                                                    listen: false)
                                                .makePrescription(
                                                    widget.disease);
                                            print("Prescription Made ----- ");
                                            setState(() {
                                              enabled = true;
                                            });
                                            //
                                            Navigator.pop(context);
                                            Navigator.pop(context, sendSMS());
                                          }
                                        }
                                      : null,
                                  child: Text("OK"))
                            ],
                            content: Form(
                              key: formKey,
                              child: TextFormField(
                                initialValue: lastWords,
                                maxLines: 10,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter prescription';
                                  }
                                  return null;
                                },
                                onSaved: (String value) {
                                  lastWords = value;
                                },
                              ),
                            ),
                          ),
                        );
                      },
                      child: Text("Make Prescription"),
                    ),
                  ),
                ),
                Center(
                  child: Text(lastError),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            color: Theme.of(context).backgroundColor,
            child: Center(
              child: speech.isListening
                  ? Text(
                      "I'm listening...",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : Text(
                      'Not listening',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ]),
      ),
    );
  }

  void startListening() {
    lastWords = '';
    lastError = '';
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(minutes: 3),
        pauseFor: Duration(minutes: 3),
        partialResults: false,
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
    setState(() {});
  }

  void stopListening() {
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    ++resultListened;
    print('Result listener $resultListened');
    setState(() {
      // lastWords = '${result.recognizedWords} - ${result.finalResult}';
      lastWords = result.recognizedWords;
      lastWords = lastWords.replaceAll(" and ", "\n\n");
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // print("sound level $level: $minSoundLevel - $maxSoundLevel ");
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    // print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      lastError = '${error.errorMsg} - ${error.permanent}';
    });
  }

  void statusListener(String status) {
    // print(
    // 'Received listener status: $status, listening: ${speech.isListening}');
    setState(() {
      lastStatus = '$status';
    });
  }

  void _switchLang(selectedVal) {
    setState(() {
      _currentLocaleId = selectedVal;
    });
    print(selectedVal);
  }

  Future<Map<String, dynamic>> sendSMS() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Sending SMS..."),
      ),
    );
    print(widget.disease.user.phoneNumber);
    widget.disease.diagnoseDate =
        DateFormat('dd-MM-yyyy – kk:mm').format(DateTime.now());
    String dr = widget.disease.prescribedBy;
    if (!dr.startsWith("Dr. ")) {
      dr = "Dr. $dr";
    }
    http.Response response = await http.post(
      Uri.parse("https://www.fast2sms.com/dev/bulkV2"),
      body: jsonEncode({
        "route": "q",
        "message":
            "Dear ${widget.disease.user.name},\nYour ${widget.disease.disease} has been diagnosed by $dr on ${widget.disease.diagnoseDate}. Please check our app for more details.",
        "language": "unicode",
        "flash": 0,
        "numbers": widget.disease.user.phoneNumber,
      }),
      headers: {
        "authorization":
            "zImEfRA1ZSaGNCr64kH3yitVYLTwvu5Dx7KneMPpQXU09WJlOgYcXol1w0KILPaMTi8SUgCAN36kErpb",
        "Content-Type": "application/json"
      },
    );

    // .then((http.Response response) {
    // });

    // http.Response response = await http.post(
    //   Uri.parse("https://api.textlocal.in/send/"),
    //   body: {
    //     "apikey": "NTE0MzQ2NGM2YzRjNTE2ZDc4NzQ1MzU1NGI2ZDMwNDM=",
    //     "numbers": disease.user.phoneNumber,
    //     "message":
    //         "Your ${disease.disease} has been diagnosed by ${disease.prescribedBy} on ${disease.diagnoseDate}. Please check your app.",
    //     "sender": "TXTLCL"
    //   },
    // );
    return (jsonDecode(response.body) as Map<String, dynamic>);
  }
}
