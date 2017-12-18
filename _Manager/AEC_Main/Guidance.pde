// this class returns a direction according to a source image
class Guidance{
  private PImage source;
  private PImage gradient;
  private int innerRadius = 25; // in pixel
  private int outerRadius = 80; // in pixel
  private int bins = 16; // number of direction bins
  private int[][] kernel;
  boolean debug = false;
  private PGraphics pgKernel;
  
  public Guidance(String image){
    source = loadImage(image);
    
    prepareKernel();
  }
  
  public Guidance(){
    this("formen/kreis.png");
  }
  
  public void draw(){
    image(source,0,0);
    //float degrees = getDominantDirection(mouseX,mouseY);
    //drawArrow(mouseX,mouseY, 50, degrees);
  }
  
  // dominant direction in degrees
  public float getDominantDirection(float X, float Y, float weightAngle){
    int x = int(X);
    int y = int(Y);
    
    float[] binWeights = new float[bins];
    for(int yk = 0; yk < kernel[0].length; yk++){
      for(int xk = 0; xk < kernel.length; xk++){
        int bin = kernel[xk][yk];
        if(bin != -1){
          //print(bin + " ");
          binWeights[bin] += 255.0 - brightness(source.get(x+xk-outerRadius,y+yk-outerRadius));
          //println( brightness(source.get(x+xk-outerRadius,y+yk-outerRadius)));
          
          if(debug && (xk+yk)%5 == 0){
            strokeWeight(1);
            stroke(255/bins * bin,bin%2==0?0:255,0);
            point(x+xk-outerRadius,y+yk-outerRadius);
          }
        }
        
      }
    }
    
    PVector v1 = new PVector(0,-1), v2 = new PVector(0,-1);
    v1.rotate(radians(weightAngle));
    
    for(int i = 0; i < binWeights.length; i++){
      float binAngle = 360f/bins * i  + (360/bins/2);
      v2.set(0,-1);
      v2.rotate(radians(binAngle));
      float angularDifference = PVector.angleBetween(v1,v2);
      float weight = 2*PI / angularDifference;
      binWeights[i] = binWeights[i]*weight;
    }
    
    
    
    int dominantBin = 0;
    float maxWeight = 0;
    for(int i = 0; i < binWeights.length; i++){
      if(binWeights[i] > maxWeight){
        maxWeight = binWeights[i];
        dominantBin = i;
      }
    }
    
    float binAngle = 360f/bins * dominantBin  + (360/bins/2);
    
    if(debug){
      drawArrow(x,y, 50, binAngle);
    }
    
    return binAngle;
  }
  
  public void drawArrow(int cx, int cy, int len, float angle){
    pushMatrix();
    translate(cx, cy);
    rotate(radians(-angle+90));
    strokeWeight(2);
    stroke(150,0,0);
    line(0,0,len, 0);
    line(len, 0, len - 2, -2);
    line(len, 0, len - 2, 2);
    popMatrix();
  }
  
  private void prepareKernel(){
      kernel = new int[outerRadius*2][outerRadius*2];
      
      PVector center = new PVector(outerRadius, outerRadius);
      
      for(int y = 0; y < kernel.length; y++){
        for(int x = 0; x < kernel[0].length; x++){
          PVector pixel = new PVector(x, y); 
          float d = PVector.dist(center, pixel);
          if(d >= innerRadius && d <= outerRadius){
            PVector vec = PVector.sub(center,pixel);
            float angle = atan2(vec.x, vec.y)*180/PI + 180;
            kernel[x][y] = (int)((angle/360.0)*bins);
            if(kernel[x][y] == 16){kernel[x][y] = 15;}
          }
          else{
            kernel[x][y] = -1;
          }
        }
      }
  }
}