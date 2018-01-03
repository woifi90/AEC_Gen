// this class returns a direction according to a source image
class Guidance{
  private PImage source;
  private PImage sourceBlurred;
 boolean debug = false;
 boolean drawDebug = true;
 int scaleFactor = 16;
 int blurFactor = 1;
 boolean showShape = false;
 
 private float weightOfIncreasingDistance = 1;
 private float weightOfHeight = 1;
 private float size;
  
  private int currentShape = 0;
  private String[] shapes = {"formen/kreis.png","formen/quadrat.png","formen/dreieck.png"};
  
  public Guidance(String image){
    source = loadImage(image);
    source.resize(width,0); // scale proportionally
    sourceBlurred = source.copy();
    sourceBlurred.filter(BLUR, blurFactor);
    size = 30/shrink;
  }
  
  public void changeShape(){
    currentShape++;
    if(currentShape >= shapes.length){
      currentShape = 0;
    }
    source = loadImage(shapes[currentShape]);
    source.resize(width,0);
    sourceBlurred = source.copy();
    sourceBlurred.filter(BLUR, blurFactor);
    
    draw();
  }
  
  public void toggleGuidanceDebug(){
    drawDebug = !drawDebug;
  }
  
  public Guidance(){
    this("formen/kreis.png");
  }
  
  public void fadeinShape(){
    showShape = true;
  }
  
  public void draw(){
    if(drawDebug){
      image(source,0,0);
    }
    
    if(showShape){
      image(source,0,0);
    }
  }
  
  int sensorLength = 20;
  float maxSteeringAngle = PI/2;
  
  // down-to-earh method (angle in radians)
  public float getNewDirection(float x, float y, float angle){
    float rightWeight = 0;
    float leftWeight = 0;
    PVector right = new PVector(0,10).rotate(angle);
    
    float sX = x;
    float sY = y;
    
    heightfield.get(int(x/size),int(y/size));
    
    // determine width of sensor
    for(int i = 0; i < width/2; i++){
      
    }
    
    for(int i = 0; i < sensorLength/2; i++){
      sX+=right.x;
      sY+=right.y;
      
      // get weight of current sampling point, 0 being white and 1 being black
      float weight = 1.0 - brightness(source.get((int)sX,(int)sY))/255f;
      // set weight 0 if outside of canvas
      if(sX < 0 || sX > width && sY < 0 || sX > WallHeight){
        weight = 0;
      }
      rightWeight += weight;
      if(drawDebug){
        stroke(255,0,0);
        strokeWeight(weight*3 + 1);
        point(sX,sY);
        point(sX,sY+WallHeight);
      }
    }
    rightWeight /= sensorLength/2;
    
    sX = x;
    sY = y;
    for(int i = 0; i < sensorLength/2; i++){
      sX-=right.x;
      sY-=right.y;
      float weight = 1.0 - brightness(source.get((int)sX,(int)sY))/255f;
      if(sX < 0 || sX > width && sY < 0 || sX > WallHeight){
        weight = 0;
      }
      leftWeight += weight;
      if(drawDebug){
        stroke(255,0,0);
        point(sX,sY);
        point(sX,sY+WallHeight);
      }
    }
    leftWeight /= sensorLength/2;
    
    float diff = rightWeight - leftWeight;
    
    if(diff == 0){
      if(x > width/2){
        diff = 0.1;
      }else{
        diff = -0.1;
      }
    }
    
    return angle+diff*maxSteeringAngle;
  }

  public void drawArrow(float cx, float cy, float len, float angle){
    pushMatrix();
    translate(cx, cy);
    rotate(angle);
    strokeWeight(2);
    stroke(150,0,0);
    line(0,0,len, 0);
    line(len, 0, len - 2, -2);
    line(len, 0, len - 2, 2);
    popMatrix();
  }

}