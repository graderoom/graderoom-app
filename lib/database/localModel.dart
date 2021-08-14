class Local {
  Local({
    this.theme,
    this.showDebugToasts,
    this.stayLoggedIn,
  });

  static final List<String> keys = [
    "theme",
    "showDebugToasts",
    "stayLoggedIn",
  ];

  String? theme;
  bool? showDebugToasts;
  bool? stayLoggedIn;

  factory Local.fromMap(Map<String, dynamic>? _json) {
    if (_json == null) {
      return Local(
        theme: null,
        showDebugToasts: null,
        stayLoggedIn: null,
      );
    }
    return Local(
      theme: _json["theme"],
      showDebugToasts: _json["showDebugToasts"],
      stayLoggedIn: _json["stayLoggedIn"],
    );
  }

  Map<String, dynamic> toMap() => {
        "theme": theme,
        "showDebugToasts": showDebugToasts,
        "stayLoggedIn": stayLoggedIn,
      };
}
