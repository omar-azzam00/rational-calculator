import '../classes/CalculatorShell.dart';

void calculatorShell_isCommand_unitTest(CalculatorShell shell) {
  for (int i = 0; i < command.values.length; i++) {
    assert(shell.isCommand(command.values[i].name));
  }

  assert(!shell.isCommand('14'));
  assert(!shell.isCommand('23/543'));
  assert(!shell.isCommand('hello'));
  assert(!shell.isCommand('omar'));
  assert(!shell.isCommand(''));
  assert(!shell.isCommand('    '));
  assert(!shell.isCommand('\n'));
  assert(!shell.isCommand('\n help \n \n'));
}
