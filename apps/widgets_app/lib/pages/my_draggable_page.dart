import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
class MyDraggablePage extends StatelessWidget {
  const MyDraggablePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Draggable Page'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: const Center(
        child: Text('Draggable Page'),
      ),
    );
  }
}
