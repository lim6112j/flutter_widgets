import 'package:go_router/go_router.dart';
import 'package:widgets_app/lib/pages/home_page.dart';

final routes = GoRouter (
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const MyHomePage(),
    ),
  ],
);
