class UserModal {
  String uid;
  String name;
  String phoneNumber;
  String email;
  String password;
  int age;
  bool isPatient;
  String gender;
  UserModal();

  // UserModal.parameterized(
  //     {this.uid,
  //     this.name,
  //     this.phoneNumber,
  //     this.email,
  //     this.password,
  //     this.isPatient,
  //     this.age,
  //     this.gender});

  UserModal.fromMap(Map<String, Object> map) {
    this.uid = map['uid'];
    this.name = map['name'];
    this.email = map['email'];
    this.phoneNumber = map['phoneNumber'];
    this.password = map['password'];
    this.isPatient = map['isPatient'];
    this.gender = map['gender'];
    this.age = map['age'];
  }

  Map<String, Object> toMap() {
    return {
      "uid": this.uid,
      "name": this.name,
      "phoneNumber": this.phoneNumber,
      "email": this.email,
      "password": this.password,
      "isPatient": this.isPatient,
      "age": this.age,
      "gender": this.gender,
    };
  }
}
