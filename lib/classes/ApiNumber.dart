class ApiNumber {
  final int value;

  ApiNumber({this.value});

  factory ApiNumber.fromJson(Map<String, dynamic> json){
    return ApiNumber(
      value: json['value'] 
    );
  }
}