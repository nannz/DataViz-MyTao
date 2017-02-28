import java.util.Date;
import java.text.SimpleDateFormat;
import java.util.Calendar;


class City {
  //PVector pos;
  String name;
  Date date;
  int year;
  int day;
  float price;

  SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
  Calendar cal = Calendar.getInstance();

  City( String _name, String _date,Float _price) {
    //pos = _pos;
    name = _name;
    price = _price;
    
    try {
      date = format.parse(_date);
      cal.setTime(date);
    }
    catch(Exception e) {
      e.printStackTrace();
    }
    year = cal.get(Calendar.YEAR);
    day =  cal.get(Calendar.DAY_OF_YEAR);
    println(date, day);
  }
}