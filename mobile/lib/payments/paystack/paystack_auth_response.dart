class PayStackAuthResponse {
  final String authorizationUrl;
  final String accessCode;
  final String reference;

  const PayStackAuthResponse({
    required this.accessCode,
    required this.authorizationUrl,
    required this.reference,
  });

  factory PayStackAuthResponse.fromJson(Map<String, dynamic> json) {
    return PayStackAuthResponse(
        accessCode: json['accessCode'],
        authorizationUrl: json['authorizationUrl'],
        reference: json['reference']);
  }

  Map<String, dynamic> toJson() {
    return {
      'authorizationUrl': authorizationUrl,
      'accessCode': accessCode,
      'reference': reference,
    };
  }
}
