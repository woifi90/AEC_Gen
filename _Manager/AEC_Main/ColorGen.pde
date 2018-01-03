class ColorGen{
  
  int ColorMode = 1;
  color col;
  color finalCol;
  ColorGen(){}
  
  void setup(){
    colorMode(HSB,255);
  }
  void draw(){}
   
  public void setColorMode(int x){  
    if(x == 0){
      ColorMode=1;}
    else{
        ColorMode = x;  }
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
        return color(random(100,200),200,255);
      case 2: 
      println("Two");
        return color(random(150,255),200,255);
      
      case 3: 
      println("Three");
        return color(random(0,150),200,255);
    }
    return temp;
  }
  

}