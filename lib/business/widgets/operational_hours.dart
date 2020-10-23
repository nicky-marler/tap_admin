part of business_library;

//Uses the OperationalHoursProvider
class OperationalHoursList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //List<OperationalHours> weekHours = Provider.of<OperationalHoursProvider>(context).weekHours;
    List<int> weekHours =
        Provider.of<OperationalHoursProvider>(context).weekHours;

    return Container(
      child: Column(children: [
        Center(
          child: Text(
            "Hours",
            style: TextStyle(
              fontSize: 20,
              // decoration: TextDecoration.underline,
            ),
          ),
        ),
        MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics:
                NeverScrollableScrollPhysics(), //This list should not scroll since it's part of a scrollable
            //padding: const EdgeInsets.all(10.0),
            itemCount: weekHours.length,
            itemBuilder: (ctx, i) {
              return OperationalHoursListTile(
                dayIndex: weekHours[i],
              );
            },
          ),
        ),
      ]),
    );
  }
}

class OperationalHoursListTile extends StatefulWidget {
  OperationalHoursListTile({Key key, this.dayIndex}) : super(key: key);

  final int dayIndex;
  _OperationalHoursListTileState createState() => _OperationalHoursListTileState();
}

class _OperationalHoursListTileState extends State<OperationalHoursListTile> {
  bool _isInit = true;

  OperationalHours operationalHours;
  // bool isExpanded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      //isClosed = operationalHours.isClosed;
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    operationalHours = Provider.of<OperationalHoursProvider>(context)
        .getDayHours(widget.dayIndex);

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

    //  print(isExpanded);
    return ExpansionTile(
      key: UniqueKey(),

      title: Text(dayHeader),
      //  initiallyExpanded: isExpanded,
      subtitle: _buildSubTitle(),

      //!operationalHours.isClosed && operationalHours.bleeds ? Colors.red[100] : Theme.of(context).primaryColor
      children: [
        Container(
          height: 40,
          child: operationalHours.isClosed
              //operationalHours.isClosed
              ? FlatButton(
                  onPressed: () => _setHours(
                      context, OperationalHours.template(), widget.dayIndex),
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
                        onPressed: () => _removeHours(context, widget.dayIndex),
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
                        onPressed: () => _setHours(
                            context, operationalHours, widget.dayIndex),
                      ),
                    ),
                  ],
                ),
        ),
      ],
      //   onExpansionChanged: (isChange) => {isExpanded = isChange, print(isExpanded)},
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

  String get dayHeader {
    String dayResults;

    switch (widget.dayIndex) {
      case DateTime.monday:
        dayResults = "Monday";
        break;
      case DateTime.tuesday:
        dayResults = "Tuesday";
        break;
      case DateTime.wednesday:
        dayResults = "Wednesday";
        break;
      case DateTime.thursday:
        dayResults = "Thursday";
        break;
      case DateTime.friday:
        dayResults = "Friday";
        break;
      case DateTime.saturday:
        dayResults = "Saturday";
        break;
      case DateTime.sunday:
        dayResults = "Sunday";
        break;
      default:
        dayResults = "Error";
    }

    return dayResults;
  }
}

class OperationalHoursTile extends StatefulWidget {
  OperationalHoursTile({Key key}) : super(key: key);

  
  _OperationalHoursTileState createState() => _OperationalHoursTileState();
}

class _OperationalHoursTileState extends State<OperationalHoursTile> {
  bool _isInit = true;

  OperationalHours operationalHours;
  // bool isExpanded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      //isClosed = operationalHours.isClosed;
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    operationalHours = (context).watch<ItemForm>().operationalHours;

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

    //  print(isExpanded);
    return ListTile(
      key: UniqueKey(),

      title: Text("Hours"),
      //  initiallyExpanded: isExpanded,
      subtitle: _buildSubTitle(),
      onTap: () => _setHours(context, operationalHours),

      //!operationalHours.isClosed && operationalHours.bleeds ? Colors.red[100] : Theme.of(context).primaryColor
      
      //   onExpansionChanged: (isChange) => {isExpanded = isChange, print(isExpanded)},
    );
  }

  void _setHours(BuildContext context, OperationalHours operationalHours) async {
    //Should return with isClosed == false
    OperationalHours newHours = await showHoursBottomSheet(
        context: context, initialHours: operationalHours);
    if (newHours != null) {
      //I think a cancel qill return a null
      setState(
        () {
          (context).read<ItemForm>().setHours(newHours);
        },
      );
    }
  }
}
