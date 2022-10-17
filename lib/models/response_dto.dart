class ResponseDTO {

  final dynamic data;
  final dynamic message;
  final dynamic error;
  final dynamic total;
  final dynamic statusCode;
  final dynamic metaData;

  ResponseDTO({
    required this.data,
    required this.message,
    required this.error,
    required this.total,
    required this.statusCode,
    required this.metaData
  });

  factory ResponseDTO.fromJson(Map<String, dynamic> json) {
    return ResponseDTO(data: json['data'], message: json['message'], error: json['error'], total: json['total'], statusCode: json['statusCode'], metaData: json['metaData']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'data': data,
      'message': message,
      'error': error,
      'total': total,
      'statusCode': statusCode,
      'metaData': metaData
    };
    return map;
  }

}