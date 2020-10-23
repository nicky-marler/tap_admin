part of business_library;

enum FilterDistance { None, One, Five, Twenty }

enum SortBy { Favorite, Newest, A_to_Z, Z_to_A }

class BusinessProvider with ChangeNotifier {
  static final FirebaseFirestore _db = DatabaseService.db;
  List<Business> _businesses = [];
  Business selectedBusiness;
  FilterDistance _filterDistance = FilterDistance.None;
  SortBy _sortBy = SortBy.Newest;
  Placemark filterPlacemark;
  bool filterCurrentLocation = true;

  bool isNeedingGet = true;
  bool showSuccessSnack = false;

  CollectionReference get businessCollection => _db.collection('business');
  static CollectionReference get itemCollection => _db.collection('item');

  List<Business> get businesses {
    return [..._businesses];
  }

  Future<void> getBusinesses() async {
    Query query = await getQuery();
    QuerySnapshot results = await query.get();
    _businesses =
        results.docs.map((doc) => Business.fromFirestore(doc)).toList();
    await Future.forEach(
        _businesses, (Business business) => business.setDistance());
  }

  static Future<List<Item>> getItemsByDay(String day, String businessId) async {
    Query query = itemCollection
        .where('day', isEqualTo: day)
        .where('business_id', isEqualTo: businessId)
        .orderBy('name');
    print(day);

    QuerySnapshot results = await query.get();
    List<Item> itemList =
        results.docs.map((doc) => Item.fromFirestore(doc)).toList();
    return itemList;
  }

  void popWithSuccess(BuildContext context) {
    isNeedingGet = true;
    showSuccessSnack = true;
    Navigator.popUntil(
      context,
      ModalRoute.withName(Navigator.defaultRouteName),
    );

    //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Submission was Successful!')));
  }

  //Returns business ID, Not using, but maybe one day.
  Future<DocumentReference> addBusiness(
      Map<String, dynamic> businessMap) async {
    return await businessCollection.add(businessMap);
  }

  //Return no Item ID. Don't need it.
  Future<void> addItems(List<Map<String, dynamic>> itemMapList) async {
    final batchWrite = _db.batch();
    DocumentReference newItemRef;
    for (Map<String, dynamic> itemData in itemMapList) {
      //Getting auto generated ID for batch items.
      newItemRef = itemCollection.doc();
      batchWrite.set(newItemRef, itemData);
    }
    return await batchWrite.commit();
  }

  //Delete item
  static Future<void> deleteItem(String itemId) async {
    return itemCollection.doc(itemId).delete();
  }

  //Build the database query to fetch businesses based on location.
  Future<Query> getQuery() async {
    Query query = businessCollection;

    double sectionDistance;
    String distanceString;
    Position position;

    if (filterCurrentLocation) {
      //position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high) ?? await getLastKnownPosition();
      await LocationService.setUserPlacemark();
      position = LocationService.userPosition;
    }

    double geoLat = position.latitude ?? LocationService.defaultLatitude;
    double geoLong = position.longitude ?? LocationService.defaultLongitude;

    switch (_filterDistance) {
      case FilterDistance.None:
        break;
      case FilterDistance.One:
        //do the equation for getting lat/long
        sectionDistance = GeoHash.m1;
        distanceString = '1';

        query = getWhereGeo(
            query, sectionDistance, distanceString, geoLat, geoLong);
        break;
      case FilterDistance.Five:
        sectionDistance = GeoHash.m5;
        distanceString = '5';
        query = getWhereGeo(
            query, sectionDistance, distanceString, geoLat, geoLong);
        break;
      case FilterDistance.Twenty:
        sectionDistance = GeoHash.m20;
        distanceString = '20';
        query = getWhereGeo(
            query, sectionDistance, distanceString, geoLat, geoLong);
        break;
      default:
    }

    //Apply sort
    switch (_sortBy) {
      case SortBy.Favorite:
        query = query.orderBy('favorites', descending: true);
        break;
      case SortBy.Newest:
        query = query.orderBy('date_created', descending: true);
        break;
      case SortBy.A_to_Z:
        query = query.orderBy('name', descending: false);
        break;
      case SortBy.Z_to_A:
        query = query.orderBy('name', descending: true);
        break;
      default:
    }

    return query;
  }

  Query getWhereGeo(Query query, double sectionDistance, String distanceString,
      double geoLat, double geoLong) {
    double tapLat = 90 - geoLat;
    double tapLong = 180 - geoLong;

    String latZoneString;
    String longZoneString;

    int latSection = (tapLat / sectionDistance).floor();
    int longSection = (tapLong / sectionDistance).floor();

    int latZoneNum = latSection % 3;
    int longZoneNum = longSection % 3;

    String latHash = ((latSection - latZoneNum) / 3).floor().toString();
    String longHash = ((longSection - longZoneNum) / 3).floor().toString();

    switch (latZoneNum) {
      case 0:
        latZoneString = 'A';
        break;
      case 1:
        latZoneString = 'B';
        break;
      case 2:
        latZoneString = 'C';
        break;
      default:
      //throw new GeoExceotion();
    }

    switch (longZoneNum) {
      case 0:
        longZoneString = 'A';
        break;
      case 1:
        longZoneString = 'B';
        break;
      case 2:
        longZoneString = 'C';
        break;
      default:
      //throw new GeoExceotion();
    }

    String latAttribute = 'latHash_$distanceString$latZoneString';
    String longAttribute = 'longHash_$distanceString$longZoneString';

    // print(latAttribute + latHash);
    // print(longAttribute + longHash);

    return query
        .where(latAttribute, isEqualTo: latHash)
        .where(longAttribute, isEqualTo: longHash);
  }

  FilterDistance get getFilterDistance {
    return _filterDistance;
  }

  void setFilterDistance(FilterDistance filterDistance) {
    _filterDistance = filterDistance;
  }

  SortBy get getSortBy {
    return _sortBy;
  }

  void setFilters(SortBy sortBy, FilterDistance filterDistance,
      bool _filterCurrentLocation, Placemark _placemark) {
    //bool isChanged = sortBy != _sortBy || filterDistance != _filterDistance ;
    // if (isChanged) {
    //   _sortBy = sortBy;
    //   _filterDistance = filterDistance;
    //   getBusinesses();
    // }
    _sortBy = sortBy;
    _filterDistance = filterDistance;
    filterCurrentLocation = _filterCurrentLocation;
    filterPlacemark = _placemark;
    //LocationService.applyFilterPlacemark(_filterCurrentLocation);
    isNeedingGet = true;
    //getBusinesses();
  }

  void setSortBy(SortBy sortBy) {
    if (_sortBy != sortBy) {
      _sortBy = sortBy;
      isNeedingGet = true;
      //getBusinesses();
    }
  }

  static String getDayHeader(int dayIndex) {
    String dayResults;

    switch (dayIndex) {
      case DateTime.monday:
        dayResults = "Monday";
        break;
      case DateTime.tuesday:
        dayResults = "Tuesday";
        break;
      case DateTime.wednesday:
        dayResults = "Wednesday";
        break;
      case DateTime.thursday:
        dayResults = "Thursday";
        break;
      case DateTime.friday:
        dayResults = "Friday";
        break;
      case DateTime.saturday:
        dayResults = "Saturday";
        break;
      case DateTime.sunday:
        dayResults = "Sunday";
        break;
      default:
        dayResults = "Error";
    }

    return dayResults;
  }
}

Business findById(String id) {
  return _items.firstWhere((bus) => bus.id == id);
}

List<Business> _items = [];
