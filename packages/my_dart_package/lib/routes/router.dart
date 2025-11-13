import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:widgets_app/pages/my_home_page.dart';

final routes = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const Scaffold(
        body: Center(
          child: Text('Home Page'),
        ),
      ),
    ),
    GoRoute(
      path: '/widgets',
      name: 'widgets',
      builder: (context, state) => const MyHomePage(title: 'Widgets App'),
    ),
  ],
);
