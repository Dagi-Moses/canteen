class GeoPoin {
  final dynamic latitude;
  final dynamic longitude;
  GeoPoin(this.latitude, this.longitude);

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };
  factory GeoPoin.fromJson(Map<String, dynamic> json) {
    return GeoPoin(
      json['latitude'],
      json['longitude'],
    );
  }
}
