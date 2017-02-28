import java.util.Arrays;
ArrayList<Taobao> tb;
Table table;
String[] dateList;

void setup() {
  loadData();
  analyzeData();
}

void loadData() {
  tb = new ArrayList<Taobao>(); 
  table = loadTable("expressingdata_place.csv", "header");  
  for ( TableRow row : table.rows () ) {
    String name = row.getString("name");
    float price = row.getFloat("price");
    String date = row.getString("date");
    //question about date here. may search later
    //float lat = row.getFloat("latitude");
    //float lng = row.getFloat("longitude");
    //String cityName = row.getString("city");
    //println(name, date);
    tb.add(new Taobao(name, price, date));
  }
  println(tb.date);
}

void analyzeData(){
}