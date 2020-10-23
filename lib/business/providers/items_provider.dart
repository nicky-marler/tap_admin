part of business_library;


//This will be the list of days. Call widget with
class ItemsProvider with ChangeNotifier {

  final String businessId;

  ItemsProvider({@required this.businessId});
  

  List<Item> _mondayItems = [];
  List<Item> _tuesdayItems = [];
  List<Item> _wednesdayItems = [];
  List<Item> _thursdayItems = [];
  List<Item> _fridayItems = [];
  List<Item> _saturdayItems = [];
  List<Item> _sundayItems = [];

  List<int> get weekDays{
    return [1,2,3,4,5,6,7];
  }

  Future<void> initFromFirestore(int dayOfWeek) async {
    switch (dayOfWeek) {
      case DateTime.monday:
        _mondayItems = await BusinessProvider.getItemsByDay('MONDAY', businessId);
        break;
      case DateTime.tuesday:
        _tuesdayItems = await BusinessProvider.getItemsByDay('TUESDAY', businessId);
        break;
      case DateTime.wednesday:
        _wednesdayItems = await BusinessProvider.getItemsByDay('WEDNESDAY', businessId);
        break;
      case DateTime.thursday:
        _thursdayItems = await BusinessProvider.getItemsByDay('THURSDAY', businessId);
        break;
      case DateTime.friday:
        _fridayItems = await BusinessProvider.getItemsByDay('FRIDAY', businessId);
        break;
      case DateTime.saturday:
        _saturdayItems = await BusinessProvider.getItemsByDay('SATURDAY', businessId);
        break;
      case DateTime.sunday:
        _sundayItems = await BusinessProvider.getItemsByDay('SUNDAY', businessId);
        break;
      default:
    }


  }

  Future<void> dayRemoveAt(int dayOfWeek,int index, String itemId) async {
    await BusinessProvider.deleteItem(itemId);
    switch (dayOfWeek) {
      case DateTime.monday:
        _mondayItems.removeAt(index);
        break;
      case DateTime.tuesday:
        _tuesdayItems.removeAt(index);
        break;
      case DateTime.wednesday:
        _wednesdayItems.removeAt(index);
        break;
      case DateTime.thursday:
        _thursdayItems.removeAt(index);
        break;
      case DateTime.friday:
        _fridayItems.removeAt(index);
        break;
      case DateTime.saturday:
        _saturdayItems.removeAt(index);
        break;
      case DateTime.sunday:
        _sundayItems.removeAt(index);
        break;
      default:
    }

  }

  List<Item> getDayItems(int dayOfWeek){
    List<Item> results;

    switch (dayOfWeek) {
      case DateTime.monday:
        results = [..._mondayItems];
        break;
      case DateTime.tuesday:
        results = [..._tuesdayItems];
        break;
      case DateTime.wednesday:
        results = [..._wednesdayItems];
        break;
      case DateTime.thursday:
        results = [..._thursdayItems];
        break;
      case DateTime.friday:
        results = [..._fridayItems];
        break;
      case DateTime.saturday:
        results = [..._saturdayItems];
        break;
      case DateTime.sunday:
        results = [..._sundayItems];
        break;
      default:
    }

    return results;

  }

}