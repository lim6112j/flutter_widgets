import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:osrm_routes/osrm_routes.dart';
import 'package:widgets_app/utils/app_logger.dart';

class MyMap extends StatefulWidget {
  final List<OsrmRoute> routes;
  const MyMap({super.key, this.routes = const []});
  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  @override
  void didUpdateWidget(MyMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Check if routes have changed
    if (oldWidget.routes.length != widget.routes.length) {
      AppLogger.info('MyMap: Routes updated - ${widget.routes.length} routes');
      _drawRoutes();
    }
  }

  void _drawRoutes() {
    if (widget.routes.isEmpty) {
      AppLogger.debug('MyMap: No routes to draw');
      return;
    }

    AppLogger.info('MyMap: Drawing ${widget.routes.length} routes');
    
    for (int i = 0; i < widget.routes.length; i++) {
      final route = widget.routes[i];
      AppLogger.debug(
        'Route $i: ${(route.distance / 1000).toStringAsFixed(1)}km, '
        '${(route.duration / 60).toStringAsFixed(0)}min'
      );
      
      // Process route geometry for drawing
      if (route.geometry.isNotEmpty) {
        _processRouteGeometry(route.geometry, i);
      }
      
      // Process route legs for waypoints
      for (int j = 0; j < route.legs.length; j++) {
        final leg = route.legs[j];
        AppLogger.debug('  Leg $j: ${leg.distance}m, ${leg.duration}s');
      }
    }
  }

  void _processRouteGeometry(String geometry, int routeIndex) {
    try {
      // Here you would decode the polyline geometry
      // For now, just log that we're processing it
      AppLogger.debug('Processing geometry for route $routeIndex: ${geometry.substring(0, 20)}...');
      
      // TODO: Decode polyline and convert to map coordinates
      // TODO: Draw polyline on map
      
    } catch (e) {
      AppLogger.error('Failed to process route geometry: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(37.7749, 127.4194), // San Francisco
        initialZoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.widgets_app',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: const LatLng(37.7749, 127.4194),
              width: 80,
              height: 80,
              child: const Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 40,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
