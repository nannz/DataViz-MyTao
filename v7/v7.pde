//this version is about mapping the items on a line
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


int section;
int sectionMonth;
int m; //city.month
float priceSize;//city.price
color cCircle;

float circleX, circleY;

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

  structure();


  loadData();
  drawData();
}

void draw() {
  //background(255);

  //drawData();
}
void structure() {
  stroke(0);
  strokeWeight(1);
  int lineStart = 10;
  int lineEnd = width-10;
  line(lineStart, height/2, lineEnd, height/2);
  section = (lineStart+lineEnd)/4;
  sectionMonth = section/6;
  for (int a = (lineStart+lineEnd)/8; a<=lineEnd-lineStart; a = a+(lineStart+lineEnd)/4) {
    //4 ellipses for years
    fill(0);
    ellipse(a, height/2, 10, 10);
  }
}
void loadData() {
  coords = new ArrayList<City>(); 
  Table taobao = loadTable("expressingdata_place_2.csv", "header");

  for ( TableRow row : taobao.rows () ) {
    String name = row.getString("name");
    float price = row.getFloat("price");
    String date = row.getString("date");
    int category = row.getInt("category");
    coords.add(new City(name, date, price, category));
  }
}

void drawData() {
  for ( City city : coords) {

    color c_2015 = color(0, 255, 0, 150);
    color c_2014 = color(0, 255, 179, 150);
    color c_2013 = color(0, 255, 255, 150);
    color c_2012 = color(43, 57, 226, 150);   
    //int categoryFirst = city.category;
    m = city.month;
    color c = lerpColor(c_2012,c_2015,0.2);//(int,int,amt)
    //cCircle = map(c,c_2012,c_2015,)
    priceSize = map(city.price, 7, 1116, 5, 100);
    //use section(4) and sectionMonth(6)
    noFill();
    if (city.year == 2015 ) {  //green--2015
      if (m == 1) {
        drawCirclesUp();
      } else if (m ==2) {
       drawCirclesUp();
      }else if (m ==3) {
       drawCirclesUp();
      }else if (m ==4) {
       drawCirclesUp();
      }else if (m ==5) {
       drawCirclesUp();
      }else if (m ==6) {
       drawCirclesUp();
      }else if (m ==7) {
       drawCirclesDown();
      }else if (m ==8) {
       drawCirclesDown();
      }else if (m ==9) {
       drawCirclesDown();
      }else if (m ==10) {
        
       drawCirclesDown();
      }else if (m ==11) {
       drawCirclesDown();
      }else if (m ==12) {
       drawCirclesDown();
      }

      //for (int m = 1; m<=6; m++) {
      //  float ellipseX = random(section*3+sectionMonth*(m-1), section*3+sectionMonth*m);
      //  float ellipseY = random(0, height/2);
      //  ellipse(ellipseX, ellipseY, 20, 20);
      //}
      //text("2015", width/2, height/2);
    }
  }
}
void drawCirclesUp() {
 //for Jan to June
 float ellipseX = random(section*3+sectionMonth*(m-1), section*3+sectionMonth*m);
 float ellipseY = random(0, height/2);
 ellipse(ellipseX, ellipseY, priceSize, priceSize);
}
void drawCirclesDown(){
 //for july - dec
 float ellipseX = random(section*3+sectionMonth*(m-7), section*3+sectionMonth*(m-6));
 float ellipseY = random(height/2, height);
 ellipse(ellipseX, ellipseY, priceSize, priceSize);
}

//void drawCircle(int y,int m, int c, float p){
//  //float circleX, circleY; //i make it global
//  if( m <= 6 ){
//    circleX = random(section*(y-1)+sectionMonth*(m-7), section*(y-1)+sectionMonth*(m-6));
//    circleY = random(0, height/2);
//  }
//  else if (m>=7){
//    circleX = random(section*(y-1)+sectionMonth*(m-7), section*(y-1)+sectionMonth*(m-6));
//    circleY = random(height/2, height);
//  }
//  ellipse(circleX, circleY, p, p);
//}
void keyPressed() {
}