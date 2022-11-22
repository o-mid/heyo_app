String getMockIconUrl() {
  String iconUrl = ([
    "https://raw.githubusercontent.com/Zunawe/identicons/HEAD/examples/poly.png",
    "https://avatars.githubusercontent.com/u/6634136?v=4",
    "https://avatars.githubusercontent.com/u/9801359?v=4",
  ]..shuffle())
      .first;

  return iconUrl;
}
