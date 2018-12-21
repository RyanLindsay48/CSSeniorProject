/**
* The TimeStampFormatter class is used to format the timestrings that are associated to an exposure.
*/
class TimeStampFormatter{
  String dateString;
  String timeString;

  TimeStampFormatter(this.dateString, this.timeString);

  static String getFormattedDate(String dateString){
    dateString = dateString;
    List<String> dates = dateString.split('-');
    String year = dates[0];
    String month = dates[1];
    String day = dates[2];

    if(month == '01')
      month = 'January';
    else if(month == '02')
      month = 'February';
    else if(month == '03')
      month = 'March';
    else if(month == '04')
      month = 'April';
    else if(month == '05')
      month = 'May';
    else if(month == '06')
      month = 'June';
    else if(month == '07')
      month = 'July';
    else if(month == '08')
      month = 'August';
    else if(month == '09')
      month = 'September';
    else if(month == '10')
      month = 'October';
    else if(month == '11')
      month = 'November';
    else
      month = 'December';
    return month + ' ' + day + ', ' + year;
  }

  static String getFormattedTime(String timeString) {
      timeString = timeString;
      String hour;
      String minutes;
      String ampm = 'AM';

      List<String> time = timeString.split(':');
      hour = time[0].substring(1,2);
      minutes = time[1];
      var iHour = int.parse(hour);
      if(iHour < 1){
        hour = '12';
      }
      if(iHour > 12){
        iHour = iHour - 12;
        hour = iHour.toString();
        ampm = 'PM';
      }
      return hour + ':' + minutes + ' ' + ampm;
  }
}
