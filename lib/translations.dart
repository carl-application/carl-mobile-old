import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show  rootBundle;

class Translations {
  Translations(Locale locale) {
    this.locale = locale;
    _localizedValues = null;
  }

  Locale locale;
  static Map<dynamic, dynamic> _localizedValues;

  static Translations of(BuildContext context){
    return Localizations.of<Translations>(context, Translations);
  }

  String text(String key) {
    return _localizedValues[key] ?? '** $key not found';
  }

  List<String> array(String key) {
    final List<String> array = [];
    _localizedValues[key].forEach((value) {
      array.add(value as String ?? '** $key not found');
    });
    print("array = $array");
    return array;
  }

  static Future<Translations> load(Locale locale) async {
    Translations translations = new Translations(locale);
    print("Locale = ${locale.languageCode}");
    String jsonContent = await rootBundle.loadString("locale/i18n_${locale.languageCode}.json");
    _localizedValues = json.decode(jsonContent);
    return translations;
  }

  get currentLanguage => locale.languageCode;
}

class TranslationsDelegate extends LocalizationsDelegate<Translations> {
  const TranslationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en','fr'].contains(locale.languageCode);

  @override
  Future<Translations> load(Locale locale) => Translations.load(locale);

  @override
  bool shouldReload(TranslationsDelegate old) => false;
}