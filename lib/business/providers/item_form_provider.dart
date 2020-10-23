part of business_library;

//New Only
class ItemForm with ChangeNotifier {
  final Business business;

  String name;
  String details;

  bool isSelectedMonday = false;
  bool isSelectedTuesday = false;
  bool isSelectedWednesday = false;
  bool isSelectedThursday = false;
  bool isSelectedFriday = false;
  bool isSelectedSaturday = false;
  bool isSelectedSunday = false;

  ItemForm({@required this.business});

  bool get validateSelectedDays =>
      isSelectedMonday ||
      isSelectedTuesday ||
      isSelectedWednesday ||
      isSelectedThursday ||
      isSelectedFriday ||
      isSelectedSaturday ||
      isSelectedSunday;

  OperationalHours operationalHours = OperationalHours.template();

  void setHours(OperationalHours newHours){
    operationalHours = newHours;
  }

  List<Map<String, dynamic>> toMapList() {
    List<Map<String, dynamic>> mapList = new List<Map<String, dynamic>>();

    if (isSelectedSunday) {
      mapList.add(toMap("SUNDAY"));
    }
    if (isSelectedMonday) {
      mapList.add(toMap("MONDAY"));
    }
    if (isSelectedTuesday) {
      mapList.add(toMap("TUESDAY"));
    }
    if (isSelectedWednesday) {
      mapList.add(toMap("WEDNESDAY"));
    }
    if (isSelectedThursday) {
      mapList.add(toMap("THURSDAY"));
    }
    if (isSelectedFriday) {
      mapList.add(toMap("FRIDAY"));
    }
    if (isSelectedSaturday) {
      mapList.add(toMap("SATURDAY"));
    }

    //Handle list being empty? this function will never kick off unless 1 is selected

    return mapList;
  }

  Map<String, dynamic> toMap(String day) {
    GeoPoint geoPoint = business.geoPoint;

    GeoHash geoHash =
        GeoHash(geoPoint.latitude, geoPoint.longitude);


    return {
      'name': name,
      'details': details,
      'favorites': 0,
      'business_id': business.id,
      'business_name': business.name,
      'street_name': business.streetName,
      'street_number': business.streetNumber,
      'city': business.city,
      'state': business.state,
      'zip': business.zip,

      'day': day,
      'start': operationalHours.start,
      'end': operationalHours.end,
      'bleeds': operationalHours.bleeds,

      // 'monday': operationalHoursProvider.mondayHours.toMap(),
      // 'tuesday': operationalHoursProvider.tuesdayHours.toMap(),
      // 'wednesday': operationalHoursProvider.wednesdayHours.toMap(),
      // 'thursday': operationalHoursProvider.thursdayHours.toMap(),
      // 'friday': operationalHoursProvider.fridayHours.toMap(),
      // 'saturday': operationalHoursProvider.saturdayHours.toMap(),
      // 'sunday': operationalHoursProvider.sundayHours.toMap(),
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
