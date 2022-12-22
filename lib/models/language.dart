class Language {
  final int id;
  final String name;
  final String languageCode;
  final String flag;

  Language(this.id, this.flag, this.name, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      Language(1,"🏴󠁥󠁳󠁣󠁴󠁿","Català", "ca"),
      Language(2,"🇺🇸", "English", "en"),
      Language(3,"🇪🇸","Español", "es"),
    ];
  }
}