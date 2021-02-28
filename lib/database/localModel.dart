class Local {
  Local({
    this.theme,
    this.showDebugToasts,
  });

  static final Map<String, String> sqlColumns = {
    "theme": "TEXT",
    "showDebugToasts": "INTEGER",
  };

  static String get sqlModel => sqlColumns.entries.map((e) => e.key + " " + e.value).join(", ");

  String theme;
  int showDebugToasts;

  factory Local.fromJsonOrSql(Map<String, dynamic> _json) {
    if (([true, false]).contains(_json["showDebugToasts"])) {
      _json["showDebugToasts"] = _json["showDebugToasts"] ? 1 : 0;
    }
    return Local(
      theme: _json["theme"],
      showDebugToasts: _json["showDebugToasts"],
    );
  }

  Map<String, dynamic> toSql() => {
    "theme": theme,
    "showDebugToasts": showDebugToasts,
  };

  Map<String, dynamic> toJson() => {
    "theme": theme,
    "showDebugToasts": showDebugToasts == 1,
  };
}
