class IntroState extends State {
  
  //background-color
  int r = 237;
  int g = 201;
  int b = 175;
  
  int x; int y; int z;
  color fillcolour;
  float colourincrement = 1;
  PImage img = loadImage("logo.png");
  PImage img2 = loadImage("sand_texture.jpg");
  float transparency;
  float transparency2;
  
  boolean start;
  boolean end;
  boolean play;
 
  
  IntroState() {
    super();
  }
  
  IntroState(StateMgr _stateMgr) {
    super(_stateMgr); 
  }
  
  void setup() {
    
    //clearBackground(); 
    transparency = 0;
    transparency2 = 0;
    
    x= 0;
    y = 0;
    z = 0;
    
    fillcolour = color(x, y, z);
    
    start = false;
    end = false;
    play = true;
    
  }
  
  
  void draw() {
    colorMode(RGB);
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
        sound = audioplayer.loadFile("gong.wav");
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
    super.draw();
    
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
  
  void clearBackground() {
     background(1);
  }
  
}