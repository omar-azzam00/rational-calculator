import 'dart:io';
import 'dart:math' as math;

class FractionDenominatorIsZero implements Exception {
  final String message;
  const FractionDenominatorIsZero(this.message);
  @override
  String toString() => message;
}

class Fraction {
  late int numerator;
  late int denominator;

  Fraction(num numerator, [num denominator = 1]) {
    if (denominator == 0) {
      throw FractionDenominatorIsZero("");
    }
    if (numerator == 0) {
      this.numerator = 0;
      this.denominator = 1;
      return;
    }
    if (numerator.runtimeType == int && denominator.runtimeType == int) {
      this.numerator = numerator as int;
      this.denominator = denominator as int;
      simplifySigns();
      simplifyFraction();
      return;
    }
    var results = removePoint(numerator.toDouble(), denominator.toDouble());
    this.numerator = results[0];
    this.denominator = results[1];
    simplifySigns();
    simplifyFraction();
  }

  factory Fraction.fromStringFormat(String str) {
    List numAndDenStr = str.split('/');
    return Fraction(
      double.parse(numAndDenStr[0]),
      double.parse(numAndDenStr[1]),
    );
  }

  List<int> removePoint(double numerator, double denominator) {
    if (numerator.toInt() != numerator) {
      int afterPointCount =
          numerator.toString().length - numerator.toString().indexOf('.') - 1;
      numerator = numerator * math.pow(10, afterPointCount);
      denominator = denominator * math.pow(10, afterPointCount);
    }
    if (denominator.toInt() != denominator) {
      int afterPointCount = denominator.toString().length -
          denominator.toString().indexOf('.') -
          1;
      denominator = denominator * math.pow(10, afterPointCount);
      numerator = numerator * math.pow(10, afterPointCount);
    }
    return <int>[numerator.toInt(), denominator.toInt()];
  }

  void simplifySigns() {
    if (numerator < 0 && denominator < 0) {
      numerator = -numerator;
      denominator = -denominator;
    }
    if (numerator > 0 && denominator < 0) {
      numerator = -numerator;
      denominator = -denominator;
    }
  }

  int gcd(int a, int b) {
    if (b == 0) {
      return a;
    }
    return gcd(b, a % b);
  }

  void simplifyFraction() {
    var x = gcd(numerator, denominator);

    numerator ~/= x;
    denominator ~/= x;
  }

  Fraction operator *(Fraction other) {
    return Fraction(
      numerator * other.numerator,
      denominator * other.denominator,
    );
  }

  Fraction operator /(Fraction other) {
    return Fraction(
      numerator * other.denominator,
      denominator * other.numerator,
    );
  }

  Fraction operator +(Fraction other) {
    return Fraction(
        numerator * other.denominator + other.numerator * denominator,
        denominator * other.denominator);
  }

  Fraction operator -(Fraction other) {
    return Fraction(
        numerator * other.denominator - other.numerator * denominator,
        denominator * other.denominator);
  }

  bool isInt() {
    return denominator == 1;
  }

  num asNum() {
    if (isInt()) {
      return numerator;
    }
    return numerator / denominator;
  }

  int asInt() {
    return numerator ~/ denominator;
  }

  double asDouble() {
    return numerator / denominator;
  }

  String toMixedFraction() {
    int wholeNumber = numerator ~/ denominator;
    Fraction remainingPart =
        Fraction(numerator - wholeNumber * denominator, denominator);

    return '$wholeNumber $remainingPart';
  }

  String toString() {
    return '$numerator/$denominator';
  }
}
