// this class returns a direction according to a source image
class Guidance{
  private PImage source;
  private PImage sourceBlurred;
  private int innerRadius = 40; // in pixel
  private int outerRadius = 100; // in pixel
  private int bins = 32; // number of direction bins
  private int[][] kernel;
 boolean debug = false;
 boolean drawShape = true;
 float[][] derivativeX;
 float[][] derivativeY;
 float[][] gradientDirection;
 int scaleFactor = 16;
 int blurFactor = 1;
  
  private int currentShape = 0;
  private String[] shapes = {"formen/kreis.png","formen/quadrat.png","formen/dreieck.png"};
  
  public Guidance(String image){
    source = loadImage(image);
    source.resize(width,0); // scale proportionally
    sourceBlurred = source.copy();
    sourceBlurred.filter(BLUR, blurFactor);
    
    prepareKernel();
    calculateDerivatives();
    
    // debug print bin nrs
    ArrayList<Integer> nrs = new ArrayList<Integer>();
    for(int yk = 0; yk < kernel[0].length; yk++){
      for(int xk = 0; xk < kernel.length; xk++){
        int bin = kernel[xk][yk];
        if(!nrs.contains(bin)){
          //println(bin);
          nrs.add(bin);
        }
      }
    }
    
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
    
    //prepareKernel();
    //calculateDerivatives();
    draw();
  }
  
  public void showShape(){
    drawShape = !drawShape;
  }
  
  public Guidance(){
    this("formen/kreis.png");
  }
  
  public void draw(){
    if(drawShape){
      image(source,0,0);
      
      /*
      for(int x = 0; x < source.width; x += 25){
        for(int y = 0; y < source.height; y += 25){
          float dir = getGradientDirection(x,y);
          drawArrow(x,y+WallHeight,50, dir);
        }
      }
      */
    }
    
    //float degrees = getDominantDirection(mouseX,mouseY);
    //drawArrow(mouseX,mouseY, 50, degrees);
  }
  
  int sensorLength = 20;
  float maxSteeringAngle = PI/2;
  
  // down-to-earh method (angle in radians)
  public float getNewDirection(float x, float y, float angle){
    float rightWeight = 0;
    float leftWeight = 0;
    PVector right = new PVector(0,10).rotate(angle);
    //PVector right = new PVector(1,0).rotate(angle);
    
    float sX = x;
    float sY = y;
    
    for(int i = 0; i < sensorLength/2; i++){
      sX+=right.x;
      sY+=right.y;
      float weight = 1.0 - brightness(source.get((int)sX,(int)sY))/255f;
      if(sX < 0 || sX > width && sY < 0 || sX > WallHeight){
        weight = 0;
      }
      rightWeight += weight;
      if(drawShape){
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
      if(drawShape){
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
  
  // dominant direction in degrees (kernel method)
  public float getDominantDirection(float X, float Y, float weightAngle){
    int x = int(X);
    int y = int(Y);
    
    
    float[] binWeights = new float[bins];
    for(int yk = 0; yk < kernel[0].length; yk++){
      for(int xk = 0; xk < kernel.length; xk++){
        int bin = kernel[xk][yk];
        if(bin >= 0 && bin < bins){
          int binPosX = x+xk-outerRadius;
          int binPosY = y+yk-outerRadius;
          if(binPosX > 0 && binPosY > 0 && binPosX < source.width && binPosY < source.height){
            binWeights[bin] += 255.0 - brightness(source.get(binPosX,binPosY));
          }
          //println( brightness(source.get(x+xk-outerRadius,y+yk-outerRadius)));
          
          if(debug && (xk+yk)%5 == 0){
            strokeWeight(binWeights[bin]/10000);
            //stroke(255/bins * bin,bin%2==0?0:255,0);
            point(x+xk-outerRadius,y+yk-outerRadius);
          }
        }
        
      }
    }
    /*
    
    
    // amplify bins by weightAngle
    PVector v1 = new PVector(1,0), v2 = new PVector(1,0);
    v1.rotate(radians(weightAngle));
    
    for(int i = 0; i < binWeights.length; i++){
      float binAngle = 360f/bins * i  + (360/bins/2);
      v2.set(1,0);
      v2.rotate(radians(binAngle));
      float angularDifference = PVector.angleBetween(v1,v2);
      float weight = 2*PI / angularDifference;
      //binWeights[i] = binWeights[i]*weight;
      
      //drawArrow(x,y, binWeights[i]/1000, binAngle);
    }
    */
    
    int dominantBin = 0;
    float maxWeight = 0;
    for(int i = 0; i < binWeights.length; i++){
      if(binWeights[i] > maxWeight){
        maxWeight = binWeights[i];
        dominantBin = i;
      }
    }
    
    float binAngle = 360f/bins  + (360f/bins/2);
    
    if(debug){
      drawArrow(x,y, 50, binAngle);
    }
    
    
    return binAngle;
  }
  
  // (gradient method)
  public float getGradientDirection(float x, float y){
    int X = constrain(int(x/scaleFactor),0,gradientDirection.length-1);
    int Y = constrain(int(y/scaleFactor),0,gradientDirection[0].length-1);
    
    return gradientDirection[X][Y];
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
  
  private void calculateDerivatives(){
    int[][] sobelKernelX = {{1,0,-1},
                            {2,0,-2},
                            {1,0,-1}};
    int[][] sobelKernelY = {{1,2,1},
                            {0,0,0},
                            {-1,-2,-1}};
    
    PImage sourceScaled = source.copy();
    sourceScaled.resize(source.width/scaleFactor,0);
    //sourceScaled.filter(BLUR, 3);
    
    derivativeX = new float[sourceScaled.width][sourceScaled.height];
    derivativeY = new float[sourceScaled.width][sourceScaled.height];
    gradientDirection = new float[sourceScaled.width][sourceScaled.height];
    //derivativeX = new PImage(sourceScaled.width,sourceScaled.height);
    //derivativeY = new PImage(sourceScaled.width,sourceScaled.height);
    
    for(int x = 0; x < sourceScaled.width; x++){
      for(int y = 0; y < sourceScaled.height; y++){
        derivativeX[x][y] = convolution(x,y, sobelKernelX, 3, sourceScaled);
        derivativeY[x][y] = convolution(x,y, sobelKernelY, 3, sourceScaled);
        if(derivativeX[x][y] != 0){
          gradientDirection[x][y] = atan(derivativeY[x][y]/derivativeX[x][y]) + PI/2;
        }else{
          gradientDirection[x][y] = 0;
        }
        
      }
    }
    
    //derivativeX.resize(source.width,0);
    //derivativeY.resize(source.width,0);
  }
  
  private float convolution(int x, int y, int[][] matrix, int matrixsize, PImage img){
    
    int offset = matrixsize / 2;
    float total = 0;
    
    // loop through convolution matrix
    for (int i = 0; i < matrixsize; i++ ) {
      for (int j = 0; j < matrixsize; j++ ) {
        
        // what pixel is tested
        int xloc = x + i-offset;
        int yloc = y + j-offset;
        int loc = xloc + img.width*yloc;
        
        // check if still inside image
        loc = constrain(loc,0,img.pixels.length-1);
        
        // calculate the convolution
        // sum all the neighboring pixels multiplied by the values in the convolution matrix
        total += (brightness(img.pixels[loc]) * matrix[i][j]);
      }
    }
    
    return total;
  }
  
  // assign each pixel of the kernel a direction bin
  private void prepareKernel(){
      kernel = new int[outerRadius*2][outerRadius*2];
      
      PVector center = new PVector(outerRadius, outerRadius);
      
      for(int y = 0; y < kernel.length; y++){
        for(int x = 0; x < kernel[0].length; x++){
          PVector pixel = new PVector(x, y); 
          float d = PVector.dist(center, pixel);
          if(d >= innerRadius && d <= outerRadius){
            //PVector vec = PVector.sub(center,pixel);
            float angle = PVector.angleBetween(center,pixel);
            //println(angle);
            //float angle = atan2(vec.x, vec.y)*180/PI + 180;
            kernel[x][y] = (int)((angle/2*PI)*bins);
            if(kernel[x][y] == bins){kernel[x][y] = bins-1;}
          }
          else{
            kernel[x][y] = -1;
          }
        }
      }
  }
}