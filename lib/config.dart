import 'package:flutter/foundation.dart';

String get apiURL {
  bool isProd = const bool.fromEnvironment('dart.vm.product');
  if (isProd) {
    return 'https://mobilea.tk';
  } else {
    if (kIsWeb) {
      return "http://localhost:5432";
    } else {
      return "http://10.0.2.2:5432";
    }
  }
}