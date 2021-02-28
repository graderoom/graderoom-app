import 'dart:convert';

class Settings {
  Settings({
    this.username,
    this.schoolUsername,
    this.isAdmin,
    this.personalInfo,
    this.appearance,
    this.alerts,
    this.gradeSync,
    this.sortingData,
    this.beta,
    this.betaFeatures,
    this.sunset,
    this.sunrise,
  });

  static final Map<String, String> sqlColumns = {
    "username": "TEXT",
    "schoolUsername": "TEXT",
    "isAdmin": "INTEGER",
    "personalInfo": "TEXT", // Store as json string
    "appearance": "TEXT", // Store as json string
    "alerts": "TEXT", // Store as json string
    "gradeSync": "INTEGER",
    "sortingData": "TEXT", // Store as json string
    "beta": "INTEGER",
    "betaFeatures": "TEXT", // Store as json string
    "sunset": "INTEGER",
    "sunrise": "INTEGER",
  };

  static String get sqlModel => sqlColumns.entries.map((e) => e.key + " " + e.value).join(", ");

  String username;
  String schoolUsername;
  int isAdmin;
  String personalInfo;
  String appearance;
  String alerts;
  int gradeSync;
  String sortingData;
  int beta;
  String betaFeatures;
  int sunset;
  int sunrise;

  factory Settings.fromJsonOrSql(Map<String, dynamic> _json) {
    if (([true, false]).contains(_json["isAdmin"])) {
      _json["isAdmin"] = _json["isAdmin"] ? 1 : 0;
    }
    if (!(_json["personalInfo"] is String)) {
      _json["personalInfo"] = json.encode(_json["personalInfo"]);
    }
    if (!(_json["appearance"] is String)) {
      _json["appearance"] = json.encode(_json["appearance"]);
    }
    if (!(_json["alerts"] is String)) {
      _json["alerts"] = json.encode(_json["alerts"]);
    }
    if (([true, false]).contains(_json["gradeSync"])) {
      _json["gradeSync"] = _json["gradeSync"] ? 1 : 0;
    }
    if (!(_json["sortingData"] is String)) {
      _json["sortingData"] = json.encode(_json["sortingData"]);
    }
    if (([true, false]).contains(_json["beta"])) {
      _json["beta"] = _json["beta"] ? 1 : 0;
    }
    if (!(_json["betaFeatures"] is String)) {
      _json["betaFeatures"] = json.encode(_json["betaFeatures"]);
    }
    return Settings(
      username: _json["username"],
      schoolUsername: _json["schoolUsername"],
      isAdmin: _json["isAdmin"],
      personalInfo: _json["personalInfo"],
      appearance: _json["appearance"],
      alerts: _json["alerts"],
      gradeSync: _json["gradeSync"],
      sortingData: _json["sortingData"],
      beta: _json["beta"],
      betaFeatures: _json["betaFeatures"],
      sunset: _json["sunset"],
      sunrise: _json["sunrise"],
    );
  }

  Map<String, dynamic> toSql() => {
        "username": username,
        "schoolUsername": schoolUsername,
        "isAdmin": isAdmin,
        "personalInfo": personalInfo,
        "appearance": appearance,
        "alerts": alerts,
        "gradeSync": gradeSync,
        "sortingData": sortingData,
        "beta": beta,
        "betaFeatures": betaFeatures,
        "sunset": sunset,
        "sunrise": sunrise,
      };

  Map<String, dynamic> toJson() => {
        "username": username,
        "schoolUsername": schoolUsername,
        "isAdmin": isAdmin == 1,
        "personalInfo": json.decode(personalInfo),
        "appearance": json.decode(appearance),
        "alerts": json.decode(alerts),
        "gradeSync": gradeSync == 1,
        "sortingData": json.decode(sortingData),
        "beta": beta == 1,
        "betaFeatures": json.decode(betaFeatures),
        "sunset": sunset,
        "sunrise": sunrise,
      };
}
