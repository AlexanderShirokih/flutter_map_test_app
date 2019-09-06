import 'dart:convert' as convert;
import 'dart:core' as prefix0;
import 'dart:core';

import 'package:http/http.dart' as http;
import 'package:latlong/latlong.dart';
import 'package:ppa_app/model/poi_item.dart';
import 'package:ppa_app/utils/bounding_box.dart';

class OverpassApi {
  static const MAX_DISTANCE = 5.0;
  static const String OVERPASS_SERVER =
      "http://overpass-api.de/api/interpreter";
  static final OverpassApi _instance = new OverpassApi._internal();

  final Distance dist = Distance();

  OverpassApi._internal();

  Future<Iterable<POIItem>> getPOIs(LatLng center) async {
    var items = List<POIItem>();
    final bounds = BoundingBox.fromCenter(center, MAX_DISTANCE);

    items.addAll(await getMainAmenities(bounds, center));

    return items;
  }

  Future<Iterable<POIItem>> getMainAmenities(
      BoundingBox bounds, LatLng center) async {
    final query = POIGroup.buildQuery(bounds, Node.AMENITY);
    return _getJsonData(query)
        .then((elements) =>
            elements.map((e) => POIItem.fromJson(e, Node.AMENITY)))
        .then((elements) => _filterByDistance(elements, center));
  }

  //TODO: Merge methods into single query
  // like this: POIGroup.buildQuery(bounds, [Node.AMENITY, Node.ATM]);
  Future<Iterable<POIItem>> getATMs(BoundingBox bounds, LatLng center) async {
    final query = POIGroup.buildQuery(bounds, Node.ATM);
    return _getJsonData(query)
        .then((elements) => elements.map((e) => POIItem.fromJson(e, Node.ATM)))
        .then((elements) => _filterByDistance(elements, center));
  }

  Future<List<dynamic>> _getJsonData(String query) async {
    final url =
        "$OVERPASS_SERVER?data=%5Bout%3Ajson%5D${Uri.encodeFull(query)}";
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body)['elements'];
    } else {
      return Future.error(
          "Request failed with status: ${response.statusCode}.");
    }
  }

  Iterable<POIItem> _filterByDistance(
          Iterable<POIItem> elements, LatLng center) =>
      elements.skipWhile((t) =>
          dist.as(LengthUnit.Kilometer, center, t.latLng) < MAX_DISTANCE);

  factory OverpassApi() => _instance;
}
