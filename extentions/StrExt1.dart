/// some methods added to string which will be needed by
/// the CalculatorShell class or any other class.
extension StrExt1 on String {
  /// get how many lines in a string
  int get lines {
    int count = 1;

    for (int i = 0; i < this.length; i++) {
      if (this[i] == '\n') {
        count++;
      }
    }

    return count;
  }

  /// check if a string is a fraction like this "5/9" or like this "4.34/65"
  bool get isFraction {
    int overSignCount = 0;
    int? overSignPlace;
    for (int i = 0; i < this.length; i++) {
      if (this[i] == '/') {
        overSignCount++;
        overSignPlace = i;
      }
    }

    if (overSignCount != 1) return false;

    if (overSignPlace == 0 || overSignPlace == this.length - 1) return false;

    // check if the left side valid number
    if (double.tryParse(this.substring(0, overSignPlace)) == null) return false;

    // check if the right side is valid number
    if (double.tryParse(this.substring(overSignPlace! + 1)) == null)
      return false;

    return true;
  }

  /// this function will parse a fraction and return it is double
  /// equalivent, you should check if it is a fraction first to avoid any
  /// unexpected behaviour
  double parseFraction() {
    int? overSignIndex;
    for (int i = 0; i < this.length; i++) {
      if (this[i] == '/') {
        overSignIndex = i;
      }
    }

    return double.parse(this.substring(0, overSignIndex)) /
        double.parse(this.substring(overSignIndex! + 1));
  }
}
