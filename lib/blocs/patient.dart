import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voice_prescription/modals/disease.dart';

class PatientServices {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  PatientServices();

  Future<void> addDisease(DiseaseModal disease) {
    disease.did = Timeline.now.toString();
    return _fireStore
        .collection("diseases")
        .doc(disease.did)
        .set(disease.toMap());
  }

  getDiseases({bool diagnosed, String puid, String duid}) {
    if (puid != null) {
      return _fireStore
          .collection("diseases")
          .where("puid", isEqualTo: puid)
          .snapshots();
    }
    if (diagnosed != null) {
      return _fireStore
          .collection("diseases")
          .where("diagnosed", isEqualTo: diagnosed)
          .snapshots();
    }
    return _fireStore.collection("diseases").snapshots();
  }

  makePrescription(DiseaseModal disease) async {
    return _fireStore.collection("diseases").doc(disease.did).update({
      "diagnosed": true,
      "duid": disease.duid,
      "prescribedBy": disease.prescribedBy,
      "prescription": disease.prescription
    });
  }

  removeDisease(String did) async {
    return await _fireStore.collection("diseases").doc(did).delete();
  }
}
