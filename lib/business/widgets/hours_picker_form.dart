part of business_library;

//Make a form requried hours.!!!!
//Or have it pre populated with open close? Yeah... that won't work cause days.
//Maybe pre populate with 10am to 11pm

//Uses the OperationalHoursProvider
class OperationalHoursItemTile extends StatefulWidget {
  OperationalHoursItemTile({Key key}) : super(key: key);

  _OperationalHoursItemTileState createState() =>
      _OperationalHoursItemTileState();
}

class _OperationalHoursItemTileState extends State<OperationalHoursItemTile> {
  OperationalHours operationalHours;

  @override
  Widget build(BuildContext context) {
    operationalHours =
        Provider.of<OperationalHoursProvider>(context).getDayHours(1);

    Widget _buildSubTitle() {
      if (operationalHours.isClosed) {
        //is Closed
        return Text("Closed");
      }
      if (!operationalHours.bleeds) {
        //Open, but does not bleed
        return Text(operationalHours.timeString(context));
      }
      //Deafult is that it is open and bleeds
      return Row(
        children: [
          Text(operationalHours.timeString(context)),
          Icon(
            Icons.opacity,
            color: Colors.red,
          )
        ],
      );
    }

    return Container(
      child: Column(
        children: [
          Center(
            child: Text(
              "Hours",
              style: TextStyle(
                fontSize: 20,
                // decoration: TextDecoration.underline,
              ),
            ),
          ),
          ExpansionTile(
            key: UniqueKey(),

            title: Text("Hours"),
            //  initiallyExpanded: isExpanded,
            subtitle: _buildSubTitle(),

            //!operationalHours.isClosed && operationalHours.bleeds ? Colors.red[100] : Theme.of(context).primaryColor
            children: [
              Container(
                height: 40,
                child: operationalHours.isClosed
                    //operationalHours.isClosed
                    ? FlatButton(
                        onPressed: () =>
                            _setHours(context, OperationalHours.template(), 1),
                        child: Text(
                          "Add Hours",
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: FlatButton(
                              child: Text(
                                "Remove",
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () => _removeHours(context, 1),
                            ),
                          ),
                          VerticalDivider(
                            width: 10,
                            thickness: 1,
                            indent: 5,
                            endIndent: 5,
                          ),
                          Expanded(
                            child: FlatButton(
                              child: Text(
                                "Edit",
                                style: TextStyle(color: Colors.grey),
                              ),
                              onPressed: () =>
                                  _setHours(context, operationalHours, 1),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
            //   onExpansionChanged: (isChange) => {isExpanded = isChange, print(isExpanded)},
          ),
        ],
      ),
    );
  }

  void _setHours(BuildContext context, OperationalHours operationalHours,
      int dayIndex) async {
    //Should return with isClosed == false
    OperationalHours newHours = await showHoursBottomSheet(
        context: context, initialHours: operationalHours);
    if (newHours != null) {
      //I think a cancel qill return a null
      setState(
        () {
          Provider.of<OperationalHoursProvider>(context, listen: false)
              .setDayHours(dayIndex, newHours);

          //   isExpanded = !isExpanded;
        },
      );
    }
  }

  void _removeHours(BuildContext context, int dayIndex) {
    OperationalHours newHours = OperationalHours.isClosed();
    setState(
      () {
        Provider.of<OperationalHoursProvider>(context, listen: false)
            .setDayHours(dayIndex, newHours);
        //  isExpanded = !isExpanded;
      },
    );
  }
}
