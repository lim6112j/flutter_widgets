import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:widgets_app/pages/my_home_page.dart';
import 'package:widgets_app/pages/my_setting_page.dart';

final routes = GoRouter(
  routes: [
    GoRoute(
      path: '/search',
      name: 'search',
      builder: (context, state) => const MySettingPage()),
    GoRoute(
      path: '/',
      name: 'widgets',
      builder: (context, state) => const MyHomePage(title: 'Widgets App'),
    ),
  ],
);
