import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/osrm_location.dart';
import '../models/osrm_result.dart';
import '../models/osrm_route_resopnse.dart';

class OSRMRoutesRepository {
  static const String _apiUrl = "http://13.209.66.194:5000/route/v1/driving/";
  static const String _apiTail = "?overview=full&steps=true&annotations=true";

  Future<RouteResult<String>> apiRouteCall(List<OsrmLocation> locations) async {
    try {
      final coordinates =
          locations.map((loc) => '${loc.longitude},${loc.latitude}').join(';');

      final fullUrl = '$_apiUrl$coordinates$_apiTail';

      final response = await http.get(
        Uri.parse(fullUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        return RouteResult.failure(
            'OSRM routes API call failed: HTTP ${response.statusCode}');
      }

      return RouteResult.success(response.body);
    } catch (e) {
      return RouteResult.failure(
          'OSRM routes API call failed: ${e.toString()}');
    }
  }

  Future<RouteResult<OsrmRouteResponse>> getRoutes(
      List<OsrmLocation> locations) async {
    try {
      final result = await apiRouteCall(locations);

      if (!result.isSuccess || result.data == null) {
        return RouteResult.failure(result.error ?? 'Unknown error');
      }

      final jsonData = json.decode(result.data!);
      final routeResponse = OsrmRouteResponse.fromJson(jsonData);

      return RouteResult.success(routeResponse);
    } catch (e) {
      return RouteResult.failure(
          'Failed to parse OSRM routes response: ${e.toString()}');
    }
  }

  Future<RouteResult<List<OsrmRoute>>> getOptimalRoutes(
    List<OsrmLocation> locations, {
    int maxRoutes = 3,
  }) async {
    try {
      final result = await getRoutes(locations);

      if (!result.isSuccess || result.data?.routes == null) {
        return RouteResult.failure(result.error ?? 'No routes found');
      }

      final routes = result.data!.routes!.take(maxRoutes).toList();

      return RouteResult.success(routes);
    } catch (e) {
      return RouteResult.failure(
          'Failed to get optimal routes: ${e.toString()}');
    }
  }
}
