// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../models/business.dart';

part of business_library;

class BusinessScreen extends StatefulWidget {
  static const routeName = '/business/detail';

  @override
  _BusinessScreenState createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {
  bool _isInit = true;
  Business business;
  ItemsProvider itemsProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      business = ModalRoute.of(context).settings.arguments as Business;
      Provider.of<BusinessProvider>(context, listen: false).selectedBusiness =
          business;
      itemsProvider = ItemsProvider(businessId: business.id);
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    void _addItem(BuildContext context) async {
      await Navigator.of(context).pushNamed(ItemAddScreen.routeName);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${business.name}', overflow: TextOverflow.ellipsis),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons
                  .add), //Being able to update location/name is a way future release
              onPressed: () => _addItem(context),
            ),
          ),
        ],
      ),
      // body: NestedScrollView(
      //   headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
      //     return <Widget>[
      //       SliverAppBar(
      //         // expandedHeight: 100.0,
      //         floating: true,
      //         pinned: false,
      //         snap: false,
      //         forceElevated: innerBoxIsScrolled,
      //         automaticallyImplyLeading: true,
      //         title: Text('${business.name}', overflow: TextOverflow.ellipsis),
      //         actions: <Widget>[
      //           Builder(
      //             builder: (context) => IconButton(
      //               icon: Icon(Icons.more_vert),
      //               onPressed: () => () {},
      //             ),
      //           ),
      //         ],
      //         // flexibleSpace: FlexibleSpaceBar(
      //         //   centerTitle: false,
      //         //   title: Text(
      //         //     "Collapsing Toolbar and I'm making it way too big just so I can see an overflow",
      //         //     maxLines:1, overflow:TextOverflow.ellipsis,
      //         //     style: TextStyle(
      //         //       color: Colors.white,
      //         //       fontSize: 16.0,
      //         //     ),
      //         //   ),
      //         // ),
      //       ),
      //    ];
      //   },
      body:  SingleChildScrollView(
                  child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: ListTile(
                  leading: (Icon(Icons.place)),
                  title: Text("${business.streetNumber} ${business.streetName}"),
                  subtitle:
                      Text("${business.city}, ${business.state} ${business.zip}"),
                ),
              ),
              SizedBox(height: 16),
              Container(
                child: ChangeNotifierProvider.value(
                  value: itemsProvider,
                  child: Consumer<ItemsProvider>(
                    builder: (context, items, _) {
                      return BusinessItemList();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      
    );
  }
}
