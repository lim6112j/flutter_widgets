import 'package:go_router/go_router.dart';
import 'package:widgets_app/pages/my_home_page.dart';
import 'package:widgets_app/pages/my_setting_page.dart';
import 'package:widgets_app/pages/map_page.dart';

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
  ],
);
