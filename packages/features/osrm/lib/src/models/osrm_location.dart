class OsrmLocation {
  final double longitude;
  final double latitude;

  const OsrmLocation({
    required this.longitude,
    required this.latitude,
  });

  Map<String, dynamic> toJson() => {
        'longitude': longitude,
        'latitude': latitude,
      };

  factory OsrmLocation.fromJson(Map<String, dynamic> json) => OsrmLocation(
        longitude: json['longitude']?.toDouble() ?? 0.0,
        latitude: json['latitude']?.toDouble() ?? 0.0,
      );
}
