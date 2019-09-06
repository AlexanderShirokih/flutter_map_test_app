import 'package:latlong/latlong.dart';
import 'package:ppa_app/utils/bounding_box.dart';

enum POIType {
  Unknown,
  FoodPoint,
  Playground,
  Atm,
  GreenArea,
  Shop,
  Sos,
  StreetFurniture
}

class POIItem {
  final String name;
  final LatLng latLng;
  final POIType type;

  POIItem(this.latLng, {this.name = "", this.type = POIType.Unknown});

  /// Converts json representation to POI item
  POIItem.fromJson(Map<String, dynamic> json, String tag)
      : assert(json['type'] == 'node'),
        latLng = LatLng(json['lat'], json['lon']),
        type = _getTagType(json['tags'], tag),
        name = _getFromTagsOrDefault(json['tags'], "name", "");

  /// Returns value of `tag` if it exists or `defValue` otherwise.
  /// For ex.: tags: {amenity: cafe, name: MyCafe}} - returns 'MyCafe'
  ///          tags: {amenity: cafe}} - returns `defValue`
  static dynamic _getFromTagsOrDefault(
      Map<String, dynamic> tags, String tag, String defValue) {
    if (tags == null || !tags.containsKey(tag)) return defValue;
    return tags[tag];
  }

  @override
  String toString() {
    return "POIItem[name=$name, type=$type, loc=$latLng]";
  }

  /// Converts amenity type to POIType. returns POIType.Unknown if the amenity is unknown
  static POIType _getTagType(Map<String, dynamic> tags, String tag) {
    assert(tags != null);
    switch (tag) {
      case Node.AMENITY:
        return POIGroup.findTypeOfAmenity(tags[Node.AMENITY]);
      default:
        {
          //TODO: Handle ATMs
          print("Unknown tag type: ${tags.toString()}");
          return POIType.Unknown;
        }
    }
  }
}

class Node {
  static const AMENITY = "amenity";
  static const ATM = "atm";
  final String tag;
  final String value;
  final bool strict;

  Node([this.tag = "", this.value = "", this.strict = true]);

  const Node.amenity(String value, [bool strict = true])
      : tag = AMENITY,
        this.value = value,
        this.strict = strict;

  /// Formats node by following pattern:
  /// strict == true  : node["tag"="value"]
  /// strict == false : node["tag"~"value"]
  @override
  String toString() => "node[\"$tag\"${strict ? "=" : "~"}\"$value\"];";
}

class POIGroup {
  POIType type;
  List<Node> nodes;

  POIGroup(this.type, this.nodes);

  factory POIGroup.unknown() => POIGroup(POIType.Unknown, []);

  static List<POIGroup> groups = [
    POIGroup(POIType.FoodPoint, [
      Node.amenity("cafe"),
      Node.amenity("restaurant"),
      Node.amenity("fast_food")
    ]),
    POIGroup(POIType.Atm, [Node.amenity("atm"), Node("atm", "yes")]),
    POIGroup(POIType.Shop,
        [Node.amenity("market", false), Node.amenity("shop", false)])
  ];

  /// Returns POIType associated with amenityName or POIType.Unknown if its not found.
  static POIType findTypeOfAmenity(String amenityName) {
    final result = groups.firstWhere(
        (entry) => entry.nodes.any((node) => node.value == amenityName),
        orElse: () => POIGroup.unknown());
    return result.type;
  }

  /// Returns list contains all tags named with `tag`.
  static List<Node> findNodesByTag(String tag) {
    final result = List<Node>();
    for (var group in groups)
      result.addAll(group.nodes.where((node) => node.tag == tag));
    return result;
  }

  /// Constructs Overpass query to get items of specified POIType in BoundingBox
  static String buildQuery(BoundingBox boundingBox, String tag) {
    final nodes = POIGroup.findNodesByTag(tag);
    if (nodes == null) throw "Nodes for tag $tag not found";

    final buffer = StringBuffer("[bbox:");
    buffer.write(boundingBox);
    buffer.write("][timeout:25];(");

    nodes.forEach((Node item) {
      buffer.write(item);
    });
    nodes.clear();

    buffer.write(");out;");
    return buffer.toString();
  }
}
