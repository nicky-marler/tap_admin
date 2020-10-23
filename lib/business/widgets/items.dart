part of business_library;

//Uses the ItemsProvider?
class BusinessItemList extends StatelessWidget {
  //BusinessItem();

  @override
  Widget build(BuildContext context) {
    List<int> weekDays = Provider.of<ItemsProvider>(context).weekDays;

    return Container(
      child: Column(
        children: [
          Center(
            child: Text(
              "Items",
              style: TextStyle(
                fontSize: 20,
                // decoration: TextDecoration.underline,
              ),
            ),
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics:
                NeverScrollableScrollPhysics(), //This list should not scroll since it's part of a scrollable
            //padding: const EdgeInsets.all(10.0),
            itemCount: weekDays.length,
            itemBuilder: (ctx, i) {
              return ItemDayFuture(
                dayIndex: weekDays[i],
              );
            },
          ),
        ],
      ),
    );
  }
}

class ItemDayFuture extends StatefulWidget {
  ItemDayFuture({Key key, this.dayIndex}) : super(key: key);

  final int dayIndex;
  _ItemDayFutureState createState() => _ItemDayFutureState();
}

class _ItemDayFutureState extends State<ItemDayFuture> {
  bool _isInit = true;
  Future<void> getFirestoreItems;

  List<Item> items;
  _getFirestoreItems(BuildContext context) {
    setState(() {
      getFirestoreItems = Provider.of<ItemsProvider>(context)
          .initFromFirestore(widget.dayIndex);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      _getFirestoreItems(context);
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: getFirestoreItems, // a previously-obtained Future<void> or null
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          // return Text('Press button to start.');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            return ItemDayList(dayIndex: widget.dayIndex);
        }
        return null; // unreachable
      },
    );
  }
}

class ItemDayList extends StatelessWidget {
  ItemDayList({Key key, @required this.dayIndex}) : super(key: key);
  final int dayIndex;

  @override
  Widget build(BuildContext context) {
    List<Item> itemList =
        Provider.of<ItemsProvider>(context).getDayItems(dayIndex);

    // return ExpansionTile(
    //   key: UniqueKey(),
    //   title: Text(BusinessProvider.getDayHeader(dayIndex)),
    //   //  initiallyExpanded: isExpanded,
    //   subtitle: Text("Total: ${itemList.length}"),

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6),
          alignment: Alignment.topLeft,
          child: Text(
            BusinessProvider.getDayHeader(dayIndex),
            style: TextStyle(
              fontSize: 16,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        itemList.length == 0
            ? Container(
             //   child: SizedBox(height:10)
                // Center(
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(vertical: 6.0),
                //     child: Text("Empty"),
                //   ),
                // ),
              )
            : Container(
                // height: 40,
                child: ListView.builder(
           
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,

                  physics:
                      NeverScrollableScrollPhysics(), //This list should not scroll since it's part of a scrollable
                  //padding: const EdgeInsets.all(10.0),
                  itemCount: itemList.length,
                  itemBuilder: (ctx, index) {
                    Item item = itemList[index];
                    return Dismissible(
                      direction: DismissDirection.endToStart,
                      key: new UniqueKey(),
                      onDismissed: (direction) async {
                        //Do the correct update. only updating temp
                        await (context)
                            .read<ItemsProvider>()
                            .dayRemoveAt(dayIndex, index, item.id);
                        itemList.removeAt(index);
                        (context as Element).markNeedsBuild();
                      },
                      background: Container(
                        padding: EdgeInsets.only(right: 20.0),
                        alignment: Alignment.centerRight,
                        color: Colors.red,
                        child: Text(
                          'Delete',
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      child: Card(
                        elevation: 4.0,
                        margin: new EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 6.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200]),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 1.0),
                            leading: Container(
                              padding: EdgeInsets.only(right: 12.0),
                              decoration: new BoxDecoration(
                                  border: new Border(
                                      right: new BorderSide(
                                          width: 1.0, color: Colors.black))),
                              child: Icon(Icons.local_bar, color: Colors.black),
                            ),
                            title: Text(
                              item.name,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                            subtitle: Row(
                              children: <Widget>[
                                // Icon(Icons.linear_scale,
                                //     color: Colors.yellowAccent),
                                Text(item.details,
                                    style: TextStyle(color: Colors.black))
                              ],
                            ),
                            trailing: Text(
                              item.favorites.toString(),
                              style: TextStyle(color: Colors.black, fontSize: 24.0),
                               
                            ),
                          ),
                        ),
                      ),

                      // new ListTile(
                      //     title: new Text(item.name),
                      //     subtitle: Text(item.details),
                      //     dense: true,
                      //     trailing: Text(item.favorites.toString())),
                    );

                    // return ItemTile(
                    //   item: itemList[index],
                    // );
                  },
                ),
              ),
      ],
      //   onExpansionChanged: (isChange) => {isExpanded = isChange, print(isExpanded)},
    );
  }
}

class ItemTile extends StatelessWidget {
  final Item item;

  //BusinessItem();
  ItemTile({@required this.item});

  @override
  Widget build(BuildContext context) {
    //final business = Provider.of<Business>(context, listen: false);

    return Padding(
      key: ValueKey(item.id),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        //Later add a slide to delete option
        child: ListTile(
          title: Text(item.name),
          subtitle: Text(item.details),
          trailing: Text(item.favorites.toString()),
          // onTap: () => {
          //   Navigator.of(context).pushNamed(
          //     BusinessScreen.routeName,
          //     arguments: business,
          //   )
          // },
        ),
      ),
    );
  }
}
