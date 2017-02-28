//this version is about mapping the day on an arc
import org.gicentre.utils.spatial.*;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.util.Calendar;

ArrayList<City> coords;
PVector tlCorner, brCorner;   // Corners of map in WebMercator coordinates.
float tlLat, tlLng, brLat, brLng;
String currentCity = "";
float currentCityPosX, currentCityPosY;
WebMercator proj;

void setup()
{
  size(773, 569, P2D);
  noStroke();
  smooth();

  // load font
  PFont font = createFont("AvenirNext-UltraLight", 16);
  textFont(font);

  // add background color
  //background(43, 237, 237); mint green
  background(255);

  loadData();
  drawData();
}

//void draw() {
  //background(43, 237, 237);
  //background(255);
  //PShape bgShape = loadShape("china_new_2.svg");
  //shape(bgShape, 0, 0, width, height);
  //drawData();
//}

void loadData() {
  coords = new ArrayList<City>(); 
  Table taobao = loadTable("expressingdata_final.csv", "header");

  for ( TableRow row : taobao.rows () ) {
    String name = row.getString("name");
    float price = row.getFloat("price");
    String date = row.getString("date");
    coords.add(new City(name, date));
  }
}

void drawData() {
  //fill(43, 57, 226, 200);
  for ( City city : coords) {
    float day_arc_start = -PI/2;
    float day_arc = map(city.day, 1, 365, 0, PI*2);
    float day_arc_end = -PI/2 + day_arc;
    strokeWeight(15);
    strokeCap(SQUARE);
    noFill();
    if(city.year == 2015){  //green--2015
      stroke(0, 255, 0, 150);
      arc(width/2,height/2,270,270,day_arc_end - PI*2/365,day_arc_end);
    }else if (city.year == 2014){ 
      stroke(0, 255, 179, 150);
      arc(width/2,height/2,230,230,day_arc_end - PI*2/365,day_arc_end);
    }else if (city.year == 2013){
      stroke(0, 255, 255, 150);
      arc(width/2,height/2,200,200,day_arc_end - PI*2/365,day_arc_end);
    }else if(city.year == 2012){//blue  
      stroke(43, 57, 226, 150);
      arc(width/2,height/2,150,150,day_arc_end - PI*2/365,day_arc_end);
    }
  }
}


// Convert from WebMercator coordinates to screen coordinates.
PVector geoToScreen(PVector geo)
{
  return new PVector(map(geo.x, tlCorner.x, brCorner.x, 0, width), 
    map(geo.y, tlCorner.y, brCorner.y, 0, height));
}