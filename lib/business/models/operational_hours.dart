part of business_library;

//If this object is missing. Then it is closed
class OperationalHours {
  //Note. Ignoring businesses that have many open-close times? Maybe?
  int start;
  int end;
  bool bleeds;
  bool isClosed;

  @override
  bool operator ==(x) => (x is OperationalHours &&
      this.startTimeOfDay == x.startTimeOfDay &&
      this.endTimeOfDay == x.endTimeOfDay);

  @override
  int get hashCode => startTimeOfDay.hashCode ^ endTimeOfDay.hashCode;

  String timeString(BuildContext context) =>
      "${startTimeOfDay.format(context)} - ${endTimeOfDay.format(context)}";

  TimeOfDay get startTimeOfDay {
    return TimeOfDay(hour: start ~/ 60, minute: start % 60);
  }

  TimeOfDay get endTimeOfDay {
    return TimeOfDay(hour: end ~/ 60, minute: end % 60);
  }

  int get startTotalMinutes => start;
  int get endTotalMinutes => end;

  // set start(int newStart) {
  //   start = newStart;
  //   setBleeds();
  // }

  set setStart(dynamic time) {
    assert(time != null || time == TimeOfDay || time == int,
        'Time must be TimeOfDay or Int');
    if (time is TimeOfDay) {
      start = (time.minute + time.hour * 60);
    } else if (time is int) {
      start = time;
    }
    //else this an issue
  }

  set setEnd(dynamic time) {
    assert(time != null || time == TimeOfDay || time == int,
        'Time must be TimeOfDay or Int');
    if (time is TimeOfDay) {
      end = (time.minute + time.hour * 60);
    } else if (time is int) {
      end = time;
    }
    //else this an issue
  }

  // set end(int newEnd) {
  //   end = newEnd;
  //   setBleeds();
  // }

  void setBleeds() => bleeds = end < start;

  //might remove
  void isAllDay() {
    start = 0;
    end = 1440;
  }

  OperationalHours.isClosed()
      : this.start = null,
        this.end = null,
        bleeds = null,
        isClosed = true;

  OperationalHours.template()
      : this.start = 600,
        this.end = 1200,
        bleeds = false,
        isClosed = false;
  //600 is 10am
  //1,200 is 8pm

  OperationalHours.fromMinutes(int start, int end)
      : this.start = start,
        this.end = end,
        bleeds = end < start,
        isClosed = false;

  OperationalHours.fromTimeOfDay(TimeOfDay start, TimeOfDay end)
      : this.start = (start.minute + start.hour * 60),
        this.end = (end.minute + end.hour * 60),
        bleeds =
            (end.minute + end.hour * 60) < (start.minute + start.hour * 60),
        isClosed = false;

  OperationalHours.fromFirestore(Map data)
      : start = data['start'] ?? 0,
        end = data['end'] ?? 0,
        bleeds = data['bleeds'] ?? false,
        isClosed = data['is_closed'] ?? true;

  Map<String, dynamic> toMap() {
    return {
      'start': start,
      'end': end,
      'bleeds': bleeds,
      'is_closed': isClosed,
    };
  }
}
