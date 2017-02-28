//this version is about mapping the day on an arc
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
int r=250;
boolean hover = false;

int drawMode = 1;

boolean savePDF = false;
int rr = 180;

void setup()
{
  size(773, 569, P2D);
  noStroke();
  smooth();
  pixelDensity(2);

  // load font
  PFont font = createFont("AvenirNext-UltraLight", 16);
  textFont(font);

  // add background color
  //background(43, 237, 237); mint green
  background(255);

  loadData();
  drawData();
}

void draw() {
  background(255);

  if (savePDF) {
    beginRecord(PDF, "######.pdf");
  }


  drawData();

  if (savePDF) {
    savePDF = false;
    endRecord();
  }
}

void loadData() {
  coords = new ArrayList<City>(); 
  Table taobao = loadTable("expressingdata_final.csv", "header");

  for ( TableRow row : taobao.rows () ) {
    String name = row.getString("name");
    float price = row.getFloat("price");
    String date = row.getString("date");
    coords.add(new City(name, date, price));
  }
}

void drawData() {
  //fill(43, 57, 226, 200);
  for ( City city : coords) {
    float day_arc_start = -PI/2;
    float day_arc = map(city.day, 1, 365, 0, PI*2);
    float day_arc_end = -PI/2 + day_arc;
    float priceLength;
    color c_2015 = color(0, 255, 0, 150);
    color c_2014 = color(0, 255, 179, 150);
    color c_2013 = color(0, 255, 255, 150);
    color c_2012 = color(43, 57, 226, 150);
    priceLength = map(city.price, 7, 1116, 200, 270);
    //strokeWeight(priceLength);
    //strokeCap(SQUARE);
    noFill();
    strokeWeight(0.75);
    //int rr = 180;
    if (city.year == 2015 && drawMode == 1) {  //green--2015
      stroke(c_2015);   
      //arc(width/2, height/2, rr, rr, day_arc_end - PI*2/365, day_arc_end);
      beginShape();
      //vertex(width/2+rr*cos( -PI/2+day_arc), height/2 + rr*sin( -PI/2+day_arc));
      vertex(width/2 + priceLength*cos(-PI/2+day_arc), height/2 + priceLength*sin(-PI/2+day_arc));//the point
      
      vertex(width/2 + rr*cos(-PI/2+day_arc- PI*8/365), height/2 + rr*sin(-PI/2+day_arc- PI*8/365));//the two points beside it
      vertex(width/2 + rr*cos(-PI/2+day_arc+ PI*8/365), height/2 + rr*sin(-PI/2+day_arc+ PI*8/365));
      endShape(CLOSE);
    } else if (city.year == 2014 && drawMode == 2) { 
      stroke(c_2014);
      beginShape();
      //vertex(width/2+rr*cos( -PI/2+day_arc), height/2 + rr*sin( -PI/2+day_arc));
      vertex(width/2 + priceLength*cos( -PI/2+day_arc), height/2 + priceLength*sin( -PI/2+day_arc));
      
      vertex(width/2 + rr*cos(-PI/2+day_arc- PI*8/365), height/2 + rr*sin(-PI/2+day_arc- PI*8/365));//the two points beside it
      vertex(width/2 + rr*cos(-PI/2+day_arc+ PI*8/365), height/2 + rr*sin(-PI/2+day_arc+ PI*8/365));
      endShape(CLOSE);
    } else if (city.year == 2013 && drawMode == 3) {
      stroke(c_2013);
      beginShape();
      //vertex(width/2+rr*cos( -PI/2+day_arc), height/2 + rr*sin( -PI/2+day_arc));
      vertex(width/2 + priceLength*cos( -PI/2+day_arc), height/2 + priceLength*sin( -PI/2+day_arc));
      
      vertex(width/2 + rr*cos(-PI/2+day_arc- PI*8/365), height/2 + rr*sin(-PI/2+day_arc- PI*8/365));//the two points beside it
      vertex(width/2 + rr*cos(-PI/2+day_arc+ PI*8/365), height/2 + rr*sin(-PI/2+day_arc+ PI*8/365));
      endShape(CLOSE);
    } else if (city.year == 2012 && drawMode == 4) {//blue  
      stroke(c_2012);
      beginShape();
      //vertex(width/2+rr*cos( -PI/2+day_arc), height/2 + rr*sin( -PI/2+day_arc));
      vertex(width/2 + priceLength*cos( -PI/2+day_arc), height/2 + priceLength*sin( -PI/2+day_arc));
      
      vertex(width/2 + rr*cos(-PI/2+day_arc- PI*8/365), height/2 + rr*sin(-PI/2+day_arc- PI*8/365));//the two points beside it
      vertex(width/2 + rr*cos(-PI/2+day_arc+ PI*8/365), height/2 + rr*sin(-PI/2+day_arc+ PI*8/365));
      endShape(CLOSE);
    }
  }
  noStroke();
  fill(0, 100);
  ellipse(width/2, height/2, rr+180, rr+180);
}

void keyPressed() {
  if (key == '1') drawMode = 1;
  if (key == '2') drawMode = 2;
  if (key == '3') drawMode = 3;
  if (key == '4') drawMode = 4;
  if (key=='s')saveFrame("###.jpeg");
  if (key=='p' || key=='P') savePDF = true;
}