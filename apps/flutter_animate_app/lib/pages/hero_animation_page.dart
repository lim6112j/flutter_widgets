import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HeroAnimationPage extends StatelessWidget {
  const HeroAnimationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hero Animations'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HeroDetailPage(index: index),
                ),
              );
            },
            child: Hero(
              tag: 'hero-$index',
              child: Card(
                elevation: 4,
                color: Colors.primaries[index % Colors.primaries.length],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star,
                        size: 48,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Item ${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ).animate().scale(
              delay: (100 * index).ms,
              duration: 400.ms,
              curve: Curves.easeOut,
            ),
          );
        },
      ),
    );
  }
}

class HeroDetailPage extends StatelessWidget {
  final int index;

  const HeroDetailPage({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item ${index + 1} Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'hero-$index',
              child: Card(
                elevation: 8,
                color: Colors.primaries[index % Colors.primaries.length],
                child: Container(
                  width: 300,
                  height: 300,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          size: 120,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Item ${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'This is the detail view for Item ${index + 1}',
              style: const TextStyle(fontSize: 18),
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3, delay: 300.ms),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Go Back'),
            ).animate().scale(delay: 500.ms),
          ],
        ),
      ),
    );
  }
}
