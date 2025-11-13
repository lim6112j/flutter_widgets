import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:widgets_app/pages/my_home_page.dart';

final routes = GoRouter(
  routes: [
    GoRoute(
      path: '/search',
      name: 'search',
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text('Search Page'),
          leading: IconButton(
            icon:  Icon(Icons.arrow_back),
            onPressed: () {
              // Handle back button press
              context.pop();
            },
          ),
        ),
        body: Center(
          child: Text('search Page'),
        ),
      ),
    ),
    GoRoute(
      path: '/',
      name: 'widgets',
      builder: (context, state) => const MyHomePage(title: 'Widgets App'),
    ),
  ],
);
