part of general_widgets_library;

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('TapThis Admin'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.business),
            title: Text('Business'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          // ListTile(
          //   leading: Icon(Icons.payment),
          //   title: Text('Orders'),
          //   onTap: () {
          //     Navigator.of(context)
          //         .pushReplacementNamed(OrdersScreen.routeName);
          //   },
          // ),
          // Divider(),
          // ListTile(
          //   leading: Icon(Icons.edit),
          //   title: Text('Manage Products'),
          //   onTap: () {
          //     Navigator.of(context)
          //         .pushReplacementNamed(UserProductsScreen.routeName);
          //   },
          // ),
          // Divider(),
          // ListTile(
          //   leading: Icon(Icons.exit_to_app),
          //   title: Text('Logout'),
          //   onTap: () {
          //     Navigator.of(context).pop();
          //     Navigator.of(context).pushReplacementNamed('/');
              
          //     // Navigator.of(context)
          //     //     .pushReplacementNamed(UserProductsScreen.routeName);
          //     Provider.of<Auth>(context, listen: false).logout();
          //   },
          // ),
        ],
      ),
    );
  }
}
