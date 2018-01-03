class ColorGen{
  
  int ColorMode = 1;
  color col;
  color finalCol;
  ColorGen(){}
  
  void setup(){
    colorMode(HSB,100);
  }
  void draw(){}
   
  public void setColorMode(int x){  
    if(x == 0)ColorMode=1;
    else ColorMode = x;  
    println(ColorMode);
  }
  
  color getColor(){
    
    color finalCol = generateColor();
    
    return finalCol;
  }
  
  private color generateColor(){
    color temp = color(0,0,0);
    
    switch(ColorMode) {
      case 1: 
      println("One");
      if(random(0,1) == 0){
        return color(random(0,255),200,255);
      }
      else{
        return color(random(0,255),200,255);
      }
      case 2: 
      println("Two");
      if(random(0,1) == 1){
        return color(random(0,200),200,255);
      }
      else{
        return color(random(0,155),200,255);
      }
      case 3: 
      println("Three");
      if(random(0,1) == 2){
        return color(random(100,255),200,255);
      }
      else{
        return color(random(50,200),200,255);
      }
    }
    return temp;
  }
  

}