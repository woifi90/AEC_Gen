class IntroState extends State {
  
  //background-color
  int r = 237;
  int g = 201;
  int b = 175;
  
  int x = 0; int y = 0; int z = 0;
  color fillcolour = color(x, y, z);
  float colourincrement = 1;
  PImage img = loadImage("logo.png");
  float transparency = 0;
  
  boolean start = false;
  boolean end = false;
  
  IntroState() {
    super();
  }
  
  IntroState(StateMgr _stateMgr) {
    super(_stateMgr); 
  }
  
  
  void draw() {
    colorMode(RGB, 255);
    fillcolour = color(x, y, z);
    background(1);
    fill(fillcolour);
    if (x < r){ 
      x += colourincrement;
    }
    if (y < g){ 
      y += colourincrement;
    }
    if (z < b){ 
      z += colourincrement;
    }
    
    if(x == r){
      start = true;
    }
    
    imageMode(CENTER);
    background(fillcolour);
    
    if(start){
      if (transparency < 255 && end == false) { 
        transparency += 1;  
      }
      
      if(transparency == 255) {end = true; }
      
      tint(0, transparency);
      image(img,width/2,width/3);
      img.resize(0, 70);
      
      if(transparency > 0 && end) {transparency -= 1;}
      
    }
    
  }  
  
}