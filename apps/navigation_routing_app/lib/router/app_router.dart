import 'package:go_router/go_router.dart';
import 'package:navigation_routing_app/pages/my_home_page.dart';
import 'package:navigation_routing_app/pages/setting_page.dart';
import 'package:navigation_routing_app/pages/user_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) =>
          const MyHomePage(title: 'Flutter Navigation Home Page'),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingPage(),
    ),
    GoRoute(
      path: '/user',
      name: 'user',
      builder: (context, state) => const UserPage(),
    ),
  ],
);
