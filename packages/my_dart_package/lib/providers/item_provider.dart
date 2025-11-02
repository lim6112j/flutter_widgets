library my_dart_package;

import 'package:riverpod/riverpod.dart';

class Item {
  final int id;
  final String title;
  Item(this.id, this.title);
}

// 상태: 로딩, 에러, 데이터
class ItemState {
  final bool isLoading;
  final String? error;
  final List<Item> items;

  ItemState({this.isLoading = false, this.error, this.items = const []});

  ItemState copyWith({bool? isLoading, String? error, List<Item>? items}) {
    return ItemState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      items: items ?? this.items,
    );
  }
}

// Provider
final itemProvider = StateNotifierProvider<ItemNotifier, ItemState>((ref) {
  return ItemNotifier();
});

class ItemNotifier extends StateNotifier<ItemState> {
  ItemNotifier() : super(ItemState());

  Future<void> loadItems() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 1)); // API 시뮬레이션

    try {
      final items = List.generate(10, (i) => Item(i, 'Item ${i + 1}'));
      state = state.copyWith(isLoading: false, items: items);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void reset() {
    state = ItemState();
  }
}
