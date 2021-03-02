class SignUpRequest {
  String firstName;
  String lastName;
  String dob;
  String gender;
  String email;
  String password;
  String fullName;
  String username;


  SignUpRequest(
      {this.firstName,
        this.lastName,
        this.dob,
        this.gender,
        this.email,
        this.password,this.username,this.fullName});

  SignUpRequest.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    dob = json['dob'];
    gender = json['gender'];
    email = json['email'];
    password = json['password'];
    fullName= json['name'];
    username= json['username'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['email'] = this.email;
    data['password'] = this.password;
    data['name']= this.fullName;
    data['username']= this.username;

    return data;
  }
}