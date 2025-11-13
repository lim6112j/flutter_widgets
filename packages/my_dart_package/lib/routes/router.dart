import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

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
  ],
);
