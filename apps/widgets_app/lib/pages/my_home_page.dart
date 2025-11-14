import 'package:flutter/material.dart';
import 'package:flutter_resizable_container/flutter_resizable_container.dart';
import 'package:widgets_app/components/draggable_scrollable_sheet.dart';
import 'package:widgets_app/components/my_appbar.dart';
import 'package:widgets_app/components/my_map.dart';
import 'package:widgets_app/components/my_menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osrm_routes/osrm_routes.dart';

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
      const OsrmLocation(longitude: 129.0756, latitude: 35.1796), // Busan
    ];
    notifier.getRoutes(sampleLocations);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final routesState = ref.watch(osrmRoutesProvider);

    return Scaffold(
      drawer: const MyMenu(),
      appBar: const MyAppBar(
        title: 'my app',
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed:  _loadSampleRoutes,
          ),
          if (routesState.isLoading)
             Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ]
      ),
      body: ResizableContainer(
        controller: _controller,
        direction: Axis.vertical,
        divider: const ResizableDivider(
          color: Colors.grey,
          size: 3.0,
          thickness: 2.0,
        ),
        children: const [MyMap(), DraggableScrollableSheetWidget()],
      ),
    );
  }
}
