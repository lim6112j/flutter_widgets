import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FlowPage extends StatefulWidget {
  const FlowPage({super.key});

  @override
  State<FlowPage> createState() => _FlowPageState();
}

class _FlowPageState extends State<FlowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Flow'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Center(
        child: FlowMenu(),
      ),
    );
  }
}

class FlowMenu extends StatefulWidget{
  const FlowMenu({super.key});

  @override
  State<FlowMenu> createState() => _FlowMenuState();
}

class _FlowMenuState extends State<FlowMenu> with SingleTickerProviderStateMixin{
    late AnimationController _controller;
    IconData lastTapped = Icons.notifications;
    final List<IconData> menuItems = <IconData> [
      Icons.home,
      Icons.new_releases,
      Icons.notifications,
      Icons.settings,
      Icons.menu
    ];
    void _updateMenu(IconData icon) {
      if(icon != Icons.menu) {
        setState(() {
          lastTapped = icon;
        });
      }
    }
    @override
    void initState() {
      super.initState();
      _controller = AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      );
    }
    Widget flowMenuItem(IconData icon) {
      final double buttonDiameter = MediaQuery.of(context).size.width / menuItems.length;
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: RawMaterialButton(
          fillColor: lastTapped == icon ? Colors.amber[700] : Colors.blue,
          splashColor: Colors.amber[100],
          shape: const CircleBorder(),
          constraints: BoxConstraints.tight(Size(buttonDiameter, buttonDiameter)),
          onPressed: () {
            _updateMenu(icon);
            _controller.status == AnimationStatus.completed
              ? _controller.reverse()
              : _controller.forward();
          },
          child: Icon(icon, color: Colors.white, size: 35.0),
        ),
      );
    }
    @override
    Widget build(BuildContext context) {
      return Flow(
        delegate: FlowMenuDelegate(controller: _controller),
        children: menuItems.map<Widget>((IconData icon) => flowMenuItem(icon)).toList(),
      );
    }
  }
class FlowMenuDelegate extends FlowDelegate {
  FlowMenuDelegate({required this.controller}) : super(repaint: controller);

  final Animation<double> controller;

  @override
  bool shouldRepaint(FlowMenuDelegate oldDelegate) {
    return controller != oldDelegate.controller;
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    double dx = 0.0;
    for (int i = 0; i < context.childCount; ++i) {
      dx = context.getChildSize(i)!.width * i;
      context.paintChild(i, transform: Matrix4.translationValues(dx * controller.value, 0, 0));
    }
  }
}
