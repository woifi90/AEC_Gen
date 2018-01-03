// this class returns a direction according to a source image
class Guidance{
  private PImage source;
  private PImage sourceBlurred;
 boolean debug = false;
 boolean drawDebug = true;
 int scaleFactor = 16;
 int blurFactor = 1;
 boolean showShape = false;

 // todo: nach entfernung weighten
 // fallback richtung wenn  nichts gefundne wird ( oder pfeil ausfaden )

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
  
  private int minimalSensorLength = 5;
  private int sampleDistance = 10;
  private float weightOfIncreasingDistance = 1;
  private float weightOfHeight = 1;
  private float maxSteeringAngle = PI/2;
  private int actualSensorLength;
  
  // down-to-earh method (angle in radians)
  public float getDirection(float x, float y, float angle){

    PVector right = new PVector(0,sampleDistance).rotate(angle);
    
    heightfield.get(int(x/size),int(y/size));
    
    // determine width of sensor
    PVector[] samplePos = new PVector[2]; // left and right sample pos, 0 being left, 1 being right
    
    samplePos[0] = new PVector(x,y);
    samplePos[1] = new PVector(x,y);
    
    float[] totalWeight = new float[2]; // total weight right and left
    
    for(int i = 0; i < width / sampleDistance; i++){
      actualSensorLength = i;
      
      samplePos[0].x -= right.x;
      samplePos[0].y -= right.y;
      samplePos[1].x += right.x;
      samplePos[1].y += right.y;
      
      // get weight of current sampling point, 0 being white and 1 being black
      float[] sampleWeight = new float[2]; // normalized sample weight, 0 being white and 1 being black
      
      // sample left and right
      for(int n = 0; n < 2; n++){
        sampleWeight[n] = 1.0 - brightness(sourceBlurred.get((int)samplePos[n].x,(int)samplePos[n].y))/255f;
        if(samplePos[n].x < 0 || samplePos[n].x > width || samplePos[n].y < 0 || samplePos[n].y > source.height){
          sampleWeight[n] = 0;
        }
        totalWeight[n] += sampleWeight[n];
        
        if(drawDebug){
          stroke(255,0,0);
          strokeWeight(sampleWeight[n]*3 + 1);
          point(samplePos[n].x,samplePos[n].y);
          point(samplePos[n].x,samplePos[n].y+WallHeight);
        }
      }
      
      if(i > minimalSensorLength && totalWeight[0] + totalWeight[1] > 0.1){
        break;
      }
    }
    
    // normalize total weights
    totalWeight[0] /=  actualSensorLength;
    totalWeight[1] /=  actualSensorLength;
    
    float diff = totalWeight[1] - totalWeight[0];
    
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