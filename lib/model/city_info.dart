import 'package:latlong/latlong.dart';

class CityInfo {
  String name;
  LatLng latLng;
  double defaultZoom = 18;

  CityInfo(this.name, this.latLng);
}
