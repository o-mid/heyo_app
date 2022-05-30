extension ExtendedString on String {
  String get shortenCoreId {
    if (length > 18) return replaceRange(4, length - 4, "...");
    return this;
  }
}
