
part of location_library;

class LocationFieldStatless extends StatelessWidget {
  LocationFieldStatless({this.placemark});

  final String title = "Address";

  /// Callback that fires when the user taps on this widget
  //final VoidCallback onPressed;
  final Placemark placemark;

  

  @override
  Widget build(BuildContext context){
  //  final airportDisplayName =
  //      airport != null ? '${airport.name} (${airport.iata})' : 'Select...';
    return InkWell(
      onTap: () => {
         Navigator.of(context).pushNamed(
              LocationSelectScreen.routeName,
              //arguments: business,
         )},
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.place),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title),
                  SizedBox(height: 4.0),
                  AutoSizeText(
                    //airportDisplayName,
                    "my geo results. dat aiport var",
                    style: TextStyle(fontSize: 16.0),
                    minFontSize: 13.0,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Divider(height: 1.0, color: Colors.black87),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class LocationField extends StatefulWidget {

  LocationField({
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.geoTitle,
    this.geoThoroughfare
  });

  final Key fieldKey;
  final String hintText;
  final String labelText;
  final String helperText;
  final String geoTitle;
  final String geoThoroughfare;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;

  @override
  _LocationFieldState createState() => _LocationFieldState();
}

class _LocationFieldState extends State<LocationField> {
  //bool _obscureText = true;

  @override
  Widget build(BuildContext context) {

    return ListTile(
      leading: Icon(Icons.place),
      title: Text(widget.geoTitle ?? ''),
      subtitle: Text(widget.geoThoroughfare ?? ''),
      isThreeLine: true,
      //Creat Location provider
      onTap: () =>  _navigateAndSetSelection,

      
    );
    
  //   return TextFormField(
  //     key: widget.fieldKey,
  //     obscureText: _obscureText,
  //     cursorColor: Theme.of(context).cursorColor,
  //     maxLength: 8,
  //     onSaved: widget.onSaved,
  //     validator: widget.validator,
  //     onFieldSubmitted: widget.onFieldSubmitted,
  //     decoration: InputDecoration(
  //       filled: true,
  //       hintText: widget.hintText,
  //       labelText: widget.labelText,
  //       helperText: widget.helperText,
  //       suffixIcon: GestureDetector(
  //         dragStartBehavior: DragStartBehavior.down,
  //         onTap: () {
  //           setState(() {
  //             _obscureText = !_obscureText;
  //           });
  //         },
  //         child: Icon(
  //           _obscureText ? Icons.visibility : Icons.visibility_off,
  //           semanticLabel: _obscureText
  //               ? /* GalleryLocalizations.of(context)
  //                   .demoTextFieldShowPasswordLabel */ "Show"
  //               : /* GalleryLocalizations.of(context)
  //                   .demoTextFieldHidePasswordLabel, */ "Hide"
  //     //    ),
  //     //  ),


        
  // //    ),
  // //  );
   
  }

_navigateAndSetSelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    Placemark result =
        await Navigator.of(context).pushNamed(LocationSelectScreen.routeName);
    //add way to handle no return?


        // After the Selection Screen returns a result, hide any previous snackbars
        // and show the new result.
        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text("$result")));
    }
  }

