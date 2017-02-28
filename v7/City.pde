import java.util.Date;
import java.text.SimpleDateFormat;
import java.util.Calendar;


class City {
  //PVector pos;
  String name;
  Date date;
  int year;
  int day;
  int month;
  float price;
  int category;

  SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
  Calendar cal = Calendar.getInstance();

  City( String _name, String _date,Float _price,int _category) {
    //pos = _pos;
    name = _name;
    price = _price;
    category = _category;
    
    try {
      date = format.parse(_date);
      cal.setTime(date);
    }
    catch(Exception e) {
      e.printStackTrace();
    }
    year = cal.get(Calendar.YEAR);
    month = cal.get(Calendar.MONTH);
    day =  cal.get(Calendar.DAY_OF_YEAR);
    println(date, day,month);
  }
}