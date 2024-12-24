
class CityResponseModel{
  final String name;
  final String countryCode;
  final String stateCode;
  final String latitude;
  final String longitude;



  CityResponseModel({
    required this.name,
    required this.countryCode,
    required this.stateCode,
    required this.latitude,
    required this.longitude});

  factory CityResponseModel.fromJson(Map<String, dynamic> json) {
    return CityResponseModel(
      name : json['name'],
      countryCode : json['countryCode'],
      stateCode : json['stateCode'],
      latitude : json['latitude'],
      longitude : json['longitude'],
     );
    }
  }


