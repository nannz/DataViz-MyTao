import java.util.Date;
import java.text.SimpleDateFormat;
import java.util.Calendar;


class City {
  PVector pos;
  String name;
  Date date;
  int year;
  int day;

  SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
  Calendar cal = Calendar.getInstance();

  City(PVector _pos, String _name, String _date) {
    pos = _pos;
    name = _name;
    try {
      date = format.parse(_date);
      cal.setTime(date);
    }
    catch(Exception e) {
      e.printStackTrace();
    }
    year = cal.get(Calendar.YEAR);
    println(date, cal.get(Calendar.DAY_OF_YEAR));
  }
}