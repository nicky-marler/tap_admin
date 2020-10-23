part of business_library;


//This will be the list of days. Call widget with
class OperationalHoursProvider with ChangeNotifier {

  OperationalHours mondayHours = OperationalHours.isClosed();
  OperationalHours tuesdayHours = OperationalHours.isClosed();
  OperationalHours wednesdayHours = OperationalHours.isClosed();
  OperationalHours thursdayHours = OperationalHours.isClosed();
  OperationalHours fridayHours = OperationalHours.isClosed();
  OperationalHours saturdayHours = OperationalHours.isClosed();
  OperationalHours sundayHours = OperationalHours.isClosed();


  
  // List<OperationalHours> get weekHours {
  //   return [mondayHours, tuesdayHours, wednesdayHours, thursdayHours, fridayHours, saturdayHours, sundayHours];
  // }
  List<int> get weekHours{
    return [1,2,3,4,5,6,7];
  }



  OperationalHours getDayHours(int dayOfWeek){
    OperationalHours results;

    switch (dayOfWeek) {
      case DateTime.monday:
        results = mondayHours;
        break;
      case DateTime.tuesday:
        results = tuesdayHours;
        break;
      case DateTime.wednesday:
        results = wednesdayHours;
        break;
      case DateTime.thursday:
        results = thursdayHours;
        break;
      case DateTime.friday:
        results = fridayHours;
        break;
      case DateTime.saturday:
        results = saturdayHours;
        break;
      case DateTime.sunday:
        results = sundayHours;
        break;
      default:
    }

    return results;

  }

  void setDayHours(int dayOfWeek, OperationalHours newHours){
    switch (dayOfWeek) {
      case DateTime.monday:
        mondayHours = newHours;
        break;
      case DateTime.tuesday:
        tuesdayHours = newHours;
        break;
      case DateTime.wednesday:
        wednesdayHours = newHours;
        break;
      case DateTime.thursday:
        thursdayHours = newHours;
        break;
      case DateTime.friday:
        fridayHours = newHours;
        break;
      case DateTime.saturday:
        saturdayHours = newHours;
        break;
      case DateTime.sunday:
        sundayHours = newHours;
        break;
      default:
    }
  }

}