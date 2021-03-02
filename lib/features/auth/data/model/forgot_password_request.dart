

class ForgotPasswordRequest {
  String email;
  String password;
  String  kind;
  String resetCode;

  ForgotPasswordRequest(
      {this.email,
        this.password,this.kind,this.resetCode});

  ForgotPasswordRequest.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    resetCode=json['resetCode'];
    kind=json['kind'];
  }




  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    if(this.password!=null){
      data['password'] = this.password;
    }
    if(this.resetCode!=null){
      data['resetCode'] = this.resetCode;
    }
    if(this.kind!=null){
      data['kind'] = this.kind;
    }
    return data;
  }
}