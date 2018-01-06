// this class returns a direction according to a source image
class Guidance{
  private PImage source;
  private PImage sourceBlurred;
  private PImage sourceInverted;
 boolean debug = false;
 boolean drawDebug = false;
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
    arrow = loadImage("pfeil.png");
  }
  
  public Guidance(){
    this("formen/kreis.png");
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
  
  public void randomShape(){
    currentShape = (int)random(0,shapes.length);
    source = loadImage(shapes[currentShape]);
    source.resize(width,0);
    sourceBlurred = source.copy();
    sourceBlurred.filter(BLUR, blurFactor);
  }
  
  public void toggleGuidanceDebug(){
    drawDebug = !drawDebug;

  }
  
  public void setShapeDraw(boolean drawing){
    showShape = drawing;
    sourceInverted = source.copy();
    sourceInverted.filter(INVERT);
  }
  
  public void draw(){
    if(drawDebug){
      image(source,0,0);
    }
    
    if(showShape){
      blendMode(ADD);
      image(sourceInverted,0,WallHeight);
      blendMode(NORMAL);
    }
  }
  
  private int minimalSensorLength = 5;
  private int sampleDistance = 10;
  private float weightOfIncreasingDistance = 0.1;
  private float weightOfHeight = 0.1;
  private float maxSteeringAngle = PI/2;
  private int actualSensorLength;
  PImage arrow;
  
    public void drawGuidance(Player p){
      PVector pos = p.getPosition().copy();
      pos.y -= WallHeight;
      
      float angle;
      
      if(p instanceof PharusPlayer){
        PharusPlayer pharus = (PharusPlayer) p;
        angle = pharus.velocity.heading(); 
      }else{
        KeyboardPlayer kp = (KeyboardPlayer) p;
        angle = kp.angle;
      }
      
      PVector v1 = new PVector(1,0);
      PVector v2 = v1.copy();
      v1.rotate(angle);
      v2.rotate(p.smoothedAngle);
      v2.lerp(v1, p.smoothingFactor);
      p.smoothedAngle = v2.heading();
      
      v1.set(1,0);
      v2.set(1,0);
      v1.rotate(guide.getDirection(pos.x,pos.y, p.smoothedAngle));
      v2.rotate(p.smoothedArrowDirection);
      v2.lerp(v1, p.smoothingFactor);
      p.smoothedArrowDirection = v2.heading();
      
      //p.smoothedArrowDirection = guide.getDirection(pos.x,pos.y, p.smoothedAngle ); // + p.smoothedArrowDirection * (1 - p.smoothingFactor);
      
      float dir = p.smoothedArrowDirection;
      //drawArrow(pos.x,pos.y, 10, dir);
      
      pushMatrix();
      translate(pos.x,pos.y + WallHeight);
      rotate(dir + PI/2);
      scale((1.0/AEC_Main.shrink) * 2.0);
      translate(-arrow.width/2,-arrow.height/2);
      tint(p.getColor());
      image(arrow,0,0);
      noTint();
      popMatrix();
  }
  
  // down-to-earh method (angle in radians)
  private float getDirection(float x, float y, float angle){
    PVector right = new PVector(0,sampleDistance).rotate(angle);
    
    
    
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
        
        float heightWeight = heightfield.get(int(samplePos[n].x/size),int(samplePos[n].y/size))/255; // 0 is max height
        totalWeight[n] += sampleWeight[n];// * (i+1) * (1-weightOfIncreasingDistance);
        
        if(drawDebug){
          stroke(255,0,0);
          strokeWeight(sampleWeight[n]*3 + 1);
          point(samplePos[n].x,samplePos[n].y);
          point(samplePos[n].x,samplePos[n].y+WallHeight);
        }
      }
      
      if(i > minimalSensorLength && totalWeight[0] + totalWeight[1] > 3){
        break;
      }
    }
    
    // normalize total weights
    totalWeight[0] /=  actualSensorLength;
    totalWeight[1] /=  actualSensorLength;
    
    float diff = totalWeight[1] - totalWeight[0];
    
    /*
    if(diff == 0){
      if(x > width/2){
        diff = 0.1;
      }else{
        diff = -0.1;
      }
    }
    */
    
    return angle+diff*maxSteeringAngle;
  }

  public void drawArrow(float cx, float cy, float len, float angle){
    pushMatrix();
    translate(cx, cy);
    rotate(angle+PI/2);
    strokeWeight(2);
    stroke(150,0,0);
    line(0,0,len, 0);
    line(len, 0, len - 2, -2);
    line(len, 0, len - 2, 2);
    popMatrix();
  }

}