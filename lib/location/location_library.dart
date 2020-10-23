//Putting all of location files together

library location_library;

//flutter to Dart packages
//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
//import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'dart:async';



//Pub dart packages
//import 'package:provider/provider.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:auto_size_text/auto_size_text.dart';

//Imports from my own files outside of this library
//import 'package:tapthis_admin/services/database_service.dart';

//General custom widgets

//Business files

//Location Files
part './models/placemark_results.dart';

part './screens/location_select_screen.dart';

part './services/location_service.dart';
part './services/geoHash.dart';

part './widgets/form_location_listTile.dart';
part './widgets/location_fetch.dart';
part 'widgets/placemark_item.dart';
part 'widgets/placemark_list.dart';
part './widgets/placemark_userLocation_item.dart';

//Business files
