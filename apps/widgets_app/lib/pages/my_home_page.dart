import 'package:flutter/material.dart';
import 'package:flutter_resizable_container/flutter_resizable_container.dart';
import 'package:widgets_app/components/draggable_scrollable_sheet.dart';
import 'package:widgets_app/components/my_appbar.dart';
import 'package:widgets_app/components/my_map.dart';
import 'package:widgets_app/components/my_menu.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final ResizableController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ResizableController(
      data: const [
        ResizableChildData(startingRatio: 0.7),
        ResizableChildData(startingRatio: 0.3),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyMenu(),
      appBar: const MyAppBar(title: 'my app'),
      body: ResizableContainer(
        controller: _controller,
        direction: Axis.vertical,
        divider: const ResizableDivider(
          color: Colors.grey,
          size: 3.0,
          thickness: 2.0,
        ),
        children: const [MyMap(), DraggableScrollableSheetWidget()],
      ),
    );
  }
}
