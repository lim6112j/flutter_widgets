import 'package:go_router/go_router.dart';
import 'package:widgets_app/pages/future_builder.dart';
import 'package:widgets_app/pages/martix_transition_example.dart';
import 'package:widgets_app/pages/my_custom_multi_child_page.dart';
import 'package:widgets_app/pages/my_home_page.dart';
import 'package:widgets_app/pages/my_setting_page.dart';
import 'package:widgets_app/pages/map_page.dart';
import 'package:widgets_app/pages/my_draggable_page.dart';
import 'package:widgets_app/pages/stream_builder_example.dart';

final routes = GoRouter(
  routes: [
    GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => const MySettingPage()),
    GoRoute(
      path: '/map',
      name: 'map',
      builder: (context, state) => const MapPage(),
    ),
    GoRoute(
      path: '/',
      name: 'widgets',
      builder: (context, state) => const MyHomePage(title: 'Widgets App'),
    ),
    GoRoute(
      path: '/draggable',
      name: 'draggable',
      builder: (context, state) => const MyDraggablePage(),
    ),
    GoRoute(
      path: '/matrix-transition',
      name: 'matrix-transition',
      builder: (context, state) => const MatrixTransitionExample(),
    ),
    GoRoute(
      path: '/stream-builder',
      name: 'stream-builder',
      builder: (context, state) => const StreamBuilderExample(),
    ),
    GoRoute(
      path: '/future-builder',
      name: 'future-builder',
      builder: (context, state) => const FutureBuilderExample(),
    ),
    GoRoute(
      path: '/custom-multi-child',
      name: 'custom-multi-child',
      builder: (context, state) => const MyCustomMultiChildPage(),
    ),
  ],
);
