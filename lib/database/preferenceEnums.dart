enum Themes {
  DARK,
  LIGHT,
  SYSTEM,
}

const Map<Themes, String> themeStrings = {
  Themes.DARK: "Dark",
  Themes.LIGHT: "Light",
  Themes.SYSTEM: "System",
};

const Map<String, Themes> themeEnumValues = {
  "Dark": Themes.DARK,
  "Light": Themes.LIGHT,
  "System": Themes.SYSTEM,
};