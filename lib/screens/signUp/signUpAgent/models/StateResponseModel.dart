
class StateResponseModel {
  final String name;
  final String isoCode;
  final String countryCode;
  final String latitude;
  final String longitude;


  StateResponseModel ({
    required this.name,
    required this.isoCode,
    required this.countryCode,
    required this.latitude,
    required this.longitude});

  factory StateResponseModel .fromJson(Map<String, dynamic> json) {
    return StateResponseModel (
      name : json['name'],
      isoCode : json['isoCode'],
      countryCode : json['countryCode'],
      latitude : json['latitude'],
      longitude : json['longitude'],
     );
    }
  }


