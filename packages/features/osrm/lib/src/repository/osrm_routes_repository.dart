import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/osrm_location.dart';
import '../models/osrm_result.dart';
import '../models/osrm_route_resopnse.dart';

class OSRMRoutesRepository {
  static const String _apiUrl = "http://13.209.66.194:5000/route/v1/driving/";
  static const String _apiTail = "?overview=full&steps=true&annotations=true";

  void _log(String message) {
    print('🌐 OSRM Repository: $message');
  }

  Future<RouteResult<String>> apiRouteCall(List<OsrmLocation> locations) async {
    try {
      final coordinates =
          locations.map((loc) => '${loc.longitude},${loc.latitude}').join(';');

      final fullUrl = '$_apiUrl$coordinates$_apiTail';
      _log('Making API call to: $fullUrl');

      final response = await http.get(
        Uri.parse(fullUrl),
        headers: {'Content-Type': 'application/json'},
      );

      _log('Response status: ${response.statusCode}');
      _log('Response body length: ${response.body.length}');
      
      if (response.statusCode != 200) {
        _log('❌ API call failed with status ${response.statusCode}');
        return RouteResult.failure(
            'OSRM routes API call failed: HTTP ${response.statusCode}');
      }

      // Log first part of response for debugging
      final preview = response.body.length > 200 
          ? response.body.substring(0, 200) 
          : response.body;
      _log('Response preview: $preview...');

      return RouteResult.success(response.body);
    } catch (e) {
      _log('❌ Exception during API call: $e');
      return RouteResult.failure(
          'OSRM routes API call failed: ${e.toString()}');
    }
  }

  Future<RouteResult<OsrmRouteResponse>> getRoutes(
      List<OsrmLocation> locations) async {
    try {
      _log('Getting routes for ${locations.length} locations');
      for (int i = 0; i < locations.length; i++) {
        _log('  Location $i: ${locations[i].latitude}, ${locations[i].longitude}');
      }

      final result = await apiRouteCall(locations);

      if (!result.isSuccess || result.data == null) {
        _log('❌ API call failed: ${result.error}');
        return RouteResult.failure(result.error ?? 'Unknown error');
      }

      _log('Parsing JSON response...');
      final jsonData = json.decode(result.data!);
      
      _log('JSON parsed, code: ${jsonData['code']}');
      if (jsonData['routes'] != null) {
        _log('Routes found: ${jsonData['routes'].length}');
        for (int i = 0; i < jsonData['routes'].length; i++) {
          final route = jsonData['routes'][i];
          _log('  Route $i: distance=${route['distance']}, duration=${route['duration']}');
          if (route['geometry'] != null) {
            final geom = route['geometry'] as String;
            _log('  Route $i geometry length: ${geom.length}');
            _log('  Route $i geometry preview: ${geom.substring(0, geom.length > 30 ? 30 : geom.length)}...');
          }
        }
      }
      
      final routeResponse = OsrmRouteResponse.fromJson(jsonData);
      _log('✅ Successfully parsed route response');

      return RouteResult.success(routeResponse);
    } catch (e, stackTrace) {
      _log('❌ Exception during route parsing: $e');
      print('Stack trace: $stackTrace');
      return RouteResult.failure(
          'Failed to parse OSRM routes response: ${e.toString()}');
    }
  }

  Future<RouteResult<List<OsrmRoute>>> getOptimalRoutes(
    List<OsrmLocation> locations, {
    int maxRoutes = 3,
  }) async {
    try {
      _log('Getting optimal routes (max: $maxRoutes)');
      final result = await getRoutes(locations);

      if (!result.isSuccess || result.data?.routes == null) {
        _log('❌ Failed to get routes: ${result.error}');
        return RouteResult.failure(result.error ?? 'No routes found');
      }

      final routes = result.data!.routes!.take(maxRoutes).toList();
      _log('✅ Returning ${routes.length} optimal routes');

      return RouteResult.success(routes);
    } catch (e) {
      _log('❌ Exception getting optimal routes: $e');
      return RouteResult.failure(
          'Failed to get optimal routes: ${e.toString()}');
    }
  }
}
