class ColorGen{
  
  int ColorMode;
  color col;
  color finalCol;
  ColorGen(){}
  
  void setup(){
    colorMode(HSB);
  }
  void draw(){}
   
  public void setColorMode(int x){  
    ColorMode = x;  
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
        return color(random(170),random(100,240),random(50,240));
      }
      else{
        return color(random(310),random(100,240),random(50,240));
      }
      case 2: 
      println("Two");
      if(random(0,1) == 1){
        return color(random(50),random(100,240),random(50,240));
      }
      else{
        return color(random(260),random(100,240),random(50,240));
      }
      case 3: 
      println("Three");
      if(random(0,1) == 2){
        return color(random(100),random(100,240),random(50,240));
      }
      else{
        return color(random(360),random(100,240),random(50,240));
      }
    }

    return temp;
  }
  

}