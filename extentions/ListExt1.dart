extension ListExt1 on List {
  /// check if two lists are exactly equal
  bool isEqual<T extends Object>(List<T> b) {
    if (this.length != b.length) {
      return false;
    }

    for (int i = 0; i < this.length; i++) {
      if (this[i] != b[i]) {
        return false;
      }
    }

    return true;
  }
}
