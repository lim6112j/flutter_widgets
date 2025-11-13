import 'package:flutter/material.dart';

class DraggableScrollableSheetWidget extends StatefulWidget {
  const DraggableScrollableSheetWidget({super.key});
  @override
  State<DraggableScrollableSheetWidget> createState() =>
      _DraggableScrollableSheetWidgetState();
}

class _DraggableScrollableSheetWidgetState
    extends State<DraggableScrollableSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1.0,
      minChildSize: 0.25,
      maxChildSize: 1.00,
      builder: (context, scrollController) {
        return Container(
          color: Colors.blue,
          child: ListView.builder(
            controller: scrollController,
            itemCount: 50,
            itemBuilder: (context, index) {
              return ListTile(title: Text('Item $index'));
            },
          ),
        );
      },
    );
  }
}
