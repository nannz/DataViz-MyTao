//this version is about mapping the items on a line
import org.gicentre.utils.spatial.*;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.util.Calendar;
import processing.pdf.*;

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
color catColor;

int again = 0;

float circleX, circleY;
int y;//1-2012 2-2013 3-2014 4-2015

boolean savePDF = false;

void setup()
{
  size(1280, 569, P2D);
  noStroke();
  smooth();
  pixelDensity(2);
  // load font
  PFont font = createFont("AvenirNext-UltraLight", 16);
  textFont(font);

  // add background color
  //background(43, 237, 237); mint green
  background(255);

  structure();

  loadData();
  drawData();
  
  frameRate(1);
}

void draw() {
  background(255);
  

  if (savePDF) {
    beginRecord(PDF, "######.pdf");
  }
  
  //if(again%2 == 0){
  //  drawData();
  //}
  drawData();
  structure();
  if (savePDF) {
    savePDF = false;
    endRecord();
  }
}
void structure() {
  stroke(0);
  strokeWeight(1);
  int lineStart = 10;
  int lineEnd = width-10;
  line(lineStart, height/2, lineEnd, height/2);
  section = (lineStart+lineEnd)/4;
  
  //sectionMonth = section/6;
  sectionMonth = section/12;
  
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
    //int y;//1-2012 2-2013 3-2014 4-2015
    m = city.month;
    color c = lerpColor(c_2012, c_2015, 0.2);//(int,int,amt)
    //cCircle = map(c,c_2012,c_2015,)
    int cat = city.category;
    priceSize = map(city.price, 7, 1116, 5, 100);
    //use section(4) and sectionMonth(6)
    noStroke();
    categoryColor(cat);
    if (city.year == 2015 ) {  //green--2015
      y = 4;
    } else if (city.year == 2014) {
      y = 3;
    } else if (city.year == 2013) {
      y = 2;
    } else if (city.year == 2012) {
      y = 1;
    }
    drawCircle(y, m, priceSize);
  }
}

void drawCircle(int y, int m, float p) {// int c, float p) {
  ////float circleX, circleY; //i make it global
  //if ( m <= 6 ) {
  //  circleX = random(section*(y-1)+sectionMonth*(m-1), section*(y-1)+sectionMonth*(m-1));
  //  circleY = random(10, height/2);
  //} else if (m>=7) {
  //  circleX = random(section*(y-1)+sectionMonth*(m-7), section*(y-1)+sectionMonth*(m-6));
  //  circleY = random(height/2, height-10);
  //}
  circleX = random(section*(y-1)+sectionMonth*(m-1), section*(y-1)+sectionMonth*(m-1));
  circleY = random(10, height-10);
  noStroke();
  ellipse(circleX, circleY, p, p);
}

void categoryColor(int cat) {
  //color c1 = color(0, 0, 251);
  //color c2 = color(228, 0, 127);
  //float x =  0.166*(cat-1);
  //catColor = lerpColor(c1, c2, x);
  ////catColor = ;
  //fill(catColor, 150);
  
  color c1 = color(43,63,247); //blue - cat = 1
  color c2 = color(239,46,189); //pink - cat = 2
  color c3 = color(62,230,247); //mint - cat = 3
  color c4 = color(30,244,157);//green - cat = 4
  color c5 = color(255,217,29); //yello - cat = 5
  color c6 = color(255,131,8);//orange - cat = 6
  color c7 = color(242,48,58);//red - cat = 7
  
  if(cat == 1){
    fill(c1,150);
  }else if(cat == 2){
    fill(c2,150);
  }else if(cat == 3){
    fill(c3,150);
  }else if(cat == 4){
    fill(c4,150);
  }else if(cat == 5){
    fill(c5,150);
  }else if(cat == 6){
    fill(c6,150);
  }else if(cat == 7){
    fill(c7,150);
  }
  
}

void keyPressed() {
  if ( key == ' ') {
    again = again+1;
  }
  if (key=='p' || key=='P') savePDF = true;
}