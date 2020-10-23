part of business_library;

class LocationAddress {
  final String streetName;
  final String streetNumber;
  final String city;
  final String state;
  final String zip;


  LocationAddress({
    //@required this.reference,
    @required this.streetName,
    @required this.streetNumber,
    @required this.city,
    @required this.state,
    @required this.zip,
    // @required this.userPosition
  }); 

  Map<String, dynamic> toMap() {
    return {
      'street_name': streetName,
      'street_number': streetNumber,
      'city': city,
      'state': state,
      'zip' : zip,
    };
  }

  factory LocationAddress.fromFirestore(Map data) {
  
    return LocationAddress(
        streetName: data['street_name'] ?? 'Unknown',
        streetNumber: data['street_number'] ?? 'Unknown',
        city: data['city'] ?? 'Unknown',
        state: data['state'] ?? 'Unknown',
        zip: data['zip'] ?? 'Unknown',
        );
  }

  factory LocationAddress.unknown() {
  
    return LocationAddress(
        streetName: 'Unknown',
        streetNumber: 'Unknown',
        city: 'Unknown',
        state: 'Unknown',
        zip: 'Unknown',
         );
  }

      
}