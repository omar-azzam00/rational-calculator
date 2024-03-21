import '../classes/CalculatorShell.dart';

void calculatorShell_performMathOperationFrac_unitTest(CalculatorShell shell) {
  var tokens = shell.getTokens('120 + 4 * 3 / 4 + 32 / 5');

  if (shell.isValidMathOperation(tokens)) {
    shell.performMathOperationFrac(tokens);
  }
}
