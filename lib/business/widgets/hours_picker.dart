part of business_library;

const double _hoursPickerHeaderPortraitHeight = 96.0;
const double _hoursPickerHeightPortrait = 496.0;
const double _hoursPickerHeightPortraitCollapsed = 484.0;

//const double _hoursimePickerWidthPortrait = 328.0;


class _TimePickerHeader extends StatelessWidget {
  const _TimePickerHeader({
    @required this.selectedHours,
  }) : assert(selectedHours != null);

  final OperationalHours selectedHours;
  final titleString = "Does this work?";


  // TextStyle _getBaseHeaderStyle(TextTheme headerTextTheme) {
  //   // portrait only
  //   return headerTextTheme.display3.copyWith(fontSize: 60.0);
  // }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    final ThemeData themeData = Theme.of(context);

    EdgeInsets padding;
    double height;
    double width;

    
      
    height = _hoursPickerHeaderPortraitHeight;
    padding = const EdgeInsets.symmetric(horizontal: 24.0);
     
    

    Color backgroundColor;
    switch (themeData.brightness) {
      case Brightness.light:
        backgroundColor = themeData.primaryColor;
        break;
      case Brightness.dark:
        backgroundColor = themeData.backgroundColor;
        break;
    }

    //For AM/PM
    // Color activeColor;
    // Color inactiveColor;
    // switch (themeData.primaryColorBrightness) {
    //   case Brightness.light:
    //     activeColor = Colors.black87;
    //     inactiveColor = Colors.black54;
    //     break;
    //   case Brightness.dark:
    //     activeColor = Colors.white;
    //     inactiveColor = Colors.white70;
    //     break;
    // }

    
    return Container(
      width: width,
      height: height,
      padding: padding,
      color: backgroundColor,
      child: Text(titleString),
    );
  }
}

class _TimeList extends StatefulWidget {
  /// Creates a peronal time picker.
  ///
  /// [selectedHours] must not be null.
  const _TimeList({
    @required this.slectedHours,
    @required this.onChanged,
  }) : assert(slectedHours != null);
       
  final OperationalHours slectedHours;
  final ValueChanged<OperationalHours> onChanged;

  @override
  _TimeListState createState() => _TimeListState();
}

class _TimeListState extends State<_TimeList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

}

class _HoursPickerDialog extends StatefulWidget {
  /// Creates a peronal time picker.
  ///
  /// [initialHours] must not be null.
  const _HoursPickerDialog({
    Key key,
    @required this.initialHours,
  }) : assert(initialHours != null),
       super(key: key);

  /// The operational Hours initially selected when the dialog is shown.
  final OperationalHours initialHours;

  @override
  _HoursPickerDialogState createState() => _HoursPickerDialogState();
}

class _HoursPickerDialogState extends State<_HoursPickerDialog> {
  @override
  void initState() {
    super.initState();
    //Might need start ope
    _selectedHours = widget.initialHours;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = MaterialLocalizations.of(context);
    //_announceInitialTimeOnce();
  }


  TimeOfDay get startHours => _selectedHours.startTimeOfDay;
  TimeOfDay get endHours => _selectedHours.endTimeOfDay;
  OperationalHours get selectedHours => _selectedHours;
  OperationalHours _selectedHours;

  MaterialLocalizations localizations;

/*
  Currently do not want to deal with 24 hour time
*/

//  bool _announcedInitialTime = false;

  // void _announceInitialTimeOnce() {
  //   if (_announcedInitialTime)
  //     return;

  //   final MediaQueryData media = MediaQuery.of(context);
  //   final MaterialLocalizations localizations = MaterialLocalizations.of(context);
  //   _announceToAccessibility(
  //     context,
  //     localizations.formatTimeOfDay(widget.initialHours.startTimeOfDay, alwaysUse24HourFormat: media.alwaysUse24HourFormat),
  //   );
  //   _announceToAccessibility(
  //     context,
  //     localizations.formatTimeOfDay(widget.initialHours.endTimeOfDay, alwaysUse24HourFormat: media.alwaysUse24HourFormat),
  //   );
  //   _announcedInitialTime = true;
  // }


  void _handleHoursChanged(OperationalHours value) {
    setState(() {
      _selectedHours = value;
    });
  }

  // void _handleHourSelected() {
  //   setState(() {
  //     _mode = _TimePickerMode.minute;
  //   });
  // }

  void _handleCancel() {
    Navigator.pop(context);
  }

  void _handleOk() {
    Navigator.pop(context, _selectedHours); //Might need to be operational Hours or new object
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
   // final MediaQueryData media = MediaQuery.of(context);
    //final TimeOfDayFormat timeOfDayFormat = localizations.timeOfDayFormat(alwaysUse24HourFormat: media.alwaysUse24HourFormat);
    //final bool use24HourDials = hourFormat(of: timeOfDayFormat) != HourFormat.h;
    final ThemeData theme = Theme.of(context);

    //Might to likely will do both later
    final Widget picker = Padding(
      padding: const EdgeInsets.all(16.0),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: _TimeList(
          slectedHours: _selectedHours,
          onChanged: _handleHoursChanged,

        )
        // _Dial(
        //   mode: _mode,
        //   use24HourDials: use24HourDials,
        //   selectedTime: _selectedTime,
        //   onChanged: _handleTimeChanged,
        //   onHourSelected: _handleHourSelected,
        // ),
      ),
    );

    final Widget actions = ButtonBar(
      children: <Widget>[
        FlatButton(
          child: Text(localizations.cancelButtonLabel),
          onPressed: _handleCancel,
        ),
        FlatButton(
          child: Text(localizations.okButtonLabel),
          onPressed: _handleOk,
        ),
      ],
    );

    final Dialog dialog = Dialog(
      child: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          final Widget header = _TimePickerHeader(
            selectedHours: _selectedHours,
          );

          final Widget pickerAndActions = Container(
            color: theme.dialogBackgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(child: picker), // picker grows and shrinks with the available space
                actions,
              ],
            ),
          );

          double hoursPickerHeightPortrait;
          switch (theme.materialTapTargetSize) {
            case MaterialTapTargetSize.padded:
              hoursPickerHeightPortrait = _hoursPickerHeightPortrait;
              break;
            case MaterialTapTargetSize.shrinkWrap:
              hoursPickerHeightPortrait = _hoursPickerHeightPortraitCollapsed;
              break;
          }

          // assert(orientation != null);
          // switch (orientation) {
          //   case Orientation.portrait:
              return SizedBox(
                //width: _hoursimePickerWidthPortrait,
                height: hoursPickerHeightPortrait,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    header,
                    Expanded(
                      child: pickerAndActions,
                    ),
                  ],
                ),
              );
              //Not using Landscape
            // case Orientation.landscape:
            //   return SizedBox(
            //     width: _kTimePickerWidthLandscape,
            //     height: timePickerHeightLandscape,
            //     child: Row(
            //       mainAxisSize: MainAxisSize.min,
            //       crossAxisAlignment: CrossAxisAlignment.stretch,
            //       children: <Widget>[
            //         header,
            //         Flexible(
            //           child: pickerAndActions,
            //         ),
            //       ],
            //     ),
            //   );
          // }
          // return null;
        }
      ),
    );

    return Theme(
      data: theme.copyWith(
        dialogBackgroundColor: Colors.transparent,
      ),
      child: dialog,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}


Future<OperationalHours> showHoursPicker({
    @required BuildContext context,
    @required OperationalHours initialHours,
    TransitionBuilder builder,
    bool useRootNavigator = true,
  }) async {
    assert(context != null);
    assert(initialHours != null);
    assert(useRootNavigator != null);
    assert(debugCheckHasMaterialLocalizations(context));

    final Widget dialog = _HoursPickerDialog(initialHours: initialHours);

    return await showDialog<OperationalHours>(
      context: context,
      useRootNavigator: useRootNavigator,
      builder: (BuildContext context) {
        return builder == null ? dialog : builder(context, dialog);
      },
    );
  }


// void _announceToAccessibility(BuildContext context, String message) {
//   SemanticsService.announce(message, Directionality.of(context));
// }