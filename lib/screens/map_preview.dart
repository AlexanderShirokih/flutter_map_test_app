import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:ppa_app/model/poi_item.dart';
import 'package:ppa_app/resources/values/marker_icons_lookup.dart';
import 'package:ppa_app/viewModel/map_prevew_view_model.dart';

class MapPreview extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MapPreviewState();
  }
}

class _MapPreviewState extends State<MapPreview> {
  MapPreviewViewModel _mapPreviewViewModel = MapPreviewViewModel();
  MarkerIconsLookup _markerIcons = MarkerIconsLookup();

  @override
  void initState() {
    super.initState();
    _mapPreviewViewModel.init(() => {setState(() => {})});
  }

  @override
  void dispose() {
    super.dispose();
    _mapPreviewViewModel.dispose();
    _markerIcons.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (_mapPreviewViewModel.currentCity == null)
      return Center(child: CircularProgressIndicator());
    else
      return Scaffold(
          body: FlutterMap(
        options: MapOptions(
            plugins: [
              MarkerClusterPlugin(),
            ],
            minZoom: 13.0,
            center: _mapPreviewViewModel.currentCity.latLng,
            zoom: _mapPreviewViewModel.currentCity.defaultZoom),
        layers: [
          new TileLayerOptions(
              urlTemplate:
                  "https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
              additionalOptions: {
                'accessToken':
                    'pk.eyJ1IjoiYWxleGFuZGVyc2hpcm9raWgiLCJhIjoiY2p6cGl5OG05MDEzYTNubzJwaHoybHh0cyJ9.KSEu00wRhMfJvZ-7a8mbzQ',
                'id': 'mapbox.streets',
              }),
          MarkerClusterLayerOptions(
            maxClusterRadius: 120,
            size: Size(40, 40),
            fitBoundsOptions: FitBoundsOptions(
              padding: EdgeInsets.all(50),
            ),
            markers: _getMarkers(),
            polygonOptions: PolygonOptions(
                borderColor: Colors.blueAccent,
                color: Colors.black12,
                borderStrokeWidth: 3),
            builder: (context, markers) {
              return FloatingActionButton(
                child: Text(markers.length.toString()),
                onPressed: null,
              );
            },
          )
        ],
      ));
  }

  List<Marker> _getMarkers() => _mapPreviewViewModel.items
      .map((item) => _createMarker(item))
      .skipWhile((e) => e.point == null)
      .toList(growable: false);

  Marker _createMarker(POIItem item) {
    Widget icon = _markerIcons.getIcon(item.type);

    return icon == null
        ? Marker()
        : Marker(
            point: item.latLng,
            width: 50.0,
            height: 50.0,
            builder: (context) => Container(
                  child:
                      IconButton(iconSize: 50, icon: icon, onPressed: () => {}),
                ));
  }
}
