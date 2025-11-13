import 'package:flutter/material.dart';

class MyDraggableComponents extends StatefulWidget {
  const MyDraggableComponents({super.key});
  @override
  State<MyDraggableComponents> createState() => _MyDraggableComponentsState();
}

class _MyDraggableComponentsState extends State<MyDraggableComponents> {
  int acceptedData = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Draggable<int>(
          data: 10,
          feedback: Container(color: Colors.blue, height: 100, width: 100),
          childWhenDragging: Container(
            color: Colors.grey,
            height: 100,
            width: 100,
          ),
          child: Container(color: Colors.red, height: 100, width: 100),
        ),
        DragTarget<int>(
          onAcceptWithDetails: (DragTargetDetails<int> details) {
            setState(() {
              acceptedData += details.data;
            });
          },
          builder: (context, candidateData, rejectedData) {
            return Container(
              color: Colors.green,
              height: 100,
              width: 100,
              child: Center(child: Text('Accepted: $acceptedData')),
            );
          },
        ),
      ],
    );
  }
}
