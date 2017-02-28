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
  background(43, 237, 237);

  setupMap();
  loadData();
}

void draw() {
  background(43, 237, 237);
  PShape bgShape = loadShape("china_new_2.svg");
  shape(bgShape, 0, 0, width, height);
  //drawData();
}

void loadData() {
  coords = new ArrayList<City>(); 
  Table taobao = loadTable("expressingdata_place.csv", "header");

  for ( TableRow row : taobao.rows () ) {
    String name = row.getString("name");
    float price = row.getFloat("price");
    String date = row.getString("date");
    float lat = row.getFloat("latitude");
    float lng = row.getFloat("longitude");
    String cityName = row.getString("city");
    //println(lng, lat, cityName);
    PVector pos = proj.transformCoords(new PVector(lng, lat));
    coords.add(new City(pos, cityName,date));
    //println(City.year);
  }
}
void setupMap() {
  // create projection
  proj = new WebMercator();
  // China Map
  tlLng = 73.554302;
  tlLat = 53.562517;
  brLng = 134.775703;
  brLat = 18.153878;

  // Store the WebMercator coordinates of the corner of the map.
  // The lat/long of the corners was provided by OpenStreetMap
  // when exporting the map tile.
  tlCorner = proj.transformCoords(new PVector(tlLng, tlLat));
  brCorner = proj.transformCoords(new PVector(brLng, brLat));
}

void drawData() {
  //fill(43, 57, 226, 200);
  for ( City city : coords) {
    PVector scrCoord = geoToScreen(city.pos);
    //println(scrCoord.x, scrCoord.y);
    fill(43, 57, 226, 200);
    ellipse(scrCoord.x, scrCoord.y, 6, 6);

    if ( dist(scrCoord.x, scrCoord.y, mouseX, mouseY) < 5) {
      currentCity = city.name;
      currentCityPosX = scrCoord.x;
      currentCityPosY = scrCoord.y;
      fill(0);
      PFont font = createFont("AvenirNext-UltraLight", 16);
      textFont(font);
      text(currentCity, currentCityPosX, currentCityPosY);
    }

    // draw arcs
    stroke(0);
    PVector rawCoord = proj.invTransformCoords(new PVector(city.pos.x, city.pos.y));
    drawArc(rawCoord, new PVector(121.4888705, 31.22534));
    noStroke();
    //print(city.pos.x , city.pos.y);
    //break;
  }
}

// function to draw great cirlce arc between two geo coordinates
// When flights circle around the globe, we have coordinates
// jumps from left side and right side, to prevent that, we need to 
// compare current point with previous point.
void drawArc(PVector v1, PVector v2)
{ 
  ArrayList<PVector> segments = getArcSegments(v1, v2, 100);
  float currLng, prevLng = 1000;
  if (segments != null) {
    beginShape();
    for (PVector seg : segments) {
      // check whether currLng exist
      currLng = seg.x;
      // check whether prevLng exist
      if (prevLng != 1000) {
        if ( abs(currLng - prevLng) > 350 ) {
          endShape();
          beginShape();
        }
      }
      PVector coord = geoToScreen(proj.transformCoords(seg));
      vertex(coord.x, coord.y);
      // assign currLng to prevLng
      prevLng = currLng;
    }
    endShape();
  }
}
// v1, v2 are PVector of coordinates ( longitude, latitude )
// num is the number of segments, the value should be greater than 3, bigger number better details
ArrayList<PVector> getArcSegments(PVector v1, PVector v2, int num) 
{
  // limitations of the gicentre utils
  if (abs(v1.y) > 88.0 || abs(v2.y) > 88.0) {
    return null;
  }

  ArrayList<PVector> segments = new ArrayList<PVector>();

  int numberOfSegments = num;
  int onelessNumberOfSeg = numberOfSegments - 1;
  float fractionalIncrement = 1.0/onelessNumberOfSeg;

  float v1LonRadians = radians(v1.x);
  float v1LatRadians = radians(v1.y);
  float v2LonRadians = radians(v2.x);
  float v2LatRadians = radians(v2.y);

  float deltaLat = v1LatRadians-v2LatRadians;
  float deltaLon = v1LonRadians-v2LonRadians;

  float haversine = pow(sin(deltaLat/2), 2) + cos(v1LatRadians)*cos(v2LatRadians)*pow(sin(deltaLon/2), 2);
  float distanceRadians = 2 * atan2(sqrt(haversine), sqrt(1-haversine));

  segments.add(v1);

  float f = fractionalIncrement;
  int counter = 1;
  while (counter <  onelessNumberOfSeg) {
    // f is expressed as a fraction along the route from point 1 to point 2
    float A = sin((1-f)*distanceRadians) / sin(distanceRadians);
    float B = sin(f*distanceRadians) / sin(distanceRadians);
    float x = A*cos(v1LatRadians)*cos(v1LonRadians) + B*cos(v2LatRadians)*cos(v2LonRadians);
    float y = A*cos(v1LatRadians)*sin(v1LonRadians) + B*cos(v2LatRadians)*sin(v2LonRadians);
    float z = A*sin(v1LatRadians) + B*sin(v2LatRadians);
    float newlat = atan2(z, sqrt(pow(x, 2) + pow(y, 2)));
    float newlon = atan2(y, x);
    float newlatDegrees = degrees(newlat);
    float newlonDegrees = degrees(newlon);
    if (abs(newlatDegrees) > 88.0) {
      return null;
    }
    segments.add(new PVector(newlonDegrees, newlatDegrees));
    counter += 1;
    f = f + fractionalIncrement;
  }
  segments.add(v2);

  return segments;
}

// Convert from WebMercator coordinates to screen coordinates.
PVector geoToScreen(PVector geo)
{
  return new PVector(map(geo.x, tlCorner.x, brCorner.x, 0, width), 
    map(geo.y, tlCorner.y, brCorner.y, 0, height));
}