import 'package:equatable/equatable.dart';

class DirectGeocoding extends Equatable {
  final String name;
  final double lat;
  final double lon;
  final String country;

  const DirectGeocoding({
    required this.name,
    required this.lat,
    required this.lon,
    required this.country,
  });

  factory DirectGeocoding.fromJson(List<dynamic> json) {
    final Map<String, dynamic> data = json[0];

    return DirectGeocoding(
      name: data['name'] ?? '',
      lat: data['lat']?.toDouble() ?? 0.0,
      lon: data['lon']?.toDouble() ?? 0.0,
      country: data['country'] ?? '',
    );
  }

  @override
  List<Object> get props => [name, lat, lon, country];

  @override
  String toString() {
    return 'DirectGeocoding(name: $name, lat: $lat, lon: $lon, country: $country)';
  }
}


/*
weather api 에서 받아오는 정보는 기본적으로 json 형태이기 때문에 편하게 사용하기 위해 모델로 만듦

*/