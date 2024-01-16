extension ExtendedString on String {
  String get shortenCoreId {
    if (length > 18) return replaceRange(4, length - 4, "...");
    return this;
  }

  String get endOfCoreId {
    if (length > 18) return replaceRange(0, length - 4, '');
    return this;
  }
}
