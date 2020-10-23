
part of location_library;

class PlacemarkItem extends StatelessWidget {
  final Placemark placemark;

  //BusinessItem();
  PlacemarkItem({@required this.placemark});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(placemark.hashCode),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.0),
      ),
      child: ListTile(
        leading: Icon(Icons.place),
        title: Text(
          "${placemark.subThoroughfare} ${placemark.thoroughfare}",
        ),
        subtitle: Text(
          "${placemark.locality}, ${placemark.administrativeArea} ${placemark.postalCode}",
        ),
        onTap: () => {
          // if (LocationProvider.locationScreenType == PlacemarkScreenType.Filter)
          //   {
          //     LocationProvider.tempFilterCurrentLocation = false,
          //   }
          //   else if(LocationProvider.locationScreenType == PlacemarkScreenType.Form){
          //     Provider.of<BusinessForm>(context).placemark = placemark
          //   },
          //LocationProvider.setSelectPlacemark(placemark),
          //(PlacemarkResults(placemark: placemark, type:  PlacemarkResultsType.Select))
          Navigator.of(context).pop(PlacemarkResults(placemark: placemark, type:  PlacemarkResultsType.Select))
        },
      ),
    );
  }
}
