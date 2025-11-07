import 'package:flutter/material.dart';
import 'package:my_dart_package/providers/item_provider.dart';
import 'package:my_dart_package/providers/timer_provider.dart';
import '../clippers/my_clipper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(itemProvider);
    final notifier = ref.read(itemProvider.notifier);
    final timer = ref.watch(timerProvider);
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
      // add clipoval with blue rectable child to body
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(child: Text('Error: ${state.error}'))
              : Column(
                children: [
                  ClipOval(
                    child: Container(
                      color: Colors.blue,
                      width: 100,
                      height: 100,
                    ).animate().fadeIn().scale(
                                    delay: (400).ms,
                                    duration: 600.ms,
                                    begin: const Offset(0.0, 0.0),
                                    curve: Curves.elasticOut,
                                  ),
                  ),
          // add clippath example
                  ClipPath(
                    clipper: MyClipper(),
                    child: Container(
                      color: Colors.red,
                      width: 100,
                      height: 100,
                    ).animate().fadeIn(),
                  ),
                  Expanded(
                    child: ListView.builder(
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
                              title: timer.when(
                                    data: (sec) => Text('${item.title}, $sec 초')
                                        .animate()
                                        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0), duration: 300.ms)
                                        .shimmer(duration: 1000.ms),
                                    loading: () => Text('시작...').animate().fadeIn(),
                                    error: (_, __) => Text('에러'),
                                  )
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
                  ),
                ],
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

