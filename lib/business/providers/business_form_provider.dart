part of business_library;

//New Only
class BusinessForm {
  String name;
  Placemark placemark;
  Location location;

  OperationalHoursProvider operationalHoursProvider =
      OperationalHoursProvider();

  Future<void> setLocation() async {
    List<Location> listLocation = await locationFromAddress(placemark.street + placemark.isoCountryCode + 
      placemark.country + placemark.postalCode + placemark.administrativeArea + placemark.subAdministrativeArea + 
      placemark.locality + placemark.subLocality + placemark.thoroughfare + placemark.subThoroughfare);

    this.location = listLocation.first;
  }

  Map<String, dynamic> toMap() {
    GeoHash geoHash =
        GeoHash(location.latitude, location.longitude);

    GeoPoint geoPoint =
        GeoPoint(location.latitude, location.longitude);

    return {
      'name': name,
      'favorites': 0,
      'street_name': placemark.thoroughfare,
      'street_number': placemark.subThoroughfare,
      'city': placemark.locality,
      'state': placemark.administrativeArea,
      'zip': placemark.postalCode,

      'monday': operationalHoursProvider.mondayHours.toMap(),
      'tuesday': operationalHoursProvider.tuesdayHours.toMap(),
      'wednesday': operationalHoursProvider.wednesdayHours.toMap(),
      'thursday': operationalHoursProvider.thursdayHours.toMap(),
      'friday': operationalHoursProvider.fridayHours.toMap(),
      'saturday': operationalHoursProvider.saturdayHours.toMap(),
      'sunday': operationalHoursProvider.sundayHours.toMap(),
      'geo_point': geoPoint,
      'latHash_1A': geoHash.latHash_1A,
      'latHash_1B': geoHash.latHash_1B,
      'latHash_1C': geoHash.latHash_1C,
      'longHash_1A': geoHash.longHash_1A,
      'longHash_1B': geoHash.longHash_1B,
      'longHash_1C': geoHash.longHash_1C,
      'latHash_5A': geoHash.latHash_5A,
      'latHash_5B': geoHash.latHash_5B,
      'latHash_5C': geoHash.latHash_5C,
      'longHash_5A': geoHash.longHash_5A,
      'longHash_5B': geoHash.longHash_5B,
      'longHash_5C': geoHash.longHash_5C,
      'latHash_20A': geoHash.latHash_20A,
      'latHash_20B': geoHash.latHash_20B,
      'latHash_20C': geoHash.latHash_20C,
      'longHash_20A': geoHash.longHash_20A,
      'longHash_20B': geoHash.longHash_20B,
      'longHash_20C': geoHash.longHash_20C,
      //Date created and modifed may need to be OnInsert
      'date_created': FieldValue.serverTimestamp(),
      'last_modified': FieldValue.serverTimestamp(),
    };
  }
}
