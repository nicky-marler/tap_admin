part of business_library;

class Item {
  final String id;
  final String businessId;
  final String name;
  final String details;
  final String type; //food/drink/event/other
  final int favorites;
  final int start;
  final int end;
  final bool bleeds;

  final String streetName;
  final String streetNumber;
  final String city;
  final String state;
  final String zip;

  final DateTime dateCreated;

  Item({
    //@required this.reference,
    @required this.id,
    @required this.businessId,
    @required this.name,
    @required this.details,
    @required this.type,
    @required this.favorites,
    @required this.start,
    @required this.end,
    @required this.bleeds,
    @required this.streetName,
    @required this.streetNumber,
    @required this.city,
    @required this.state,
    @required this.zip,
    @required this.dateCreated,
    // @required this.userPosition
  });

  Map<String, dynamic> toMap() {
    return {
      'street_name': streetName,
      'street_number': streetNumber,
      'city': city,
      'state': state,
      'zip': zip,
    };
  }

  factory Item.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();

    return Item(
      id: doc.id,
      businessId: data['businessID'] ?? 'Unknown Business',
      name: data['name'] ?? 'Unknown',
      details: data['details'] ?? 'Unknown',
      type: data['type'] ?? 'Unknown',
      favorites: data['favorites'] ?? 0,
      start: data['start'] ?? 0,
      end: data['end'] ?? 0,
      bleeds: data['bleeds'] ?? false,
      streetName: data['street_name'] ?? 'Unknown',
      streetNumber: data['street_number'] ?? 'Unknown',
      city: data['city'] ?? 'Unknown',
      state: data['state'] ?? 'Unknown',
      zip: data['zip'] ?? 'Unknown',
      dateCreated: data['date_created'].toDate() ?? DateTime.now(),
    );
  }

  factory Item.unknown() {
    return Item(
      id: 'Unknown',
      businessId: 'Unknown Business',
      name: 'Unknown',
      details: 'Unknown',
      type: 'Unknown',
      favorites: 0,
      start: 0,
      end: 0,
      bleeds: false,
      streetName: 'Unknown',
      streetNumber: 'Unknown',
      city: 'Unknown',
      state: 'Unknown',
      zip: 'Unknown',
      dateCreated: DateTime.now(),
    );
  }
}
