class Local {
  Local({
    this.theme,
    this.showDebugToasts,
  });

  static final List<String> keys = [
    "theme",
    "showDebugToasts",
  ];

  String theme;
  bool showDebugToasts;

  factory Local.fromMap(Map<String, dynamic> _json) {
    if (_json == null) {
      return Local(
        theme: null,
        showDebugToasts: null,
      );
    }
    return Local(
      theme: _json["theme"],
      showDebugToasts: _json["showDebugToasts"],
    );
  }

  Map<String, dynamic> toMap() => {
    "theme": theme,
    "showDebugToasts": showDebugToasts,
  };
}
