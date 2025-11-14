import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:osrm_routes/osrm_routes.dart';
import 'package:widgets_app/utils/app_logger.dart';
import 'package:widgets_app/utils/polyline_decoder.dart';

class MyMap extends StatefulWidget {
  final List<OsrmRoute> routes;
  const MyMap({super.key, this.routes = const []});

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final MapController _mapController = MapController();
  List<Polyline> _routePolylines = [];
  List<Marker> _waypoints = [];

  @override
  void didUpdateWidget(MyMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.routes.length != widget.routes.length) {
      AppLogger.info('MyMap: Routes updated - ${widget.routes.length} routes');
      _drawRoutes();
    }
  }

  void _drawRoutes() {
    if (widget.routes.isEmpty) {
      AppLogger.debug('MyMap: No routes to draw');
      setState(() {
        _routePolylines.clear();
        _waypoints.clear();
      });
      return;
    }

    AppLogger.info('MyMap: Drawing ${widget.routes.length} routes');

    final List<Polyline> polylines = [];
    final List<Marker> markers = [];
    final List<LatLng> allPoints = [];

    for (int i = 0; i < widget.routes.length; i++) {
      final route = widget.routes[i];
      AppLogger.debug(
        'Route $i: ${(route.distance / 1000).toStringAsFixed(1)}km, '
        '${(route.duration / 60).toStringAsFixed(0)}min',
      );

      // Process route geometry for drawing
      if (route.geometry.isNotEmpty) {
        final routeData = _processRouteGeometry(route.geometry, i);
        if (routeData != null) {
          polylines.add(routeData.polyline);
          markers.addAll(routeData.markers);
          allPoints.addAll(routeData.points);
        }
      }

      // Process route legs for waypoints
      for (int j = 0; j < route.legs.length; j++) {
        final leg = route.legs[j];
        AppLogger.debug('  Leg $j: ${leg.distance}m, ${leg.duration}s');
      }
    }

    setState(() {
      _routePolylines = polylines;
      _waypoints = markers;
    });

    // Fit map to show all routes
    if (allPoints.isNotEmpty) {
      _fitMapToRoutes(allPoints);
    }
  }


RouteData? _processRouteGeometry(String geometry, int routeIndex) {
  try {
    AppLogger.debug('Processing geometry for route $routeIndex: ${geometry.substring(0, 20)}...');
    
    // Debug: Log the raw geometry string
    AppLogger.debug('Raw geometry length: ${geometry.length}');
    
    // Try different precision values - OSRM typically uses precision 5
    List<LatLng> latLngs = [];
    
    try {
      // Method 1: Try with precision 5 (OSRM standard)
      latLngs = PolylineDecoder.decode(geometry);
      
      AppLogger.debug('Decoded with precision 5: ${latLngs.length} points');
      if (latLngs.isNotEmpty) {
        AppLogger.debug('First point: ${latLngs.first.latitude}, ${latLngs.first.longitude}');
        AppLogger.debug('Last point: ${latLngs.last.latitude}, ${latLngs.last.longitude}');
      }
    } catch (e) {
      AppLogger.warning('Failed with precision 5, trying precision 6: $e');
      
      // Method 2: Try with precision 6
      try {
        latLngs = PolylineDecoder.decode(geometry);
        AppLogger.debug('Decoded with precision 6: ${latLngs.length} points');
      } catch (e2) {
        AppLogger.error('Failed with both precisions: $e2');
        return null;
      }
    }
    
    if (latLngs.isEmpty) {
      AppLogger.warning('No valid coordinates decoded for route $routeIndex');
      return null;
    }

    // Debug: Check coordinate ranges
    final latRange = latLngs.map((p) => p.latitude);
    final lngRange = latLngs.map((p) => p.longitude);
    AppLogger.debug('Lat range: ${latRange.reduce((a, b) => a < b ? a : b)} to ${latRange.reduce((a, b) => a > b ? a : b)}');
    AppLogger.debug('Lng range: ${lngRange.reduce((a, b) => a < b ? a : b)} to ${lngRange.reduce((a, b) => a > b ? a : b)}');

    // Create polyline for drawing on map
    final polyline = Polyline(
      points: latLngs,
      strokeWidth: 4.0,
      color: _getRouteColor(routeIndex),
    );

    // Create start and end markers
    final markers = <Marker>[
      // Start marker
      Marker(
        point: latLngs.first,
        width: 30,
        height: 30,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.play_arrow, color: Colors.white, size: 16),
        ),
      ),
      // End marker
      Marker(
        point: latLngs.last,
        width: 30,
        height: 30,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.stop, color: Colors.white, size: 16),
        ),
      ),
    ];

    AppLogger.debug('Route $routeIndex: Successfully processed ${latLngs.length} coordinates');
    
    return RouteData(
      polyline: polyline,
      markers: markers,
      points: latLngs,
    );
    
  } catch (e) {
    AppLogger.error('Failed to process route geometry for route $routeIndex: $e');
    return null;
  }
}
  bool _isValidLatLng(LatLng latLng) {
    return latLng.latitude.isFinite &&
        latLng.longitude.isFinite &&
        latLng.latitude >= -90 &&
        latLng.latitude <= 90 &&
        latLng.longitude >= -180 &&
        latLng.longitude <= 180;
  }

  Color _getRouteColor(int index) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange,
    ];
    return colors[index % colors.length];
  }

  void _fitMapToRoutes(List<LatLng> points) {
    if (points.isEmpty) return;

    final validPoints = points.where(_isValidLatLng).toList();

    if (validPoints.isEmpty) {
      AppLogger.warning('No valid points to fit map bounds');
      return;
    }
    try {
      final bounds = LatLngBounds.fromPoints(validPoints);

      // Validate bounds before fitting
      if (!_isValidBounds(bounds)) {
        AppLogger.warning('Invalid bounds calculated, skipping fit');
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.fitCamera(
          CameraFit.bounds(
            bounds: bounds,
            padding: const EdgeInsets.all(50),
            maxZoom: 18.0, // Prevent excessive zoom
          ),
        );
      });
    } catch (e) {
      AppLogger.error('Failed to fit map to routes: $e');
    }
  }

  bool _isValidBounds(LatLngBounds bounds) {
    return _isValidLatLng(bounds.northEast) &&
        _isValidLatLng(bounds.southWest) &&
        bounds.northEast.latitude > bounds.southWest.latitude &&
        bounds.northEast.longitude > bounds.southWest.longitude;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: const MapOptions(
        initialCenter: LatLng(37.7749, 127.4194),
        initialZoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.widgets_app',
        ),
        PolylineLayer(polylines: _routePolylines),
        MarkerLayer(markers: _waypoints),
        if (widget.routes.isNotEmpty)
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Routes: ${widget.routes.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...widget.routes.asMap().entries.map((entry) {
                    final index = entry.key;
                    final route = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _getRouteColor(index),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${(route.distance / 1000).toStringAsFixed(1)}km, ${(route.duration / 60).toStringAsFixed(0)}min',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class RouteData {
  final Polyline polyline;
  final List<Marker> markers;
  final List<LatLng> points;

  RouteData({
    required this.polyline,
    required this.markers,
    required this.points,
  });
}
