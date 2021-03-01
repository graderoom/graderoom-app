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

  static final List<String> keys = [
    "username",
    "schoolUsername",
    "isAdmin",
    "personalInfo",
    "appearance",
    "alerts",
    "gradeSync",
    "sortingData",
    "beta",
    "betaFeatures",
    "sunset",
    "sunrise",
  ];

  String username;
  String schoolUsername;
  bool isAdmin;
  Map<String, dynamic> personalInfo;
  Map<String, dynamic> appearance;
  Map<String, dynamic> alerts;
  bool gradeSync;
  Map<String, dynamic> sortingData;
  bool beta;
  Map<String, dynamic> betaFeatures;
  int sunset;
  int sunrise;

  factory Settings.fromMapOrResponse(Map<String, dynamic> _json) {
    if (_json["personalInfo"] is String) {
      _json["personalInfo"] = json.decode(_json["personalInfo"]);
    }
    if (_json["appearance"] is String) {
      _json["appearance"] = json.decode(_json["appearance"]);
    }
    if (_json["alerts"] is String) {
      _json["alerts"] = json.decode(_json["alerts"]);
    }
    if (_json["sortingData"] is String) {
      _json["sortingData"] = json.decode(_json["sortingData"]);
    }
    if (_json["betaFeatures"] is String) {
      _json["betaFeatures"] = json.decode(_json["betaFeatures"]);
    }
    return Settings(
      username: _json["username"] as String,
      schoolUsername: _json["schoolUsername"] as String,
      isAdmin: _json["isAdmin"] as bool,
      personalInfo: _json["personalInfo"] as Map<String, dynamic>,
      appearance: _json["appearance"] as Map<String, dynamic>,
      alerts: _json["alerts"] as Map<String, dynamic>,
      gradeSync: _json["gradeSync"] as bool,
      sortingData: _json["sortingData"] as Map<String, dynamic>,
      beta: _json["beta"] as bool,
      betaFeatures: _json["betaFeatures"] as Map<String, dynamic>,
      sunset: _json["sunset"] as int,
      sunrise: _json["sunrise"] as int,
    );
  }

  Map<String, dynamic> toMap() => {
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
}
