import 'package:flutter/material.dart';

class LocaleNotifier extends ChangeNotifier {
  Locale _locale = const Locale('fr'); // default

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!['fr', 'ar'].contains(locale.languageCode)) return;
    _locale = locale;
    notifyListeners();
  }
}
