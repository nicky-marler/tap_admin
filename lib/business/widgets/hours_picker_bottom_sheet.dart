part of business_library;

const double _hoursPickerHeight = 160.0;
const double _hoursPickerItemHeight = _hoursPickerHeight / 3;
const int _totalMinutesInHour = 1440;

class _HoursPickerBottomSheet extends StatefulWidget {
  /// Creates a peronal time picker.
  ///
  /// [initialHours] must not be null.
  const _HoursPickerBottomSheet({
    Key key,
    @required this.initialHours,
  })  : assert(initialHours != null),
        super(key: key);

  /// The operational Hours initially selected when the dialog is shown.
  final OperationalHours initialHours;

  @override
  _HoursPickerBottomSheetState createState() => _HoursPickerBottomSheetState();
}

class _HoursPickerBottomSheetState extends State<_HoursPickerBottomSheet> {
  @override
  void initState() {
    super.initState();
    _selectedHours = widget.initialHours;

    startSelectedTimeIndex = _indexFromTime(_selectedHours.startTotalMinutes);
    endSelectedTimeIndex = _indexFromTime(_selectedHours.endTotalMinutes);

    startController =
        FixedExtentScrollController(initialItem: startSelectedTimeIndex);
    endController =
        FixedExtentScrollController(initialItem: endSelectedTimeIndex);

    pickerList = _generatePickerItems();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = MaterialLocalizations.of(context);
  }

  @override
  void dispose() {
    startController.dispose();
    endController.dispose();
    super.dispose();
  }

  OperationalHours _selectedHours;

  //This will be inialized to the select item
  FixedExtentScrollController startController;
  FixedExtentScrollController endController;

  int startSelectedTimeIndex;
  int endSelectedTimeIndex;

  MaterialLocalizations localizations;

  List<TimeOfDay> pickerList;

  void _handleCancel() {
    Navigator.pop(context);
  }

  void _handleSave() {
    TimeOfDay startHours = pickerList[startSelectedTimeIndex];
    TimeOfDay endHours = pickerList[endSelectedTimeIndex];
    OperationalHours results = OperationalHours.fromTimeOfDay(startHours, endHours);

    Navigator.pop(context,
        results); 
  }

  List<TimeOfDay> _generatePickerItems() {
    List<TimeOfDay> results = [];
    int insertMin;
    int insertHour;
    for (int minutes = 0; minutes < _totalMinutesInHour; minutes += 15) {
      insertMin = minutes % 60;
      insertHour = minutes ~/ 60;

      results.add(TimeOfDay(hour: insertHour, minute: insertMin));
    }

    return results;
  }

  //Incremeneting by 15
  int _indexFromTime(int totalMinutes) {
    int index = totalMinutes ~/ 15;
    return index;
  }

  @override
  Widget build(BuildContext context) {
    //fixedScrollController.initialItem = 3;

    assert(debugCheckHasMediaQuery(context));
    //final MediaQueryData media = MediaQuery.of(context);
    final ThemeData theme = Theme.of(context);

    final Widget startPicker = Container(
      // color: Colors.grey[300],
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: _hoursPickerHeight,
          maxHeight: _hoursPickerHeight,
        ),
        child: ListWheelScrollView.useDelegate(
          itemExtent: _hoursPickerItemHeight,
          controller: startController,
          physics: FixedExtentScrollPhysics(),
          diameterRatio: 1.5,
          onSelectedItemChanged: (index) {
            setState(() {
              startSelectedTimeIndex = startController.selectedItem;
              //       print(fixedScrollController.selectedItem);
            });
          },
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: pickerList.length,
            builder: (context, index) {
              return Text(pickerList[index].format(context).toString(),
                  style: TextStyle(
                    fontSize: 26,
                    color: index == startSelectedTimeIndex
                        ? Colors.black
                        : Colors.grey,
                  ));
            },
          ),
        ),
      ),
    );

    final Widget endPicker = Container(
      //   color: Colors.grey[300],
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: _hoursPickerHeight,
          maxHeight: _hoursPickerHeight,
        ),
        child: ListWheelScrollView.useDelegate(
          itemExtent: _hoursPickerItemHeight,
          controller: endController,
          physics: FixedExtentScrollPhysics(),
          diameterRatio: 1.5,
          onSelectedItemChanged: (index) {
            setState(() {
              endSelectedTimeIndex = endController.selectedItem;
              //       print(fixedScrollController.selectedItem);
            });
          },
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: pickerList.length,
            builder: (context, index) {
              return Text(pickerList[index].format(context).toString(),
                  style: TextStyle(
                    fontSize: 26,
                    color: index == endSelectedTimeIndex
                        ? Colors.black
                        : Colors.grey,
                  ));
            },
          ),
        ),
      ),
    );

    final Widget actions = Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: FlatButton(
              child: Text(
                "Cancel",
                //style: TextStyle(color: Colors.gre),
              ),
              onPressed: () => _handleCancel(),
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
                "Save",
              //  style: TextStyle(color: Colors.blue,),
              ),
              onPressed: () => _handleSave(),
            ),
          ),
        ],
      ),
    );

    final Widget pckerDivider = Container(
      //   color: Colors.grey[300],
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: _hoursPickerHeight,
          maxHeight: _hoursPickerHeight,
        ),
        child: Center(
          child: SizedBox(
            height: 2,
            width: 15,
            child: Container(
              height: 2,
              width: 15,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );

    // final Widget _actions = ButtonBar(
    //   children: <Widget>[
    //     FlatButton(
    //       child: Text(localizations.cancelButtonLabel),
    //       onPressed: _handleCancel,
    //     ),
    //     FlatButton(
    //         child: Text(localizations.okButtonLabel),
    //         onPressed: () {} //_handleOk,
    //         ),
    //   ],
    // );

    final bottomSheet = Container(
      color: Colors.grey[300],
      child: new Wrap(
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        "Open",
                        style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    startPicker,
                  ],
                ),
              ),
              pckerDivider,
              Expanded(
                  child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      "Close",
                      style: TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  endPicker,
                ],
              ))
            ],
          ),
          actions,
        ],
      ),
    );
    return Theme(
      data: theme.copyWith(
        dialogBackgroundColor: Colors.transparent,
      ),
      child: bottomSheet,
    );
  }
}

Future<OperationalHours> showHoursBottomSheet({
  @required BuildContext context,
  @required OperationalHours initialHours,
  TransitionBuilder builder,
  bool useRootNavigator = true,
}) async {
  assert(context != null);
  assert(initialHours != null);
  assert(useRootNavigator != null);
  assert(debugCheckHasMaterialLocalizations(context));

  final Widget bottomSheet =
      _HoursPickerBottomSheet(initialHours: initialHours);

  return await showModalBottomSheet(
    context: context,
    isDismissible: false,
    useRootNavigator: useRootNavigator,
    builder: (BuildContext context) {
      return builder == null ? bottomSheet : builder(context, bottomSheet);
    },
  );
}
