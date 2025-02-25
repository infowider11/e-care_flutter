// ignore_for_file: non_constant_identifier_names

class FlutterPayStackInitializeTransactionResponseModal{
  String authorization_url;
  String access_code;
  String reference;
  bool success;
  String message;

  FlutterPayStackInitializeTransactionResponseModal({
   required this.authorization_url,
    required this.access_code,
    required this.reference,
    required this.success,
    required this.message
  });

  factory FlutterPayStackInitializeTransactionResponseModal.fromJson(Map data, bool success, String message){
    return FlutterPayStackInitializeTransactionResponseModal(authorization_url: data['authorization_url'], access_code: data['access_code'], reference: data['reference'], success: success, message: message);
  }
}