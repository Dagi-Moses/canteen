// ignore_for_file: public_member_api_docs, sort_constructors_first


class PayStackAuthResponse {
  final String authUrl;
  final String accessCode;
  final String reference;

  PayStackAuthResponse(
      {required this.authUrl,
      required this.accessCode,
      required this.reference});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'authorization_url': authUrl,
      'access_code': accessCode,
      'reference': reference,
    };
  }

  factory PayStackAuthResponse.fromJson(Map<String, dynamic> map) {
    return PayStackAuthResponse(
      authUrl: map['authorization_url'] as String,
      accessCode: map['access_code'] as String,
      reference: map['reference'] as String,
    );
  }
}
