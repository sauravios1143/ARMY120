class ApiException implements Exception {
  String message ;
  toString (){
    return this.message;
  }
  ApiException({this.message});
}