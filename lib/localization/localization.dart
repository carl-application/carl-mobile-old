import 'dart:async';

import 'package:carl/localization/localization_strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Localization {
  final Locale locale;

  Localization(this.locale);

  static Localization of(BuildContext context) {
    return Localizations.of<Localization>(context, Localization);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'fr': fr,
    'en': en
  };

  _getValue(String key) => _localizedValues[locale.languageCode][key];

  String get welcomePageTitle => _getValue(WelcomePageTitle);

  String get welcomePageSubtitle => _getValue(WelcomePageSubtitle);

  String get welcomePageLoginButtonLabel =>
      _getValue(WelcomePageLoginButtonLabel);

  String get welcomePageRegisterButtonLabel =>
      _getValue(WelcomePageRegisterButtonLabel);
}

class LocalizationDelegate extends LocalizationsDelegate<Localization> {
  const LocalizationDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fr'].contains(locale.languageCode);

  @override
  Future<Localization> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of Localization.
    return SynchronousFuture<Localization>(Localization(locale));
  }

  @override
  bool shouldReload(LocalizationDelegate old) => false;
}
