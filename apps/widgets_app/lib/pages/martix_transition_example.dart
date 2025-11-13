import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';

class MatrixTransitionExample extends StatefulWidget {
  const MatrixTransitionExample({super.key});
  @override
  State<MatrixTransitionExample> createState() => _MatrixTransitionState();
}

class _MatrixTransitionState extends State<MatrixTransitionExample>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matrix Transition'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Center(
        child: MatrixTransition(
          animation: _animation,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: FlutterLogo(size: 150.0),
          ),
          onTransform: (double value) {
            return Matrix4.identity()
              ..setEntry(3, 2, 0.004)
              ..rotateY(pi * 2.0 * value);
          },
        ),
      ),
    );
  }
}
