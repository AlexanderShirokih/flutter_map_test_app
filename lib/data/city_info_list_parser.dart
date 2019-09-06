import 'dart:convert';

import 'package:latlong/latlong.dart' show LatLng;
import 'package:ppa_app/utils/file_utils.dart';

import '../model/city_info.dart' show CityInfo;

class CityInfoListParser {
  static Future<List<CityInfo>> fromJson(String configFile) async {
    final content = await FileUtils.readConfig(configFile);
    final List<dynamic> data = jsonDecode(content);
    return data.map((value) => parseCityInfo(value)).toList();
  }

  static CityInfo parseCityInfo(Map<String, dynamic> item) {
    return CityInfo(item['name'], LatLng(item['lat'], item['lon']));
  }
}
