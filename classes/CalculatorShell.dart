/// This a library is for creating simple calculator shell that supports fractions and some commands.
/// The main class is CalculatorShell and it contains the run method.
library;

import 'dart:io';
import '../extentions/StrExt1.dart';
import 'Fraction.dart';

/// every math operation contains either numbers or operators
enum mathTokenType { number, operator }

/// list of all supported commands
enum command {
  clear,
  exit,
  help,
}

/// This class is for creating simple calculator shell that supports fractions and some commands.
/// use the run method to run the shell.
class CalculatorShell {
  /// printed before and after the cataloge or help menu.
  final seperatorLine =
      '#######################################################################';

  /// printed at the start of the shell and with the help menu.
  final cataloge = 'This is a rational numbers calculator.\n'
      'put a space between operators and numbers like this:  "5/4 * 123.32 / 4"';

  final extraCataloge =
      'NOTE: 100 / 50/2 is 100 divided by the fraction 50/2 which all equals 4,\n'
      'but 100 / 50 / 2 is 100 divided by 50 then the result divided by 2 which equals 1.';

  /// printed in the help menu after printing the cataloge.
  final commandsDesc = '${command.clear.name} - clears the terminal.\n'
      '${command.exit.name} - exit the program.\n'
      '${command.help.name} - print this cataloge again.';

  /// takes the line and returns list of tokens
  /// tokens are seperated by one or more whitespace characters
  /// leading or trailing whitespaces are ignored
  List<String> getTokens(String line) =>
      line.split(' ').where((token) => token.trim().isNotEmpty).toList();

  /// check if a given token is a command in the command enum list
  /// see command enum to see all supported commands
  bool isCommand(String token) =>
      command.values.any((command) => command.name == token);

  /// check if given tokens can be performed as a math operation
  /// it returns false also if any operator is not supported by the
  /// current version of the program
  /// if there is any error it will mark it first and write a message
  /// to the user in stderr.
  /// tokensType will be filled if provided. and it will be fully filled
  /// correctly only if function return true

  bool isValidMathOperation(
    List<String> tokens, [
    List<mathTokenType>? tokensType,
  ]) {
    tokensType = tokensType ?? [];

    if (tokensType.isNotEmpty) {
      tokensType.clear();
    }

    // we declared this to pass it to markInvalid token
    int readedLength = 0;

    /// this function is used to print the math operation
    /// and mark the invalid token
    void markInvalidToken(String token, int readedLength) {
      stderr.writeln(
          '${tokens.join(' ')}\n${' ' * readedLength}${'^' * token.length}');
    }

    for (var token in tokens) {
      if (double.tryParse(token) != null) {
        if (tokensType.isNotEmpty && tokensType.last == mathTokenType.number) {
          markInvalidToken(token, readedLength);
          stderr.writeln('Can\'t be two numbers after each other!');
          return false;
        }
        if (token == 'Infinity' || token == 'NaN' || token == '-Infinity') {
          markInvalidToken(token, readedLength);
          stderr.writeln('this is not recoginzed!');
          return false;
        }
        tokensType.add(mathTokenType.number);
        readedLength += token.length + 1;
        continue;
      }
      if (token.isFraction) {
        if (tokensType.isNotEmpty && tokensType.last == mathTokenType.number) {
          markInvalidToken(token, readedLength);
          stderr.writeln('mixed fractions are not supported yet!');
          return false;
        }
        if (!token.parseFraction().isFinite) {
          markInvalidToken(token, readedLength);
          stderr.writeln('You can\'t divide by zero!');
          return false;
        }

        tokensType.add(mathTokenType.number);
        readedLength += token.length + 1;
        continue;
      }
      switch (token) {
        case '*' || '/' || '-' || '+':
          if (tokensType.isEmpty) {
            markInvalidToken(token, readedLength);
            stderr.writeln('Can\'t start with an operator!');
            return false;
          }
          if (tokensType.last == mathTokenType.operator) {
            markInvalidToken(token, readedLength);
            stderr.writeln('Can\'t be two operators after each other!');
            return false;
          }
          tokensType.add(mathTokenType.operator);
        case '(' || ')':
          markInvalidToken(token, readedLength);
          stderr.writeln('parenthesis is not supported yet!');
          return false;
        case '^':
          markInvalidToken(token, readedLength);
          stderr.writeln('power operator is not supported yet!');
          return false;
        case '%':
          markInvalidToken(token, readedLength);
          stderr.writeln('remainder is not supported yet!');
          return false;
        default:
          markInvalidToken(token, readedLength);
          if (token[0] == '(' || token[token.length - 1] == ')') {
            stderr.writeln('parenthesis is not supported yet!');
          } else {
            stderr.writeln('this is not recoginzed!');
          }
          return false;
      }
      readedLength += token.length + 1;
    }
    if (tokensType.last == mathTokenType.operator) {
      markInvalidToken(tokens.last, readedLength - 2);
      stderr.writeln('Can\'t end with an operator!');
    }
    return true;
  }

  /// this function will perform the given math operation using fraction class.
  /// print the double, fraction and mixed fraction result to the output, you should validate the input
  /// before calling it to avoid any errors or unexpected behaviour
  String performMathOperation(List<String> tokens) {
    List<Fraction> numbers = [];
    List<String> ops = [];

    for (int i = 0; i < tokens.length; i++) {
      if (i % 2 == 0) {
        if (tokens[i].isFraction) {
          numbers.add(Fraction.fromStringFormat(tokens[i]));
        } else {
          numbers.add(Fraction(double.parse(tokens[i])));
        }
      } else {
        ops.add(tokens[i]);
      }
    }

    // multiplaction and division loop
    for (int i = 0; i < ops.length; i++) {
      Fraction result;
      if (ops[i] == '*') {
        result = numbers[i] * numbers[i + 1];
      } else if (ops[i] == '/') {
        result = numbers[i] / numbers[i + 1];
      } else {
        continue;
      }
      numbers.removeRange(i, i + 2);
      numbers.insert(i, result);
      ops.removeAt(i);
      i = -1;
    }

    // adding and subtracting loop
    for (int i = 0; i < ops.length; i++) {
      Fraction result;
      if (ops[i] == '+') {
        result = numbers[i] + numbers[i + 1];
      } else if (ops[i] == '-') {
        result = numbers[i] - numbers[i + 1];
      } else {
        continue;
      }
      numbers.removeRange(i, i + 2);
      numbers.insert(i, result);
      ops.removeAt(i);
      i = -1;
    }

    if (numbers[0].isInt()) {
      return numbers[0].numerator.toString();
    } else if (numbers[0].asDouble() > 1) {
      return '${numbers[0].asDouble()} OR ${numbers[0]} OR ${numbers[0].toMixedFraction()}';
    } else {
      return '${numbers[0].asDouble()} OR ${numbers[0]}';
    }
  }

  /// This is the main method in the library and the class
  /// which runs the calculator shell.
  void run() {
    stdout.write(
        '$seperatorLine\n$cataloge\ntype "help" if you want help\n$seperatorLine');
    // this makes cataloge at top.
    stdout.write(
      '\n' *
          (stdout.terminalLines -
              cataloge.lines -
              seperatorLine.lines * 2 -
              1), // minus one for extra line in stdout
    );

    String line;
    while (true) {
      stdin.echoMode = true;
      stdout.write('> ');
      line = stdin.readLineSync() ?? '';

      var tokens = getTokens(line);
      if (tokens.isEmpty) {
        continue;
      }

      if (tokens.length == 1 && isCommand(tokens[0])) {
        if (tokens[0] == 'exit') {
          break;
        } else if (tokens[0] == 'clear') {
          stdout.write('\n' * (stdout.terminalLines - 1));
        } else if (tokens[0] == 'help') {
          var fullHelp =
              "$seperatorLine\n$cataloge\n\n$extraCataloge\n\n$commandsDesc\n$seperatorLine";
          stdout.write(fullHelp);
          stdout.write('\n' * (stdout.terminalLines - fullHelp.lines));
        }
      } else if (isValidMathOperation(tokens)) {
        print(performMathOperation(tokens));
      } else {
        stderr.writeln(
            'type "help" for help, and the list of supporeted commands.');
      }
    }
  }
}
