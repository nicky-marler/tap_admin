part of general_widgets_library;

class TimeStartEndPicker extends StatelessWidget {
  //final Placemark placemark;
  final String day;
  final int hour;
  final int min;

  final ValueChanged<String> setTimeValue;

  TimeStartEndPicker(this.day, this.hour, this.min, this.setTimeValue);

  @override
  Widget build(BuildContext context) {
    return Container();
    //return showTimePicker(context: context, initialTime: null)
    
  }
}
