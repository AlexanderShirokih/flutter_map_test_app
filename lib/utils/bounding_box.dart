import 'package:latlong/latlong.dart';

class BoundingBox {
  static const double _EARTH_CIRCLE = 40075;
  static const double _ANGULAR_RADIUS_PER_DIST = 360.0 / _EARTH_CIRCLE;

  final LatLng min;
  final LatLng max;

  BoundingBox({this.min, this.max});

  factory BoundingBox.fromCenter(LatLng center, double radiusInKm) {
    double radius = _ANGULAR_RADIUS_PER_DIST * radiusInKm;
    return BoundingBox(
        min: LatLng(center.latitude - radius, center.longitude - radius),
        max: LatLng(center.latitude + radius, center.longitude + radius));
  }

  @override
  String toString() {
    return "${min.latitude},${min.longitude},${max.latitude},${max.longitude}";
  }
}
