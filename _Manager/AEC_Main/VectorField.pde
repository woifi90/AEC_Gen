PGraphics heightfield;
final int heightfieldDefaultValue = 255;

// creates a vectorfield with a field size given in SIZE
// the direction of each is dependant of the slope specified in heightfield 
class VectorField{

  // size of a vector square in pixels
  private final int SIZE = 15;
  
  // scale each vector by this factor
  private final int VSCALE = 4;
  
  private int fieldCountX = (int)(WindowWidth/SIZE +1);
  private int fieldCountY = (int)(FloorHeight/SIZE +1);
  
  private PVector[][] vectors = new PVector[fieldCountX][fieldCountY];
  
  private int[][] heights = new int[fieldCountX][fieldCountY];
  
  
  
  public VectorField(){
      heightfield = createGraphics(WindowWidth, FloorHeight);
      
      // draw a perlin noise as base. May be obsolete
      
      heightfield.beginDraw();
      heightfield.background(heightfieldDefaultValue);
        /*
        heightfield.noStroke();
        heightfield.background(heightfieldDefaultValue);
        
        noiseDetail(8,0.6);
        // draw noise
        for(int x = 0; x<width; x++){
          for(int y = 0; y<height; y++){
            int n = (int)(noise(x*0.005,y*0.005)*255);
            heightfield.set(x,y,color(n));
          }
        }
        */
      heightfield.endDraw();
      
  }
  
  
  // drawing is for debug only and slows down rendering significantly
  void draw(boolean drawHeights, boolean drawVectors){
    // draw a field of rectangles representing the average value
    if (drawHeights){
      for (int x = 0; x<fieldCountX; x++){
        for (int y = 0; y<fieldCountY; y++){
          fill(this.heights[x][y]); //<>//
          rect(x*SIZE, y*SIZE, SIZE, SIZE);
        }
      }
    }
    // draw the vectors representing the direction and strength
    if(drawVectors){
      for (int x = 0; x<fieldCountX; x++){
        for (int y = 0; y<fieldCountY; y++){
          float centerX = x * SIZE + SIZE/2;
          float centerY = y * SIZE + SIZE /2;
          line(centerX, centerY, centerX+vectors[x][y].x, centerY+vectors[x][y].y);
        }
      }
    }
  }
  
  
  public void update(){
    // get the average value of the heighfield for each vectorfield
    for (int x = 0; x<fieldCountX; x++){
      for (int y = 0; y<fieldCountY; y++){
        heights[x][y] = getAverageValue(x,y);
      }
    }
    // set the vector to the direction of the lowest neighbouring value
    for (int x = 0; x<fieldCountX; x++){
      for (int y = 0; y<fieldCountY; y++){
        vectors[x][y] = findDownVector(x, y);
      }
    }
  }
  
  
  
  // calculates the average value from heightfield 
  // for the area of a vectorfield
  private int getAverageValue(int x, int y){
    int sum = 0;
    // samples only part the pixels for better performance
    int step = 4;
    int pixelCounter = 0;
    
    for(int a = 0;a<SIZE;a+= step){
      for(int b =0;b<SIZE;b+= step){
        // check for out of bounds, else just use the default
        if(a+x*SIZE < WindowWidth && b+y*SIZE < FloorHeight){
           int value = (int)red(heightfield.get(a+x*SIZE,b+y*SIZE));
           sum += value;
         }
         else {
           sum += heightfieldDefaultValue;
         }
         pixelCounter++;
        
      }
    }
    
    return sum / pixelCounter;
  }
  
  
  
  // check the neighbouring fields of the heights array 
  // combine all delta values to get a final vector 
  private PVector findDownVector(int x, int y){
    PVector downVec = new PVector();
    
    int dx = 0;
    int dy = 0;
    
    //check top
    if (y > 0){
      dy += heights[x][y-1] - heights[x][y];
    }
    //check bottom
    if (y < fieldCountY-1){
      dy += heights[x][y] - heights[x][y+1];
    }
    //check right
    if(x < fieldCountX-1){
      dx += heights[x][y] - heights[x+1][y];
    }
    //check left
    if(x > 0){
      dx += heights[x-1][y] - heights[x][y];
    }
    downVec.set(dx, dy);
    
    return downVec;
  }
  
  
  
  // heightfield fading
  // better version than just overlaying a rect with alpha, 
  // because it leaves no traces
  private void fadeHeightfield(){
    heightfield.loadPixels();
      for (int i = 0; i < width * height; i++){
        float hfVal = red(heightfield.pixels[i]);
        float delta = hfVal- heightfieldDefaultValue;
        if (delta != 0){
          float sign = delta / abs(delta);
          int newVal = (int)(hfVal - sign* ceil(abs(delta)/8));
          heightfield.pixels[i] =  color(newVal);
        }
      }
    heightfield.updatePixels();
  }
  
  
  
  // returns the vector for the given position multiplied by VSCALE
  // no searching because I can calculate the right vectorfield based on position
  public PVector getAcc(PVector pos){

    int x = (int)(pos.x/SIZE);
    int y = (int)(pos.y/SIZE);
    if (x<fieldCountX && y < fieldCountY && x>=0 && y>=0){
      return PVector.mult(vectors[x][y],VSCALE);
    }
    return new PVector();
  }
  
  public int getColorValue(PVector pos){
    int x = (int)(pos.x/SIZE);
    int y = (int)(pos.y/SIZE);
    if (x<fieldCountX && y < fieldCountY && x>=0 && y>=0){
      return heights[x][y];
    }
    return 255;
  }
  
  
}