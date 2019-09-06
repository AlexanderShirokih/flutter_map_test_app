import 'package:ppa_app/data/city_info_list_parser.dart';
import 'package:ppa_app/data/repository/overpass_api.dart';
import 'package:ppa_app/model/city_info.dart';
import 'package:ppa_app/model/poi_item.dart';

class MapPreviewViewModel {
  OverpassApi api = OverpassApi();
  CityInfo _currentCity;
  List<POIItem> _items = List();

  get currentCity => _currentCity;

  List<POIItem> get items => _items;

  void init(Function onStateShouldBeUpdated) {
    CityInfoListParser.fromJson("cities.json")
        .then((result) {
          _currentCity = result.first;
          onStateShouldBeUpdated();
          return _currentCity;
        })
        /* 
          Currently use city center for fetching POIs
          Replace it with current user position, retrieved from GPS location. 
          TODO: Catch error of the next pipe.
         */
        .then((CityInfo curr) => api.getPOIs(curr.latLng))
        .then((foodPoints) {
          _items.addAll(foodPoints);
          onStateShouldBeUpdated();
          return _items;
        });
  }

  void dispose() {
    _items.clear();
  }
}
