// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tapthis_admin/providers/businesses.dart';
// import 'package:tapthis_admin/screens/business_add_screen.dart';
// import 'package:tapthis_admin/screens/business_filter_screen.dart';
// import 'package:tapthis_admin/widgets/business/business_list.dart';

// import '../widgets/app_drawer.dart';
// import 'business_add_screen.dart';

part of business_library;

class BusinessesOverviewScreen extends StatefulWidget {
  static const routeName = '/business';
  @override
  _BusinessesOverviewScreenState createState() =>
      _BusinessesOverviewScreenState();
}

class _BusinessesOverviewScreenState extends State<BusinessesOverviewScreen> {
  bool _isInit = true;
  String error;
  Future<void> getBusiness;
  //final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (Provider.of<BusinessProvider>(context, listen: false).isNeedingGet ||
        _isInit) {
      getBusiness =
          Provider.of<BusinessProvider>(context, listen: false).getBusinesses();
      _isInit = false;
      Provider.of<BusinessProvider>(context, listen: false).isNeedingGet =
          false;
    }
  }

  @override
  Widget build(BuildContext context) {
    void _addBusiness(BuildContext context) async {
      await Navigator.of(context)
          .pushNamed(BusinessAddScreen.routeName)
          .then((rebuildScreen) => rebuildScreen
              ? setState(() {
                  getBusiness =
                      Provider.of<BusinessProvider>(context, listen: false)
                          .getBusinesses();
                })
              : null);
    }

    return Scaffold(
      appBar: AppBar(
        //   key: _scaffoldKey,
        title: Text('Businesses'),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _addBusiness(context),
            ),
          ),
          IconButton(
            icon: Icon(Icons.tune),
            onPressed: () => {
              Navigator.of(context).pushNamed(
                BusinessFilterScreen.routeName,
              )
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder<void>(
        future: getBusiness, // a previously-obtained Future<void> or null
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            // return Text('Press button to start.');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<BusinessProvider>().getBusinesses();
                  return setState(() {});
                },
                child: BusinessList(),
              );
          }
          return null; // unreachable
        },
      ),
    );
  }
}
