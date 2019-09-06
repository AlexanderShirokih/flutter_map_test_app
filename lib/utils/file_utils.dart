import 'dart:async' show Future;

import 'package:flutter/services.dart';

class FileUtils {
  static Future<String> readConfig(String name) async {
    return await rootBundle.loadString("assets/config/$name");
  }
}
