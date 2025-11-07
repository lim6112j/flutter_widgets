library my_dart_package;

import 'package:riverpod/riverpod.dart';

final timerProvider = StreamProvider.autoDispose<int>((ref) {
  return Stream.periodic(Duration(seconds: 1), (i) => i + 1).take(60);
});
