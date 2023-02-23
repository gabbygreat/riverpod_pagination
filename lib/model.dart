class PaginationModel {
  int page;
  late int total;
  PaginationModel({this.total = 100, this.page = 0});
}

class AirlineModel {
  final String country;
  final String logo;
  final String slogan;

  AirlineModel({
    required this.country,
    required this.logo,
    required this.slogan,
  });

  static AirlineModel fromJson(Map<String, dynamic> data) => AirlineModel(
        country: data['country'],
        logo: data['logo'],
        slogan: data['slogan'],
      );
}

class AirPlaneModel {
  final String id;
  final AirlineModel airlineModel;
  AirPlaneModel({required this.airlineModel, required this.id});

  static AirPlaneModel fromJson(Map<String, dynamic> data) => AirPlaneModel(
        id: data['_id'],
        airlineModel: AirlineModel.fromJson(data['airline'][0]),
      );
}
