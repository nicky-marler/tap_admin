part of business_library;

class BusinessList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Business> businesses =
        Provider.of<BusinessProvider>(context).businesses;

    return ListView.builder(
      //padding: const EdgeInsets.all(10.0),
      itemCount: businesses.length,
      itemBuilder: (context, i) {
        return BusinessItem(
          business: businesses[i],
        );
      },
      //physics: AlwaysScrollableScrollPhysics(),
    );
  }
}

class BusinessItem extends StatelessWidget {
  final Business business;

  //BusinessItem();
  BusinessItem({@required this.business});

  @override
  Widget build(BuildContext context) {
    //final business = Provider.of<Business>(context, listen: false);

    return Padding(
      key: ValueKey(business.id),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(business.name),
          subtitle: Text(business.streetName),
          trailing: Text(business.favorites.toString()),
          onTap: () => {
            Navigator.of(context).pushNamed(
              BusinessScreen.routeName,
              arguments: business,
            )
          },
          //      onTap: () => Firestore.instance.runTransaction((transaction) async {
          //   final freshSnapshot = await transaction.get(business.reference);
          //  final fresh = Business.fromSnapshot(freshSnapshot);

          //  await transaction
          //      .update(business.reference, {'address': fresh.address + 'x'});
          // }),
        ),
      ),
    );
  }
}
