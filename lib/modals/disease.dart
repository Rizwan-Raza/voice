import 'package:voice_prescription/modals/user.dart';

class DiseaseModal {
  DiseaseModal();

  String did;
  String puid;
  String duid;
  String disease;
  String kabSeH;
  bool diagnosed;
  String prescription;
  String prescribedBy;
  String diagnoseDate;
  UserModal user;

  DiseaseModal.fromMap(Map<String, Object> map) {
    this.did = map['did'];
    this.puid = map['puid'];
    this.duid = map['duid'];
    this.disease = map['disease'];
    this.kabSeH = map['kabSeH'];
    this.diagnoseDate = map['diagnoseDate'];
    this.diagnosed = map['diagnosed'];
    this.prescription = map['prescription'];
    this.prescribedBy = map['prescribedBy'];
    this.user = UserModal.fromMap(map['user']);
  }

  Map<String, Object> toMap() {
    return {
      "did": this.did,
      "puid": this.puid,
      "duid": this.duid,
      "disease": this.disease,
      "kabSeH": this.kabSeH,
      "diagnoseDate": this.diagnoseDate,
      "diagnosed": this.diagnosed,
      "prescription": this.prescription,
      "prescribedBy": this.prescribedBy,
      "user": this.user.toMap(),
    };
  }
}
