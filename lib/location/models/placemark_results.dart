part of location_library;

class PlacemarkResults{
  PlacemarkResults({@required this.placemark, @required this.type});

  Placemark placemark;
  PlacemarkResultsType type;
}

enum PlacemarkResultsType {
  User,
  Select,
}