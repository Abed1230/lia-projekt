abstract class UtilFunctions {
  static bool inBounds(int index, List array) {
    return (index >= 0) && (index < array.length);
  }
}
