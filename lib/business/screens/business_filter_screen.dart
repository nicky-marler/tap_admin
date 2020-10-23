

part of business_library;

class BusinessFilterScreen extends StatefulWidget {
  static const routeName = '/business/filter';

  @override
  _BusinessFilterScreenState createState() => _BusinessFilterScreenState();
}

class _BusinessFilterScreenState extends State<BusinessFilterScreen> {
  bool _isInit = true;
  FilterDistance _filterDistance;
  List<bool> _isDistance;

  SortBy _sortBy;
  List<bool> _isSort;
  bool _filterCurrentLocation;



  Placemark _placemark;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _sortBy = Provider.of<BusinessProvider>(context).getSortBy;
      _filterDistance = Provider.of<BusinessProvider>(context).getFilterDistance;
      _filterCurrentLocation = Provider.of<BusinessProvider>(context).filterCurrentLocation;
      _placemark = Provider.of<BusinessProvider>(context).filterPlacemark;
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    //Toggle button order. One, Five, Twenty, None. Default to One
    setDistance();
    setSort();

    return Scaffold(
      appBar: AppBar(
        title: Text('Filters'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => {Navigator.of(context).pop()});
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "Filter Distance",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 5,
            ),
            ToggleButtons(
              children: <Widget>[
                Text("1"),
                Text("5"),
                Text("20"),
                Text("None")
              ],
              onPressed: (int index) => setState(
                () => updateDistance(index),
              ),
              isSelected: _isDistance,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Sort by",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 5,
            ),
            ToggleButtons(
              children: <Widget>[
                Text("Newest"),
                Text("Favorite"),
                Text("A - Z"),
                Text("Z - A")
              ],
              onPressed: (int index) => setState(
                () => updateSort(index),
              ),
              isSelected: _isSort,
            ),
            SizedBox(
              height: 15,
            ),
            Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 0.0),
                        // borderRadius:
                        //     new BorderRadius.all(new Radius.circular(15.0))
                        ),
                    child: ListTile(
                      title: Text("Address"),
                      trailing: _filterCurrentLocation
                          ? Icon(Icons.near_me)
                          : Icon(Icons.place),
                      subtitle: _filterCurrentLocation
                          ? Text("Current Location")
                          : Text("${_placemark.name} ${_placemark.thoroughfare}"
                      
                              ),
                      onTap: () =>
                          {_navigateAndDisplayLocationSelection(context)},
                    ),
                  ),
            // SwitchListTile(
            //   title: _filterCurrentLocation
            //       ? Text("Current Location")
            //       : FutureBuilder<Placemark>(
            //           future: _placemark,
            //           builder: (BuildContext context,
            //               AsyncSnapshot<Placemark> snapshot) {
            //             switch (snapshot.connectionState) {
            //               case ConnectionState.none:
            //               // return Text('Press button to start.');
            //               case ConnectionState.active:
            //               case ConnectionState.waiting:
            //                 return Center(child: CircularProgressIndicator());
            //               case ConnectionState.done:
            //                 if (snapshot.hasError)
            //                   return Text('Error: ${snapshot.error}');
            //                 return Text(
            //                   "${snapshot.data.name} ${snapshot.data.thoroughfare}",
            //                   style: TextStyle(color: Colors.green),
            //                 );
            //             }
            //             return null; // unreachable
            //           },
            //         ),
            //   value: _filterCurrentLocation,

            //   onChanged: (bool value) {
            //     setState(() {
            //       _filterCurrentLocation = value;
            //       if (_filterCurrentLocation) {
            //         _placemark = Provider.of<BusinessProvider>(context)
            //             .locationProvider
            //             .getPlacemark();
            //       }
            //     },);
   
            //   },
            //   secondary: Icon(
            //     Icons.location_on,
            //     color: _filterCurrentLocation ? Colors.blue : Colors.grey,
            //   ),
            // ),
            // AnimatedSwitcher(
            //   child: _filterCurrentLocation
            //       ? SizedBox(
            //           height: 15,
            //           key: UniqueKey(),
            //         )
            //       : Container(
            //               child: OutlineButton(
            //                 shape: new RoundedRectangleBorder(
            //                     borderRadius: new BorderRadius.circular(30.0)),
            //                 child: Text(
            //                   "Change Location",
            //                   style: TextStyle(color: Colors.blue),
            //                 ),
            //                 onPressed: () => {},
            //               ),
            //             ),
            //   duration: Duration(milliseconds: 250),
            //   transitionBuilder: (Widget child, Animation<double> animation) {
            //     return ClipRect(
            //       child: SlideTransition(
            //           n: Tween<Offset>(
            //                   begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0))
            //               .animate(animation),
            //           child: child),
            //     );
            //   },
            // ),
            Expanded(
              child: Container(),
            ),
            Container(
              color: Colors.white,
              height: 60,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: OutlineButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                          //Maybe get rid of reset
                      child: Text(
                        "Reset",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () => setDefault(),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: FlatButton(
                      color: Colors.blue,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      child: Text(
                        "Apply",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => returnApply(),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setDistance() {
    switch (_filterDistance) {
      case FilterDistance.One:
        _isDistance = [true, false, false, false];
        break;
      case FilterDistance.Five:
        _isDistance = [false, true, false, false];
        break;
      case FilterDistance.Twenty:
        _isDistance = [false, false, true, false];
        break;
      case FilterDistance.None:
        _isDistance = [false, false, false, true];
        break;
      default:
        _isDistance = [false, false, false, true];
    }
  }

  void updateDistance(int index) {
    switch (index) {
      case 0:
        _filterDistance = FilterDistance.One;
        break;
      case 1:
        _filterDistance = FilterDistance.Five;
        break;
      case 2:
        _filterDistance = FilterDistance.Twenty;
        break;
      case 3:
        _filterDistance = FilterDistance.None;
        break;
      default:
        _filterDistance = FilterDistance.None;
    }
  }

  void setSort() {
    switch (_sortBy) {
      case SortBy.Newest:
        _isSort = [true, false, false, false];
        break;
      case SortBy.Favorite:
        _isSort = [false, true, false, false];
        break;
      case SortBy.A_to_Z:
        _isSort = [false, false, true, false];
        break;
      case SortBy.Z_to_A:
        _isSort = [false, false, false, true];
        break;
      default:
        //Newest
        _isSort = [true, false, false, false];
    }
  }

  void updateSort(int index) {
    switch (index) {
      case 0:
        _sortBy = SortBy.Newest;
        break;
      case 1:
        _sortBy = SortBy.Favorite;
        break;
      case 2:
        _sortBy = SortBy.A_to_Z;
        break;
      case 3:
        _sortBy = SortBy.Z_to_A;
        break;
      default:
        _sortBy = SortBy.Newest;
    }
  }

  void returnApply() {

    // Provider.of<BusinessProvider>(context, listen: false)
    //     .tempGenerateIndexes();
    

    Provider.of<BusinessProvider>(context, listen: false)
        .setFilters(_sortBy, _filterDistance, _filterCurrentLocation, _placemark);
        //Filter needs to be its own object later
    Navigator.of(context).pop();
  }

//Maybe get rid of reset
  void setDefault() {
    setState(
      () {
        updateDistance(-1);
        updateSort(-1);
      },
    );
  }

  _navigateAndDisplayLocationSelection(BuildContext context) async {
    final results = await Navigator.of(context).pushNamed(
      LocationSelectScreen.routeName,
    ) as PlacemarkResults;
    if(results != null){
      _placemark = results.placemark;
      _filterCurrentLocation = results.type == PlacemarkResultsType.User;
    }
  }

  }

