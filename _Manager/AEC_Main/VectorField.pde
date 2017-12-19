PGraphics heightfield;
final int heightfieldDefaultValue = 255;

// creates a vectorfield with a field size given in SIZE
// the direction of each is dependant of the slope specified in heightfield 
class VectorField{
  
  // DEBUG
  public boolean drawHeightfield = false;
  public boolean drawVectors = false;

  // size of a vector square in pixels
  private final int SIZE = 15;
  
  // scale each vector by this factor
  private final float VSCALE = 1;
  
  private int fieldCountX = (int)(WindowWidth/SIZE +1);
  private int fieldCountY = (int)(FloorHeight/SIZE +1);
  
  private PVector[][] vectors = new PVector[fieldCountX][fieldCountY];
  
  private int blurTimestamp = 0;
  private final int BLUR_FREQ = 10000;
  
  
  public VectorField(){
      heightfield = createGraphics(fieldCountX, fieldCountY);
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
      heightfield.blendMode(MULTIPLY);
  }
  
  
  // drawing is for debug only and slows down rendering significantly
  void draw(){
    //draw heightfield
    if(drawHeightfield){
      image(heightfield,0,0, WindowWidth, FloorHeight);
    } //<>//
    // draw the vectors representing the direction and strength
    if(drawVectors){
      stroke(0);
      for (int x = 0; x<fieldCountX; x++){
        for (int y = 0; y<fieldCountY; y++){
          float centerX = x * SIZE + SIZE/2;
          float centerY = y * SIZE + SIZE /2;
          PVector dir = vectors[x][y].limit(SIZE); 
          line(centerX, centerY, 
            centerX + dir.x, 
            centerY + dir.y);
        }
      }
    }
  }
  
  
  public void update(){
    heightfield.loadPixels();
    // blur heightfield every 2 seconds
    if(millis() - blurTimestamp > BLUR_FREQ){
      //TODO write own blur that is not that strong
      int[] heightfieldBuffer = heightfield.pixels.clone();
      for(int i=0; i<heightfieldBuffer.length; i++){
        heightfield.pixels[i] = blur(i, heightfieldBuffer);
      }
      blurTimestamp = millis();
    }
    
    // set the vector to the direction of the lowest neighbouring value
    for (int x = 0; x<fieldCountX; x++){
      for (int y = 0; y<fieldCountY; y++){
        vectors[x][y] = findDownVector(x, y);
      }
    }
  }
  
  private void blur(int[] heightfieldBuffer){
    for(int i=0;i<heightfieldBuffer.length;i++){
      if(i>0) ;
      
      if(i<heightfieldBuffer.length) ;
    }
  }
  
  // check the neighbouring fields of the heights array 
  // combine all delta values to get a final vector 
  private PVector findDownVector(int x, int y){
    PVector downVec = new PVector();
    
    int dx = 0;
    int dy = 0;
    int w = heightfield.width;
    int center = (int)red(heightfield.pixels[x + y * w]);
    
    // check top left
    if(y > 0 && x > 0){
      dx -= center - (int)red(heightfield.pixels[x-1 + (y-1)*w]);
      dy -= center - (int)red(heightfield.pixels[x-1 + (y-1)*w]);
    }
    // check top
    if (y > 0){
      dy -= center - (int)red(heightfield.pixels[x + (y-1)*w]);
    }
    // check top right
    if(y > 0 && x < fieldCountX -1){
      dx += center - (int)red(heightfield.pixels[x+1 + (y-1)*w]);
      dy -= center - (int)red(heightfield.pixels[x+1 + (y-1)*w]);
    }
    // check left
    if(x > 0){
      dx -= center - (int)red(heightfield.pixels[x-1 + y*w]);
    }
    // check right
    if(x < fieldCountX-1){
      dx += center - (int)red(heightfield.pixels[x+1 + y*w]);
    }
    // check bottom left
    if(x >0 && y < fieldCountY -1){
      dx -= center - (int)red(heightfield.pixels[x-1 + (y+1)*w]);
      dy += center - (int)red(heightfield.pixels[x-1 + (y+1)*w]);
    }
    // check bottom
    if(y < fieldCountY-1){
      dy += center - (int)red(heightfield.pixels[x + (y+1)*w]);
    }
    // check bottom right
    if(x < fieldCountX -1 && y < fieldCountY -1){
      dx += center - (int)red(heightfield.pixels[x+1 + (y+1)*w]);
      dy += center - (int)red(heightfield.pixels[x+1 + (y+1)*w]);
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
  
  public int getHeight(PVector pos){
    int x = (int)pos.x/SIZE;
    int y = (int)pos.y/SIZE;
    if (x<fieldCountX && y < fieldCountY && x>=0 && y>=0){
      return (int)red(heightfield.pixels[x + y * heightfield.width]);
    }
    return 255;
  }
  
  public void reset(){
    heightfield.beginDraw();
    heightfield.background(heightfieldDefaultValue);
    heightfield.endDraw();
  }
  
  public void displace(Object[] players){
    heightfield.beginDraw();
    heightfield.noStroke();
    for(Object op : players){
      Player p = (Player)op;
      PVector pos = p.getPosition();
      heightfield.fill(p.getDisplacement());
      heightfield.ellipse(pos.x/SIZE,(pos.y-WallHeight)/SIZE,1,1);
    }
    heightfield.endDraw();
  }
  
  
}