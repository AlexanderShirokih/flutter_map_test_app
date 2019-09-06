import 'dart:collection' show HashMap;

import 'package:flutter/material.dart';
import 'package:ppa_app/model/poi_item.dart';

class MarkerIconsLookup {
  static const Map<POIType, String> PIN_ICONS = {
    POIType.FoodPoint: "assets/images/pin_where_to_eat.png",
    POIType.Atm: "assets/images/pin_atms.png",
    POIType.GreenArea: "assets/images/pin_green_areas.png",
    POIType.Shop: "assets/images/pin_shops.png",
    POIType.Sos: "assets/images/pin_sos.png",
    POIType.StreetFurniture: "assets/images/pin_street_furniture.png",
    POIType.Playground: "assets/images/pin_playgrounds.png"
  };

  HashMap<String, Image> _cache = HashMap();

  /// Returns appropriate `Image` to given `POIType`.
  /// If there are no icon for current `POIType` will return null.
  Widget getIcon(POIType type) {
    if (PIN_ICONS.containsKey(type)) return _getIconFromAssets(PIN_ICONS[type]);
    return null;
  }

  Widget _getIconFromAssets(String path) {
    var image = _cache[path];

    if (image == null) {
      image = Image.asset(path);
      _cache[path] = image;
    }

    return image;
  }

  /// Used to clear cache.
  clear() => _cache.clear();
}
