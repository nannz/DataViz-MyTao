import org.gicentre.utils.spatial.*;

ArrayList<PVector> coords;
PVector tlCorner, brCorner;   // Corners of map in WebMercator coordinates.
float tlLat, tlLng, brLat, brLng;

float currentCityPosX, currentCityPosY;

void setup()
{
  size(773, 569, P2D);
  noStroke();
  smooth();
  
  // load font
  PFont font = createFont("Avenir-Light", 16);
  textFont(font);

  // add background color
  background(43,237,237);

  // draw background image
  PShape bgShape = loadShape("china_new_2.svg");
  shape(bgShape, 0, 0, width, height);

  loadData();
  drawData();
}

void loadData() {
  // top left corner 
  tlLng = 73.554302;
  tlLat = 53.562517;
  brLng = 134.775703;
  brLat = 18.153878;
  
  coords = new ArrayList<PVector>(); 
  Table taobao = loadTable("expressingdata_place.csv", "header");

  // create projection
  WebMercator proj = new WebMercator();

  for ( TableRow row : taobao.rows () ) {
    String name = row.getString("name");
    float price = row.getFloat("price");
    //question about date here. may search later
    float lat = row.getFloat("latitude");
    float lng = row.getFloat("longitude");
    String city = row.getString("city");
    println(lng, lat,city);
    //coords.add(new PVector(lng, lat));
    //if(city.indexOf("市") > -1){
    coords.add(proj.transformCoords(new PVector(lng, lat)));
    //}
    
   
  }

  // Store the WebMercator coordinates of the corner of the map.
  // The lat/long of the corners was provided by OpenStreetMap
  // when exporting the map tile.
  // transformCoords: Performs a forward longitude/latitude to Web Mercator grid transform on the given location
  tlCorner = proj.transformCoords(new PVector(tlLng, tlLat));
  brCorner = proj.transformCoords(new PVector(brLng, brLat));
}

void drawData() {
  fill(43,57,226, 200);
  for ( PVector coord : coords) {
    PVector scrCoord = geoToScreen(coord);
    //println(scrCoord.x, scrCoord.y);
    ellipse(scrCoord.x, scrCoord.y, 6, 6);
  }
}

// Convert from WebMercator coordinates to screen coordinates.
PVector geoToScreen(PVector geo)
{
  return new PVector(map(geo.x, tlCorner.x, brCorner.x, 0, width), 
  map(geo.y, tlCorner.y, brCorner.y, 0, height));
}