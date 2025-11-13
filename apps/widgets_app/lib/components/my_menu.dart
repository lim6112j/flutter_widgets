import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
class MyMenu extends StatelessWidget {
  const MyMenu({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
                  padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                      decoration: BoxDecoration(
                  color: Colors.blue,
              ),
                      child: Text('Widgets'),
                    ),
                  ListTile(
                title: const Text('map'),
              onTap: () {
                  context.push('/map');
                  // Handle item 1 press
                },
              ),
            ListTile(
                title: const Text('draggable'),
              onTap: () {
                  context.push('/draggable');
                  // Handle item 2 press
                },
              ),
            ListTile(
                leading: const Hero(
                  tag: 'hero-rectangle',
                  child: BoxWidget(size: Size(50.0, 50.0)),
                ),
              onTap: () {
                  _gotoDetailsPage(context);
                },
                title: const Text('tap on the icon')
              )
            ],
                ),
  );
  }
}

class BoxWidget extends StatelessWidget{
  const BoxWidget({super.key, required this.size});
  final Size size;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      color: Colors.blue,
    );
  }
}

void _gotoDetailsPage(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('second page')),
        body: const Center(
          child: Hero(
            tag: 'hero-rectangle',
            child: BoxWidget(size: Size(200.0, 200.0))
          )
        )
      ),
    )
  );
}
