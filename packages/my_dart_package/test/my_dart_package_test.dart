import 'package:test/test.dart';
import 'package:my_dart_package/my_dart_package.dart';

void main() {
  group('Calculator', () {
    late Calculator calculator;

    setUp(() {
      calculator = Calculator();
    });

    test('should add two numbers correctly', () {
      expect(calculator.add(2, 3), equals(5));
    });

    test('should subtract two numbers correctly', () {
      expect(calculator.subtract(5, 3), equals(2));
    });

    test('should multiply two numbers correctly', () {
      expect(calculator.multiply(3, 4), equals(12));
    });

    test('should divide two numbers correctly', () {
      expect(calculator.divide(10, 2), equals(5.0));
    });

    test('should throw error when dividing by zero', () {
      expect(() => calculator.divide(10, 0), throwsArgumentError);
    });
  });
}
