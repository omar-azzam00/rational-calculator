import '../classes/CalculatorShell.dart';
import '../extentions/ListExt1.dart';

void calculatorShell_getTokens_unitTest(CalculatorShell shell) {
  var test1 = shell.getTokens('    saveTo     a.txt      b.txt    c.txt    ');
  assert(test1.length == 4);
  assert(test1.isEqual(['saveTo', 'a.txt', 'b.txt', 'c.txt']));

  var test2 = shell.getTokens(' \n\n saveTo \n \n b.txt  \n c.txt \n ');
  assert(test2.length == 3);
  assert(test2.isEqual<String>(['saveTo', 'b.txt', 'c.txt']));

  var test3 = shell.getTokens(' \n \n \n         \n     \n');
  assert(test3.length == 0);
  assert(test3.isEqual<String>([]));

  var test4 = shell.getTokens('       hello    ');
  assert(test4.length == 1);
  assert(test4.isEqual<String>(['hello']));

  var test5 = shell.getTokens('hello');
  assert(test5.length == 1);
  assert(test5.isEqual<String>(['hello']));

  var test6 = shell.getTokens('10 * 50 / 4/5 * 12 - -12.5/65.3');
  assert(test6.length == 9);
  assert(test6.isEqual<String>(
      ['10', '*', '50', '/', '4/5', '*', '12', '-', '-12.5/65.3']));
}
