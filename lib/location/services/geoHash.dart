part of location_library;

class GeoHash{
  //Why was the orginal x3 than desired?
  static final double m1 = 0.02; //Was 0.06
  static final double m5 = 0.08; //0.3
  static final double m20 = 0.24;  //1.2

  int latHash_1A;
  int latHash_1B;
  int latHash_1C;
  int longHash_1A;
  int longHash_1B;
  int longHash_1C;

  int latHash_5A;
  int latHash_5B;
  int latHash_5C;
  int longHash_5A;
  int longHash_5B;
  int longHash_5C;

  int latHash_20A;
  int latHash_20B;
  int latHash_20C;
  int longHash_20A;
  int longHash_20B;
  int longHash_20C;

  //Creating  hash values
  GeoHash(double latitude,double longitude){
    double tapLat = 90 - latitude;
    double tapLong = 180 - longitude;

    int latSectionM1 = (tapLat / m1).floor();
    int latSectionM5 = (tapLat / m5).floor();
    int latSectionM20 = (tapLat / m20).floor();

    int longSectionM1 = (tapLong / m1).floor();
    int longSectionM5 = (tapLong / m5).floor();
    int longSectionM20 = (tapLong / m20).floor();

    this.latHash_1A = ((latSectionM1 - 0) / 3).floor();
    this.latHash_1B = ((latSectionM1 - 1) / 3).floor();
    this.latHash_1C = ((latSectionM1 - 2) / 3).floor();
    this.longHash_1A = ((longSectionM1 - 0) / 3).floor();
    this.longHash_1B = ((longSectionM1 - 1) / 3).floor();
    this.longHash_1C = ((longSectionM1 - 2) / 3).floor();

    this.latHash_5A = ((latSectionM5 - 0) / 3).floor();
    this.latHash_5B = ((latSectionM5 - 1) / 3).floor();
    this.latHash_5C = ((latSectionM5 - 2) / 3).floor();
    this.longHash_5A = ((longSectionM5 - 0) / 3).floor();
    this.longHash_5B = ((longSectionM5 - 1) / 3).floor();
    this.longHash_5C = ((longSectionM5 - 2) / 3).floor();

    this.latHash_20A = ((latSectionM20 - 0) / 3).floor();
    this.latHash_20B = ((latSectionM20 - 1) / 3).floor();
    this.latHash_20C = ((latSectionM20 - 2) / 3).floor();
    this.longHash_20A = ((longSectionM20 - 0) / 3).floor();
    this.longHash_20B = ((longSectionM20 - 1) / 3).floor();
    this.longHash_20C = ((longSectionM20 - 2) / 3).floor();
  }

}

  //double givenGeoLat = 30.2694643;
  //double givenGeoLong = -90.7509239;