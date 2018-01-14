class StateIntro extends State {
  
  PImage frameIntro;
  PImage paintSplatter;

  float topMaskAlpha = 255;
  float botMaskAlpha = 255;
  
  // fade in after amount of ms
  int topFadeStart = 1000;
  int botFadeStart = 6000;
  
  boolean start;
  
  // after 15 seconds, switch to draw
  private final int INTRODURATION = 15 * 1000;
  
  
  
  StateIntro() {
    super();
  }
  
  StateIntro(StateMgr _stateMgr) {
    super(_stateMgr); 
  }
  
  
  
  void setup() {
    
    start=true;

    frameIntro = loadImage("frame.png");
    frameIntro.resize(width,WallHeight);
    
    paintSplatter = loadImage("inksplatter.png");
    paintSplatter.resize(width,WallHeight);
    
    stateImgBuffer = createGraphics(width, height);
    stateImgBuffer.beginDraw();
    stateImgBuffer.background(230);
    stateImgBuffer.image(paintSplatter, 0,0);
    stateImgBuffer.imageMode(CENTER);
    stateImgBuffer.image(logo, width/2, WallHeight/2);
    stateImgBuffer.imageMode(CORNER);
    stateImgBuffer.image(frameIntro,0,0);
    stateImgBuffer.image(paperTexture,0,WallHeight);
    stateImgBuffer.endDraw();
  }
  
  
  void draw() {
    
    image(stateImgBuffer,0,0);
    
    if(start){
      start= false;
      sm.playAmbience();
    }
    
    // top mask
    fill(20,topMaskAlpha);
    rect(0,0,width, WallHeight);
    if(millis()>topFadeStart) topMaskAlpha = max(0,topMaskAlpha-50*dt);
    
    // bottom mask
    fill(20, botMaskAlpha);
    rect(0,WallHeight, width, height);
    if(millis()>botFadeStart) botMaskAlpha = max(0,botMaskAlpha-50*dt);
    
    
    super.draw();
    
  }  
 
 
  // switch to draw after this amount of time
  int getNextStateID(){
    if (stateMgr.getTimeInState() > INTRODURATION)
    {
      return STATE_DRAW; 
    }
    
    return super.getNextStateID();
  }
  
}