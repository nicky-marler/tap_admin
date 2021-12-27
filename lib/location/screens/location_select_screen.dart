part of location_library;

class LocationSelectScreen extends StatefulWidget {
  static const routeName = '/location/select';

  @override
  _LocationSelectScreenState createState() => _LocationSelectScreenState();
}

class _LocationSelectScreenState extends State<LocationSelectScreen> {
  bool _isInit = true;
  bool _useFutureBuilder = false;

  Future<List<Placemark>> placemarks;
  Future<Placemark> userPlacemark;

  _getPlacemarks(BuildContext context, String address) {
    setState(() {
      _useFutureBuilder = true;
      placemarks = locationFromAddress(address).then(
        (locations) => placemarkFromCoordinates(
            locations.first.latitude, locations.first.longitude),
      );
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      //_getUserPlacemark(context);

      userPlacemark = Geolocator.getCurrentPosition()
          .then((position) =>
              placemarkFromCoordinates(position.latitude, position.longitude))
          .then((placmarkList) => placmarkList.first);
    }
    //LocationService.isNeedingGet = false;
    _isInit = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 24);

    return Scaffold(
      appBar: AppBar(
        title: Text('Location details'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => {Navigator.of(context).pop()});
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 15, left: 15, top: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select Address",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      SizedBox(height: 10),
                      Container(
                        child: TextField(
                          //controller: locationController,
                          onSubmitted: (address) =>
                              _getPlacemarks(context, address),

                          decoration: InputDecoration(
                            filled: true,
                            hintText: "Enter new address",
                            //labelText: '',
                          ),
                        ),
                      ),
                    ]),
              ),
              SizedBox(height: 10),
              //Divider(),
              //Expanded(child: ,)
              Container(
                //child: sizedBoxSpace,
                color: Colors.grey[300],
                constraints: BoxConstraints(maxHeight: 10),
              ),
              FutureBuilder<Placemark>(
                future:
                    userPlacemark, // a previously-obtained Future<void> or null
                builder:
                    (BuildContext context, AsyncSnapshot<Placemark> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    // return Text('Press button to start.');
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    case ConnectionState.done:
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      return PlacemarkUserLocationItem(snapshot.data);
                  }
                  return null; // unreachable
                },
              ),
              //   ),
              Divider(
                height: 0,
              ),
              //sizedBoxSpace,
              Expanded(
                child: !_useFutureBuilder
                    ? sizedBoxSpace
                    : FutureBuilder<List<Placemark>>(
                        future:
                            placemarks, // a previously-obtained Future<void> or null
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Placemark>> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:

                            case ConnectionState.active:
                            case ConnectionState.waiting:
                              return Center(child: CircularProgressIndicator());
                            case ConnectionState.done:
                              if (snapshot.hasError)
                                return Text('Error: ${snapshot.error}');
                              return PlacemarkList(snapshot.data);
                          }
                          return null; // unreachable
                        },
                      ),
                //  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
