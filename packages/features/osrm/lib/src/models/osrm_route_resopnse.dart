class OsrmRouteResponse {
  final String code;
  final List<OsrmRoute>? routes;
  final List<OsrmWaypoint>? waypoints;

  const OsrmRouteResponse({
    required this.code,
    this.routes,
    this.waypoints,
  });

  factory OsrmRouteResponse.fromJson(Map<String, dynamic> json) =>
      OsrmRouteResponse(
        code: json['code'] ?? '',
        routes: (json['routes'] as List?)
            ?.map((e) => OsrmRoute.fromJson(e))
            .toList(),
        waypoints: (json['waypoints'] as List?)
            ?.map((e) => OsrmWaypoint.fromJson(e))
            .toList(),
      );
}

class OsrmRoute {
  final String geometry;
  final List<OsrmLeg> legs;
  final double duration;
  final double distance;

  const OsrmRoute({
    required this.geometry,
    required this.legs,
    required this.duration,
    required this.distance,
  });

  factory OsrmRoute.fromJson(Map<String, dynamic> json) => OsrmRoute(
        geometry: json['geometry'] ?? '',
        legs:
            (json['legs'] as List?)?.map((e) => OsrmLeg.fromJson(e)).toList() ??
                [],
        duration: json['duration']?.toDouble() ?? 0.0,
        distance: json['distance']?.toDouble() ?? 0.0,
      );
}

class OsrmLeg {
  final String summary;
  final double duration;
  final double distance;

  const OsrmLeg({
    required this.summary,
    required this.duration,
    required this.distance,
  });

  factory OsrmLeg.fromJson(Map<String, dynamic> json) => OsrmLeg(
        summary: json['summary'] ?? '',
        duration: json['duration']?.toDouble() ?? 0.0,
        distance: json['distance']?.toDouble() ?? 0.0,
      );
}

class OsrmWaypoint {
  final String hint;
  final double distance;
  final String name;
  final List<double> location;

  const OsrmWaypoint({
    required this.hint,
    required this.distance,
    required this.name,
    required this.location,
  });

  factory OsrmWaypoint.fromJson(Map<String, dynamic> json) => OsrmWaypoint(
        hint: json['hint'] ?? '',
        distance: json['distance']?.toDouble() ?? 0.0,
        name: json['name'] ?? '',
        location: (json['location'] as List<dynamic>?)
                ?.map((e) => (e as num).toDouble())
                .toList() ??
            [],
      );
}
