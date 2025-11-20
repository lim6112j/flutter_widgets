import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StackPage extends StatelessWidget {
  const StackPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stack'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Stack(
        children: [
          ClipOval(
            child: Container(
              margin: EdgeInsets.only(top: 0),
              color: Colors.red,
              //full width
              width: double.infinity,
              height: 100,
            ),
          ),
          Container(color: Colors.red, width: double.infinity, height: 50),
          Container(child: Center(child: Text("Hello World"))),
        ],
      ),
    );
  }
}
