import 'package:flutter/material.dart';

class PhysicsPage extends StatefulWidget {
  const PhysicsPage({required this.child, super.key});

  final Widget child;

  @override
  State<PhysicsPage> createState() => _PhysicsPageState();
}

class _PhysicsPageState extends State<PhysicsPage> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  Alignment _alignment = Alignment.center;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
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
        title: const Text('Physics Animation'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'You can drag logo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onPanDown: (details){},
              onPanUpdate: (details) {
                setState(() {
                  _alignment += Alignment(
                    details.delta.dx / context.size!.width / 2,
                    details.delta.dy / context.size!.height / 2,
                  );
                });
              },
              onPanStart: (details) {},
              child: Align(
                alignment: _alignment,
                child: widget.child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
