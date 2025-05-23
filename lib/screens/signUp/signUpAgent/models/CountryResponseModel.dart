
class CountryResponseModel{
  final String name;
  final String isoCode;
  final String flag;
  final String phoneCode;
  final String currency;

  CountryResponseModel({
    required this.name,
    required this.isoCode,
    required this.flag,
    required this.phoneCode,
    required this.currency});

  factory CountryResponseModel.fromJson(Map<String, dynamic> json) {
    return CountryResponseModel(
      name : json['name'],
      isoCode : json['isoCode'],
      flag : json['flag'],
      phoneCode : json['phonecode'],
      currency : json['currency'],
     );
    }
  }


