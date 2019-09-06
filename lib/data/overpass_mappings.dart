import 'package:ppa_app/model/poi_item.dart';
import 'package:ppa_app/utils/file_utils.dart' show FileUtils;
import 'package:xml/xml.dart' as xml;

class Batch {
  final List<POIGroup> groups;

  const Batch(this.groups);
}

class POIGroup {
  final POIType type;
  final List<Node> nodes;

  const POIGroup(this.type, this.nodes);
}

class Node {
  final List<Key> keys;

  const Node(this.keys);
}

class Key {
  final String name;
  final String value;
  final bool strict;

  const Key(this.name, this.value, [this.strict = false]);
}

class OverpassMappings {
  List<Batch> _batches;

  List<Batch> get bathes => _batches;

  OverpassMappings(xml.XmlDocument document) {
    _batches = _parseXml(document.rootElement);
  }

  static Future<OverpassMappings> fromAssets(String fileName) async {
    var content = FileUtils.readConfig(fileName);
    var doc = xml.parse(await content);
    return OverpassMappings(doc);
  }

  List<Batch> _parseXml(xml.XmlElement map) {
    var batches = List<Batch>();
    //TODO: to be continued...
    return batches;
  }
}
