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

int sectionLike;
int likeValue; 

int m; //city.month
float priceSize;//city.price
color cCircle;
color catColor;

int again = 0;

float circleX, circleY;
int y;//1-2012 2-2013 3-2014 4-2015

boolean savePDF = false;
int margin = 70;

int x1, x2, x3, x4, x5, x6, x7;//in cat count
float p; //city.price
float xp1 = 0; //xp=xp+p
float xp2 = 0;
float xp3 = 0;
float xp4 = 0;
float xp5 = 0;
float xp6 = 0;
float xp7 = 0;

float CatLength;

int yItem2015 = 0;
int yItem2014 = 0;
int yItem2013 = 0;
int yItem2012 = 0;

void setup()
{
  size(1280, 600, P2D);
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
  //background(255);


  if (savePDF) {
    beginRecord(PDF, "######.pdf");
  }

  //if(again%2 == 0){
  //  drawData();
  //}
  //drawData();
  //structure();
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

  int heightStart = margin;
  int heightEnd = height-margin;

  line(lineStart, height-10, lineEnd, height-10);
  section = (lineStart+lineEnd)/4; 
  //sectionMonth = section/6;
  sectionMonth = section/12;

  sectionLike = ((heightStart + heightEnd)/10);

  for (int a = (lineStart+lineEnd)/8; a<=lineEnd-lineStart; a = a+(lineStart+lineEnd)/4) {
    //4 ellipses for years
    fill(0);
    ellipse(a, height-10, 10, 10);
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
    int like = row.getInt("like");
    coords.add(new City(name, date, price, category, like));
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
    likeValue = city.like;
    color c = lerpColor(c_2012, c_2015, 0.2);//(int,int,amt)
    //cCircle = map(c,c_2012,c_2015,)
    int cat = city.category;
    p = city.price;
    priceSize = map(city.price, 7, 1116, 5, 100);
    //use section(4) and sectionMonth(6)
    noStroke();
    categoryColor(cat);   
    printCatCount(cat);

    if (city.year == 2015 ) {  //green--2015
      //int yItem2015;
      y = 4;
      yItem2015 ++;
    } else if (city.year == 2014) {
      y = 3;
      yItem2014 ++;
    } else if (city.year == 2013) {
      y = 2;
      yItem2013 ++;
    } else if (city.year == 2012) {
      y = 1;
      yItem2012 ++;
    }
    drawCircle(y, m, priceSize, likeValue);
  }

  print("cat1: "+ x1 + " " + "priceTotal: "+ xp1);
  print("\ncat2: "+ x2 + " " + "priceTotal: "+ xp2);
  print("\ncat3: "+ x3 + " " + "priceTotal: "+ xp3);
  print("\ncat4: "+ x4 + " " + "priceTotal: "+ xp4);
  print("\ncat5: "+ x5 + " " + "priceTotal: "+ xp5);
  print("\ncat6: "+ x6 + " " + "priceTotal: "+ xp6);
  print("\ncat7: "+ x7 + " " + "priceTotal: "+ xp7);
  print("\nitemCount2015: " + yItem2015);
  print("\nitemCount2014: " + yItem2014);
  print("\nitemCount2013: " + yItem2013);
  print("\nitemCount2012: " + yItem2012);

  drawCat(xp1, 1);
  drawCat(xp2, 2);
  drawCat(xp3, 3);
  drawCat(xp4, 4);
  drawCat(xp5, 5);
  drawCat(xp6, 6);
  drawCat(xp7, 7);
}
void drawCat(float xpN, int xp) {
  //float CatLength;
  CatLength = map(xpN, 7, 1116, 10, 50);
  rect(10, 10*xp, CatLength, 8);
}

void printCatCount(int cat) {
  //int x1;
  if (cat == 1) {
    x1=x1+1;
    xp1 = xp1 + p;
  } else if (cat == 2) {
    x2 ++;
    xp2 = xp2+p;
  } else if (cat == 3) {
    x3 ++;
    xp3 = xp3+p;
  } else if (cat == 4) {
    x4 ++;
    xp4 = xp4+p;
  } else if (cat == 5) {
    x5 ++;
    xp5 = xp5+p;
  } else if (cat == 6) {
    x6 ++;
    xp6 = xp6+p;
  } else if (cat == 7) {
    x7 ++;
    xp7 = xp7+p;
  }
}
void drawCircle(int y, int m, float p, int l) {// int c, float p) {

  circleX = random(section*(y-1)+sectionMonth*(m-1), section*(y-1)+sectionMonth*(m-1));
  //circleY = random(10, height-10);
  circleY = random(margin+sectionLike*(10-l), margin+sectionLike*(11-l));
  //circleY = margin+sectionLike*(10-l);

  noStroke();
  ellipse(circleX, circleY, p, p);
}

void categoryColor(int cat) {
  color c1 = color(43, 63, 247); //blue - cat = 1
  color c2 = color(239, 46, 189); //pink - cat = 2
  color c3 = color(62, 230, 247); //mint - cat = 3
  color c4 = color(30, 244, 157);//green - cat = 4
  color c5 = color(255, 217, 29); //yello - cat = 5
  color c6 = color(255, 131, 8);//orange - cat = 6
  color c7 = color(242, 48, 58);//red - cat = 7

  if (cat == 1) {
    fill(c1, 150);
  } else if (cat == 2) {
    fill(c2, 150);
  } else if (cat == 3) {
    fill(c3, 150);
  } else if (cat == 4) {
    fill(c4, 150);
  } else if (cat == 5) {
    fill(c5, 150);
  } else if (cat == 6) {
    fill(c6, 150);
  } else if (cat == 7) {
    fill(c7, 150);
  }
}

void keyPressed() {
  if ( key == ' ') {
    again = again+1;
  }
  if (key=='p' || key=='P') savePDF = true;
}