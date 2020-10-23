part of location_library;

enum PlacemarkScreenType { Form, Filter }

class LocationService {
  //static bool _permission = false;
  static bool filterCurrentLocation = true;
  static bool tempFilterCurrentLocation = true;

  static Placemark placemark;
  static Placemark _userPlacemark;
  static Position _userPosition;

  static PlacemarkScreenType locationScreenType;

  static Placemark formPlacemark;
  static Placemark filterPlacemark;

  //Texas state capital is the default. Avoiding null-pointer
  static double get defaultLatitude => 30.2746652;
  static double get defaultLongitude => -97.7425392;

  static String error;

  static Placemark selectPlacemark;
  static bool isNewSelectPlacemark = true;
  static List<Location> _listLocations = [];
  static List<Placemark> _listPlacemarks = [];
  static bool isNeedingGet = true;

  static Future<void> getListPlacemark(String _address) async {
    try {
      _listLocations = await locationFromAddress(_address);
      _listPlacemarks = await placemarkFromCoordinates(
          _listLocations.first.latitude, _listLocations.first.longitude);
    } on PlatformException catch (e) {
      if (e.code == "ERROR_GEOCODNG_ADDRESSNOTFOUND") {
        error = "Unable to find coordinates matching the supplied address.";
      }
      _listPlacemarks = [];
    }
  }

  static List<Placemark> get placemarks {
    return [..._listPlacemarks];
  }

  static Placemark get userPlacemark {
    return _userPlacemark;
  }

  static Position get userPosition {
    return _userPosition;
  }

  static Future<void> setUserPlacemark() async {
    try {
      _userPosition = await Geolocator.getCurrentPosition();
      _userPlacemark = await placemarkFromCoordinates(
              _userPosition.latitude, _userPosition.longitude)
          .then((placemarkList) {
        return placemarkList.first;
      });
    } on PlatformException catch (e) {
      if (e.code == "ERROR_GEOCODNG_ADDRESSNOTFOUND") {
        error = "Unable to find coordinates matching the supplied address.";
      } else {
        error = "Unable to fetch supplied coordinates. Try refreshing screen";
      }
      _userPlacemark = null;
      _userPosition = null;
    } on PermissionDefinitionsNotFoundException catch (e) {
      error =
          "No location permissions are defined in the manifest. Make sure at least ACCESS_FINE_LOCATION or ACCESS_COARSE_LOCATION are defined in the manifest.";
      await Geolocator.requestPermission();
      //TODO: Update theese null values
      _userPlacemark = null;
      _userPosition = null;
    } on PermissionDeniedException catch (e) {
      error = "User denied permissions to access the device's location.";
      await Geolocator.requestPermission();
      //TODO: Update theese null values
      _userPlacemark = null;
      _userPosition = null;
    } catch (e) {
      //just in case
      _userPosition = null;
      _userPlacemark = null;
    }
  }
}
