import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:voice_prescription/modals/disease.dart';

class PrescriptionScreen extends StatefulWidget {
  final DiseaseModal disease;
  @override
  _PrescriptionScreenState createState() => _PrescriptionScreenState();

  PrescriptionScreen({this.disease});
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  File pdf;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prescription"),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    Text(
                      widget.disease.user.name ?? "Patient Name",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Age",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    Text(
                      widget.disease.user.age ?? "NA",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Date",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    Text(
                      widget.disease.diagnoseDate.split("T").first ?? "NA",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text("Disease",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold)),
                    Text(
                      ": ${widget.disease.disease}",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                SizedBox(height: 24.0),
                Row(
                  children: [
                    Text("Suffering since",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold)),
                    Text(
                      ": ${widget.disease.kabSeH}",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              // color: Colors.grey[300],
              child: Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.grey[300],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Drugs Name",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Flexible(
                      // height: 200,
                      child: ListView(
                        // physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: widget.disease.prescription
                            .split(" *-*-*")
                            .map((element) => ListTile(
                                  leading: Icon(Icons.check),
                                  title: Text(element),
                                ))
                            .toList(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) async {
          switch (value) {
            case 0:
              await getPDF();
              OpenFile.open(this.pdf.path);
              break;
            case 1:
              await getPDF();
              Share.shareFiles([this.pdf.path], text: widget.disease.disease);
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.download), label: "Download"),
          BottomNavigationBarItem(icon: Icon(Icons.share), label: "Share")
        ],
      ),
    );
  }

  Future<File> getPDF() async {
    if (this.pdf == null) {
      final pdf = pw.Document(
          theme: pw.ThemeData(
              defaultTextStyle: pw.TextStyle(
                  font: pw.Font.ttf(
                      await rootBundle.load("assets/OpenSans-Regular.ttf")))));

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(children: [
            pw.Header(text: "Voice based Prescription"),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(vertical: 24.0),
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text("Prescribed By: Dr. ${widget.disease.prescribedBy}",
                        style: pw.TextStyle(fontSize: 18.0))
                  ]),
            ),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("Name",
                            style: pw.TextStyle(
                                fontSize: 18.0,
                                fontWeight: pw.FontWeight.bold)),
                        pw.Text(widget.disease.user.name ?? " NA",
                            style: pw.TextStyle(fontSize: 20.0)),
                      ]),
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("Age",
                            style: pw.TextStyle(
                                fontSize: 18.0,
                                fontWeight: pw.FontWeight.bold)),
                        pw.Text(widget.disease.user.age.toString() ?? "NA",
                            style: pw.TextStyle(fontSize: 20.0)),
                      ]),
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("Date",
                            style: pw.TextStyle(
                                fontSize: 18.0,
                                fontWeight: pw.FontWeight.bold)),
                        pw.Text(
                            widget.disease.diagnoseDate.split(" ").first ??
                                "NA",
                            style: pw.TextStyle(fontSize: 20.0)),
                      ]),
                ]),
            pw.SizedBox(height: 24.0),
            pw.Column(
              children: [
                pw.Row(
                  children: [
                    pw.Text("Disease",
                        style: pw.TextStyle(
                            fontSize: 18.0, fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                      ": ${widget.disease.disease}",
                      style: pw.TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
                pw.SizedBox(height: 24.0),
                pw.Row(
                  children: [
                    pw.Text("Suffering since",
                        style: pw.TextStyle(
                            fontSize: 18.0, fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                      ": ${widget.disease.kabSeH}",
                      style: pw.TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 24.0),
            pw.Expanded(
              child: pw.Container(
                padding: pw.EdgeInsets.all(16.0),
                color: PdfColors.grey300,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  children: [
                    pw.Text(
                      "Drugs Name",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 18.0),
                    ),
                    pw.SizedBox(
                      height: 16.0,
                    ),
                    pw.Flexible(
                      // height: 200,
                      child: pw.ListView(
                        // physics: ,
                        children: widget.disease.prescription
                            .split(" *-*-*")
                            .map((element) => pw.Row(
                                  children: [
                                    // pw.Icon(pw.IconData(0xe156)),
                                    pw.Text("•",
                                        style: pw.TextStyle(fontSize: 20.0)),
                                    pw.SizedBox(width: 16.0),
                                    pw.Text(element,
                                        style: pw.TextStyle(fontSize: 18.0)),
                                  ],
                                ))
                            .toList(),
                      ),
                    )
                  ],
                ),
              ),
            )
          ]),
        ),
      );

      if ((await Permission.storage.request()).isGranted) {
        Directory appDocDirectory = await getExternalStorageDirectory();
        File file = File(
            '${appDocDirectory.path}/${widget.disease.disease}_${widget.disease.kabSeH}.pdf');

        file = await file.writeAsBytes(await pdf.save());

        this.pdf = file;
      }
    }
    return this.pdf;
  }
}
