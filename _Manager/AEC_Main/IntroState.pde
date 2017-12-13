class IntroState extends State {
  
  //background-color
  int r = 237;
  int g = 201;
  int b = 175;
  
  int x = 0; int y = 0; int z = 0;
  color fillcolour = color(x, y, z);
  float colourincrement = 1;
  PImage img = loadImage("logo.png");    
  PImage img2 = loadImage("sand_texture.jpg");
  float transparency = 0;
  float transparency2 = 0;
  
  boolean start = false;
  boolean end = false;
  boolean play = true;
 
  
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
    
    background(fillcolour);
    
    backgroundImage();
    imageMode(CENTER);
    
    if(start){
      if(play){
        sound = player.loadFile("gong.mp3");
        sound.play();
        play=false;
    }
      if (transparency < 255 && end == false){transparency += 1;}
      
      if(transparency == 255) {end = true; }
      
      tint(0, transparency);
      image(img,width/2,width/3);
      img.resize(0, 70);
      
      if(transparency > 0 && end) {transparency -= 1;}
      
      if(transparency == 0 && end){stateMgr.setState(STATEA);}
      
    }
    
  }  
  
  void backgroundImage(){
    
    imageMode(NORMAL);
    
    if (transparency2 < 150) { 
        transparency2 += 0.5; 
        //println(transparency2);
      }
      
    tint(255, transparency2);
    image(img2, 0, 0);
    img2.resize(width,height);   
  
  }
  
}