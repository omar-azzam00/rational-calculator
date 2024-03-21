import '../classes/CalculatorShell.dart';
import 'calculatorShell_getTokens_unitTest.dart';
import 'calculatorShell_isCommand_unitTest.dart';
import 'calculatorShell_performMathOperationFrac_unitTest.dart';

void main() {
  var shell = CalculatorShell();

  calculatorShell_getTokens_unitTest(shell);
  calculatorShell_isCommand_unitTest(shell);
  calculatorShell_performMathOperationFrac_unitTest(shell);
}
