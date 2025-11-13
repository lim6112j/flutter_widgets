import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  const MyAppBar({super.key, required this.title, this.actions});
  @override
  Widget build(BuildContext context) {
    return AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search button press
              context.push('/search');
            },
          ),

          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              // Navigate to map page
              context.push('/map');
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Handle more options button press
            },
          ),
        ],
        
      );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
