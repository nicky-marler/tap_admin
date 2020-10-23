part of location_library;

class FormLocationListTile extends FormField<Placemark> {
  //final PlacemarkType placemarkType;
  //final Placemark placemark;

  FormLocationListTile({
    //  @required this.placemark,
    @required BuildContext context,
    FormFieldSetter<Placemark> onSaved,
    FormFieldValidator<Placemark> validator,
    Placemark initalValue,
    // bool isNewSelect,
    bool autovalidate = false,

    //GestureTapCallback onTap,
  }) : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initalValue,
          autovalidate: autovalidate,
          builder: (FormFieldState<Placemark> state) {
            Widget _buildSubTitle() {
              if(state.hasError){
                return Text("Select Address", style: TextStyle(color: Colors.red,),);
              }
              else if(state.value == null){
                return Text("Enter new address");
              }
              else{
                return Text("${state.value.name} ${state.value.thoroughfare}");
              }
            }

            return Container(
              child: ListTile(
                title: Text("Address"),
                // leading: Icon(Icons.place),
                trailing: Icon(Icons.place, ),
                subtitle: _buildSubTitle(),
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  final results = await Navigator.of(context).pushNamed(
                    LocationSelectScreen.routeName,
                  ) as PlacemarkResults;
                  if (results != null) {
                    state.didChange(results.placemark);
                  }
                },
              ),
            );
          },
        );
}
