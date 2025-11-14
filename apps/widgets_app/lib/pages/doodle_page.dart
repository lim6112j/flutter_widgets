import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:widgets_app/components/doodle_box.dart';
import 'package:widgets_app/components/doodle_button.dart';

class DoodlePage extends StatelessWidget {
  const DoodlePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doodle'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: DoodleBox(
              size: const Size(200, 100),
              child: Center(
                child: DoodleButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Doodle button pressed!')),
                    );
                  },
                  backgroundColor: Colors.blue.shade100,
                  foregroundColor: Colors.blue.shade800,
                  child: const Text('Doodle Button'),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: DoodleBox(
              size: const Size(300, 150),
              child: Center(
                child: DoodleButton(
                  onPressed: () {},
                  backgroundColor: Colors.green.shade100,
                  foregroundColor: Colors.green.shade800,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.brush),
                      SizedBox(width: 8),
                      Text('Draw'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
