part of location_library;

class PlacemarkUserLocationItem extends StatelessWidget {
  PlacemarkUserLocationItem(this.userPlacemark);

  final Placemark userPlacemark;

  @override
  Widget build(BuildContext context) {
    if (userPlacemark == null) {
      return null;
    }

    return Container(
      key: ValueKey(userPlacemark.hashCode),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.0),
      ),
      child: ListTile(
        leading: Icon(Icons.near_me),
        title: Text(
          "${userPlacemark.subThoroughfare} ${userPlacemark.thoroughfare}",
        ),
        subtitle: Text(
          "${userPlacemark.locality}, ${userPlacemark.administrativeArea} ${userPlacemark.postalCode}",
        ),
        onTap: () => {
          //If filter
          // if (LocationProvider.locationScreenType == PlacemarkScreenType.Filter)
          //   {
          //     LocationProvider.tempFilterCurrentLocation = true,
          //   }
          // else if (LocationProvider.locationScreenType ==
          //     PlacemarkScreenType.Form)
          //   {Provider.of<BusinessForm>(context).placemark = userPlacemark},
          // LocationProvider.setSelectPlacemark(userPlacemark),
          Navigator.of(context).pop(PlacemarkResults(
              placemark: userPlacemark, type: PlacemarkResultsType.User))
        },
      ),
    );
  }
}
