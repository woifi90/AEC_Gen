PImage source;
PImage gradient;
int innerRadius = 25; // in pixel
int outerRadius = 80; // in pixel
int bins = 16; // number of direction bins
int[][] kernel;
boolean debug = true;
PGraphics pgKernel;

void setup() {
  size(1024, 1024);
  source = loadImage("peace.jpg");
  image(source,0,0);
  
  prepareKernel();
  strokeWeight(1);
  for(int y = 0; y < kernel[0].length; y+= 1){
    for(int x = 0; x < kernel.length; x+= 1){
      if(kernel[x][y] != 0){
        stroke(kernel[x][y]*25,0,0);
        point(x, y);
      }
    }
  }
  
  
  /*
  for(int y = 0; y < source.height-kernelSize; y+= kernelSize){
    for(int x = 0; x < source.width-kernelSize; x+= kernelSize){
      float sum = 0;
      for(int xK = 0; xK < kernelSize; xK++){
        for(int yK = 0; yK < kernelSize; yK++){
          sum += brightness(source.get(x,y));
        }
      }
      float average = sum/(kernelSize*kernelSize);
      average = average/255;
      
      drawArrow(x,y,5,average*270+90);
    }
  }
  */
}

void draw(){
  background(255);
  image(source,0,0);
  if(debug){
    noFill();
    strokeWeight(1);
    ellipse(mouseX,mouseY,outerRadius*2,outerRadius*2);
    ellipse(mouseX,mouseY,innerRadius*2,innerRadius*2);
  }
  
  float degrees = getDominantDirection(mouseX,mouseY);
  drawArrow(mouseX,mouseY, 50, degrees);
}

void drawArrow(int cx, int cy, int len, float angle){
  pushMatrix();
  translate(cx, cy);
  rotate(radians(-angle+90));
  strokeWeight(2);
  stroke(255,0,0);
  line(0,0,len, 0);
  line(len, 0, len - 2, -2);
  line(len, 0, len - 2, 2);
  popMatrix();
}

// dominant direction in degrees
float getDominantDirection(int x, int y){
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
  
  int dominantBin = 0;
  float maxWeight = 0;
  for(int i = 0; i < binWeights.length; i++){
    if(binWeights[i] > maxWeight){
      maxWeight = binWeights[i];
      dominantBin = i;
    }
  }
  
  float binAngle = 360f/bins * dominantBin  + (360/bins/2);
  return binAngle;
}

void prepareKernel()
{
    kernel = new int[outerRadius*2][outerRadius*2];
    
    PVector center = new PVector(outerRadius, outerRadius);
    //int prevBin = -100;
    
    for(int y = 0; y < kernel.length; y++){
      for(int x = 0; x < kernel[0].length; x++){
        PVector pixel = new PVector(x, y); 
        float d = PVector.dist(center, pixel);
        if(d >= innerRadius && d <= outerRadius){
          PVector vec = PVector.sub(center,pixel);
          float angle = atan2(vec.x, vec.y)*180/PI + 180;
          kernel[x][y] = (int)((angle/360.0)*bins);
          if(kernel[x][y] == 16){kernel[x][y] = 15;}
          
          /*
          if(kernel[x][y] != prevBin){
            print(kernel[x][y] + " ");
            prevBin = kernel[x][y];
          }
          */
        }
        else{
          kernel[x][y] = -1;
        }
      }
    }
}