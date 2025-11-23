import 'package:flutter/material.dart';
import 'package:flutter_resizable_container/flutter_resizable_container.dart';
import 'package:widgets_app/components/draggable_scrollable_sheet.dart';
import 'package:widgets_app/components/my_appbar.dart';
import 'package:widgets_app/components/my_map.dart';
import 'package:widgets_app/components/my_menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osrm_routes/osrm_routes.dart';
import 'package:widgets_app/utils/app_logger.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  late final ResizableController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ResizableController(
      data: const [
        ResizableChildData(startingRatio: 0.7),
        ResizableChildData(startingRatio: 0.3),
      ],
    );

    // Load sample routes on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSampleRoutes();
    });
  }

  void _loadSampleRoutes() {
    final notifier = ref.read(osrmRoutesProvider.notifier);
    final sampleLocations = [
    const OsrmLocation(longitude: 126.9780, latitude: 37.5665), // Seoul
    const OsrmLocation(longitude: 127.0276, latitude: 37.4979), // Gangnam (closer)
    ];
    notifier.getRoutes(sampleLocations);
  }

  void _logStateChange(OsrmRoutesState? previous, OsrmRoutesState next) {
    AppLogger.info('🔄 OSRM Routes State Changed at ${DateTime.now()}');

    // Loading state change
    if (previous?.isLoading != next.isLoading) {
      AppLogger.debug(
        '📡 Loading state: ${previous?.isLoading} → ${next.isLoading}',
      );
    }

    // Error state change
    if (previous?.error != next.error) {
      if (next.error != null) {
        AppLogger.error('❌ Error occurred: ${next.error}');
      } else {
        AppLogger.info('✅ Error cleared');
      }
    }

    // Routes count change
    if (previous?.routes.length != next.routes.length) {
      AppLogger.info(
        '🛣️ Routes count: ${previous?.routes.length ?? 0} → ${next.routes.length}',
      );
    }

    // Response code change
    if (previous?.routeResponse?.code != next.routeResponse?.code) {
      AppLogger.debug(
        '📋 Response code: ${previous?.routeResponse?.code} → ${next.routeResponse?.code}',
      );
    }

    // Log route details if available
    if (next.routes.isNotEmpty) {
      AppLogger.info('📊 Route Details:');
      for (int i = 0; i < next.routes.length; i++) {
        final route = next.routes[i];
        AppLogger.debug(
          '  Route $i: ${(route.distance / 1000).toStringAsFixed(1)}km, ${(route.duration / 60).toStringAsFixed(0)}min',
        );
      }
    }

    // Log waypoints if available
    if (next.routeResponse?.waypoints != null) {
      AppLogger.debug(
        '📍 Waypoints: ${next.routeResponse!.waypoints!.length} found',
      );
      for (int i = 0; i < next.routeResponse!.waypoints!.length; i++) {
        final waypoint = next.routeResponse!.waypoints![i];
        AppLogger.debug(
          '  Waypoint $i: ${waypoint.name} at ${waypoint.location}',
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(osrmRoutesProvider, (previous, next) {
      _logStateChange(previous, next);
    });
    final routesState = ref.watch(osrmRoutesProvider);
    return Scaffold(
      drawer: const MyMenu(),
      appBar: MyAppBar(
        title: widget.title,
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _loadSampleRoutes),
        ],
      ),
      body: Column(
        children: [
          if (routesState.error != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              color: Colors.red.shade100,
              child: Text(
                'Error: ${routesState.error}',
                style: TextStyle(color: Colors.red.shade800),
              ),
            ),
          if (routesState.routes.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              color: Colors.green.shade100,
              child: Text(
                'Routes loaded: ${routesState.routes.length} routes found',
                style: TextStyle(color: Colors.green.shade800),
              ),
            ),
          Expanded(
            child: ResizableContainer(
              controller: _controller,
              direction: Axis.vertical,
              divider: const ResizableDivider(
                color: Colors.grey,
                size: 3.0,
                thickness: 2.0,
              ),
              children: [
                MyMap(routes: routesState.routes), // Pass routes to MyMap
                const DraggableScrollableSheetWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
