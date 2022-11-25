import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_prescription/blocs/patient.dart';
import 'package:voice_prescription/modals/disease.dart';
// import 'package:voice_prescription/screens/diagnose.dart';

class DoctorBoard extends StatefulWidget {
  const DoctorBoard({Key key}) : super(key: key);

  @override
  _DoctorBoardState createState() => _DoctorBoardState();
}

class _DoctorBoardState extends State<DoctorBoard> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Provider.of<PatientServices>(context, listen: false)
            .getDiseases(diagnosed: false),
        builder: (context, sSnapshot) {
          if (sSnapshot.hasData) {
            List<dynamic> map = sSnapshot.data.docs;
            // return ListView.builder(itemBuilder: (_, index) {
            //   return ListTile(title: map[index].);
            // });
            if (map.length == 0) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.task_alt,
                      size: 48.0,
                      color: Colors.black54,
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    Text("No Diseases found"),
                  ],
                ),
              );
            }
            return Column(
              children: <Widget>[
                ...ListTile.divideTiles(
                  color: Colors.grey,
                  tiles: map.map((e) {
                    DiseaseModal disease = DiseaseModal.fromMap(e.data());
                    return ListTile(
                      onTap: () {
                        // Navigator.push<Future<Map<String, dynamic>>>(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) =>
                        //           DiagnoseScreen(disease: disease)),
                        // ).then((Future<Map<String, dynamic>> fut) {
                        //   fut.then((Map<String, dynamic> res) {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       SnackBar(
                        //         content: Text(res['message'][0]),
                        //         // content: Text(res['status']),
                        //       ),
                        //     );
                        //     print(res.toString());
                        //     Future.delayed(Duration(seconds: 3), () {
                        //       ScaffoldMessenger.of(context)
                        //           .hideCurrentSnackBar();
                        //     });
                        //   });
                        // });
                      },
                      leading: Icon(Icons.opacity),
                      title: Text(disease.disease),
                      isThreeLine: true,
                      subtitle: Text(disease.user.name.toString() +
                          "\n" +
                          disease.kabSeH.toString()),
                    );
                  }).toList(),
                ),
              ],
            );
            // return Text("Hello");
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
