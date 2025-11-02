import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_dart_package/providers/item_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}
// main.dart
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(itemProvider);
    final notifier = ref.read(itemProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Animate + Riverpod'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              notifier.reset();
              notifier.loadItems();
            },
          )
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(child: Text('Error: ${state.error}'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];

                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.circle)
                            .animate()
                            .scale(
                              delay: (100 * index).ms,
                              duration: 600.ms,
                              begin: const Offset(0.0, 0.0),
                              curve: Curves.elasticOut,
                            ),
                        title: Text(item.title)
                            .animate()
                            .fadeIn(
                              delay: (100 * index).ms,
                              duration: 500.ms,
                            )
                            .slideX(
                              begin: -0.3,
                              delay: (100 * index).ms,
                              curve: Curves.easeOutCubic,
                            ),
                        trailing: IconButton(
                          icon: const Icon(Icons.favorite_border),
                          onPressed: () {
                            // 클릭 시 개별 아이템 애니메이션
                          },
                        )
                            .animate()
                            .shake(delay: (100 * index).ms, hz: 3),
                      ),
                    )
                        .animate()
                        .elevation(
                          delay: (100 * index).ms,
                          duration: 400.ms,
                          begin: 1,
                          end: 8,
                        )
                        .scale(
                          delay: (100 * index).ms,
                          duration: 300.ms,
                          begin: const Offset(0.95, 0.95),
                          end: const Offset(1.0, 1.0),
                        );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: notifier.loadItems,
        child: const Icon(Icons.play_arrow).animate().rotate(
              duration: 600.ms,
              begin: 0,
              end: 1,
            ),
      ),
    );
  }
}
