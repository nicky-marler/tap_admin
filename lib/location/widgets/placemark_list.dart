part of location_library;

class PlacemarkList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //final businesses = Provider.of<List<Business>>(context);
    //final _filter = Provider.of<FilterOptions>(context);
    List<Placemark> placemarks = LocationService.placemarks ?? [];
  
    // if(placemarks.isEmpty){
    //   return Text("No Results");
    // }


    return ListView.builder(
    //  padding: const EdgeInsets.all(10.0),
      itemCount: placemarks.length,     
      itemBuilder: (ctx, i) {
        return PlacemarkItem(placemark: placemarks[i],);
      },
      //physics: AlwaysScrollableScrollPhysics(),
    );
  }
}
