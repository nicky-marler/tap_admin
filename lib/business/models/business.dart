//import 'dart:convert';

part of business_library;

//class Business with ChangeNotifier {
class Business {
  final String id;
  final String name;
  final int favorites;
  final GeoPoint geoPoint;
  //final LocationAddress locationAddress;
  final String streetName;
  final String streetNumber;
  final String city;
  final String state;
  final String zip;

  final OperationalHours monday;
  final OperationalHours tuesday;
  final OperationalHours wednesday;
  final OperationalHours thursday;
  final OperationalHours friday;
  final OperationalHours saturday;
  final OperationalHours sunday;

  final DateTime dateCreated;
  final DateTime lastModified;

  String distance;

  Business({
    @required this.id,
    @required this.name,
    @required this.favorites,
    @required this.geoPoint,
    //@required this.locationAddress,
    @required this.streetName,
    @required this.streetNumber,
    @required this.city,
    @required this.state,
    @required this.zip,
    @required this.dateCreated,
    @required this.lastModified,
    @required this.monday,
    @required this.tuesday,
    @required this.wednesday,
    @required this.thursday,
    @required this.friday,
    @required this.saturday,
    @required this.sunday,
  });

  factory Business.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();

    print(doc.reference.toString());

    return Business(
      id: doc.id,
      name: data['name'] ?? 'Missing',
      favorites: data['favorites'] ?? 0,
      geoPoint: data['geo_point'] ?? GeoPoint(0, 0),
      //locationAddress: LocationAddress.fromFirestore(data['address']) ?? LocationAddress.unknown(),
      streetName: data['street_name'] ?? 'Unknown',
      streetNumber: data['street_number'] ?? 'Unknown',
      city: data['city'] ?? 'Unknown',
      state: data['state'] ?? 'Unknown',
      zip: data['zip'] ?? 'Unknown',
      monday: OperationalHours.fromFirestore(data['monday']) ??
          OperationalHours.isClosed(),
      tuesday: OperationalHours.fromFirestore(data['tuesday']) ??
          OperationalHours.isClosed(),
      wednesday: OperationalHours.fromFirestore(data['wednesday']) ??
          OperationalHours.isClosed(),
      thursday: OperationalHours.fromFirestore(data['thursday']) ??
          OperationalHours.isClosed(),
      friday: OperationalHours.fromFirestore(data['friday']) ??
          OperationalHours.isClosed(),
      saturday: OperationalHours.fromFirestore(data['saturday']) ??
          OperationalHours.isClosed(),
      sunday: OperationalHours.fromFirestore(data['sunday']) ??
          OperationalHours.isClosed(),
      dateCreated: data['date_created'].toDate() ?? DateTime.now(),
      lastModified: data['last_modified'].toDate() ?? DateTime.now(),
      // userPosition: _userPosition ?? geo.Position(longitude: 0, latitude: 0)
    );
  }

  @override
  String toString() => "Business <$name:$streetName>";

  Future<void> setDistance() async {
    Position userPosition = LocationService.userPosition;

    double distanceInMeters = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        this.geoPoint.latitude,
        this.geoPoint.longitude);
    String distanceInMiles = (distanceInMeters * 0.00062137).toStringAsFixed(1);

    distance = distanceInMiles;
  }
}
