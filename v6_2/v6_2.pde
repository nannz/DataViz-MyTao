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
  //drawData();
}

void draw() {
  background(255);

  if (savePDF) {
    beginRecord(PDF, "######.pdf");
  }

  //if (mouseX<width/2+r && mouseX>width/2-r && mouseY>height/2-r && mouseY<height/2+r) {

  //  for (float a=0; a<PI*2; a=a+PI/6) {
  //    stroke(190);
  //    strokeWeight(1);
  //    line(width/2, height/2, r*cos(a)+width/2, r*sin(a)+height/2);
  //  }
  //  noStroke();
  //  fill(255);
  //  ellipse(width/2, height/2, 420, 420);//mask
  //}
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
    priceLength = map(city.price, 7, 1116, 20, 250);
    strokeWeight(priceLength);
    strokeCap(SQUARE);
    noFill();
    textAlign(CENTER, CENTER);
    textSize(25);

    if (city.year == 2015 ) {  //green--2015
      stroke(c_2015);
      arc(width/2, height/2, 270, 270, day_arc_end - PI*2/365, day_arc_end);

      //noStroke();
      //fill(255);
      //ellipse(width/2, height/2, 250, 250);

      //fill(c_2015);
      //text("2015", width/2, height/2);
    } else if (city.year == 2014 ) { 
      stroke(c_2014);
      arc(width/2, height/2, 270, 270, day_arc_end - PI*2/365, day_arc_end);

      //noStroke();
      //fill(255);
      //ellipse(width/2, height/2, 210, 210);

      //fill(c_2014);
      //text("2014", width/2, height/2);
    } else if (city.year == 2013) {
      stroke(c_2013);
      arc(width/2, height/2, 270, 270, day_arc_end - PI*2/365, day_arc_end);

      //noStroke();
      //fill(255);
      //ellipse(width/2, height/2, 190, 190);

      //fill(c_2013);
      //text("2013", width/2, height/2);
    } else if (city.year == 2012) {//blue  
      stroke(c_2012);
      arc(width/2, height/2, 270, 270, day_arc_end - PI*2/365, day_arc_end);

      //noStroke();
      //fill(255);
      //ellipse(width/2, height/2, 130, 130);

      //fill(c_2012);
      //text("2012", width/2, height/2);
    }
    //noStroke();
    //fill(255);
    //ellipse(width/2, height/2, 250, 250);
    noStroke();
    fill(255);
    ellipse(width/2, height/2, 250, 250);
  }
}

void keyPressed() {
  if (key == '1') drawMode = 1;
  if (key == '2') drawMode = 2;
  if (key == '3') drawMode = 3;
  if (key == '4') drawMode = 4;
  if (key=='s')saveFrame("###.jpeg");
  if (key=='p' || key=='P') savePDF = true;
}