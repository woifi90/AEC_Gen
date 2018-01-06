class ColorGen{
  
  int ColorMode = 1;
  
  public void setColorMode(int x){  
    if(x == 0){
      ColorMode=1;}
    else{
        ColorMode = x;  }
        
    println("Colormode " + ColorMode);
  }
  
  
  color getColor(){
    return generateColor();
  }
  
  
  private color generateColor(){
    switch(ColorMode) {
      
      case 1:
      // complementary
        // 150, 130, 150 highlight
        // 31, 130, 240 base colors
        // 12, 130, 240
        if(random(100)<20){
          return color(random(140, 160), random(125, 135), random(140, 160));
        }else{
          return color(random(0, 40), random(125, 135), random(200, 240));  
        }
        
      case 2:
      // color triade
        // 25, 110, 211 highlight
        // 194, 165-224, 124-200
        // 102, 86-209, 125-150
        if(random(100)<20){
          return color(random(20,30), random(100,120), random(200,220));
        }else{
          if(random(100)>50) return color(random(190,200), random(165,225), random(125,200));
          
          return color(random(100,110), random(90,200), random(125,150));
        }
        
      case 3:
      // compound
        // 106-118, 94-140, 210-220
        // 17-28, 56-183, 100-250
        if(random(100)<30){
          return color(random(90,110), random(130,180), random(150,200));
        }else{
          return color(random(0,15), random(150,210), random(150,250));
        }
    }
    
    return color(0,0,0);
  }
  

}