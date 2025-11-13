/// A simple calculator library.
library my_dart_package;
export 'routes/router.dart';
/// A Calculator class with basic arithmetic operations.
class Calculator {
  /// Adds two numbers.
  int add(int a, int b) => a + b;

  /// Subtracts two numbers.
  int subtract(int a, int b) => a - b;

  /// Multiplies two numbers.
  int multiply(int a, int b) => a * b;

  /// Divides two numbers.
  double divide(int a, int b) {
    if (b == 0) {
      throw ArgumentError('Cannot divide by zero');
    }
    return a / b;
  }
}

