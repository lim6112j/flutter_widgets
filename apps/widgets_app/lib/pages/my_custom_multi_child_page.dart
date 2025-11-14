import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyCustomMultiChildPage extends StatelessWidget {
  const MyCustomMultiChildPage({super.key});
  static const Map<String, Color> _colors = <String, Color>{
    'Red': Colors.red,
    'Green': Colors.green,
    'Blue': Colors.blue,
    'Cyan': Colors.cyan,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Multi Child'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: CustomMultiChildLayout(
        delegate: _CascadeLayoutDelegate(
          colors: _colors,
          overlap: 10.0,
          textDirection: Directionality.of(context),
        ),
        children: _colors.keys.map((String color) {
          return LayoutId(
            id: color,
            child: Container(
              color: _colors[color],
              width: 100,
              height: 100,
              child: Text(color),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _CascadeLayoutDelegate extends MultiChildLayoutDelegate {
  _CascadeLayoutDelegate({
    required this.colors,
    required this.overlap,
    required this.textDirection,
  });
  final Map<String, Color> colors;
  final double overlap;
  final TextDirection textDirection;
  @override
  void performLayout(Size size) {
    final double columnWidth = size.width / colors.length;
    Offset childPosition = Offset.zero;
    switch (textDirection) {
      case TextDirection.rtl:
        childPosition += Offset(size.width, 0);
        break;
      case TextDirection.ltr:
        break;
    }
    for (final String color in colors.keys) {
      final Size currentSize = layoutChild(
        color,
        BoxConstraints(maxWidth: columnWidth, maxHeight: size.height),
      );
      switch (textDirection) {
        case TextDirection.rtl:
          positionChild(color, childPosition - Offset(currentSize.width, 0));
          childPosition += Offset(
            -currentSize.width,
            currentSize.height - overlap,
          );
          break;
        case TextDirection.ltr:
          positionChild(color, childPosition);
          childPosition += Offset(
            currentSize.width,
            currentSize.height - overlap,
          );
          break;
      }
    }
  }

  @override
  bool shouldRelayout(_CascadeLayoutDelegate oldDelegate) {
    return oldDelegate.colors != colors ||
        oldDelegate.overlap != overlap ||
        oldDelegate.textDirection != textDirection;
  }
}
