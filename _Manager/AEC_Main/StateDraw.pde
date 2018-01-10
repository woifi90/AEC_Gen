class StateDraw extends State {
  
  int stateStart = 0;
  // minutes + seconds
  int stateDuration = 3 *60*1000 + 0 *1000;
  
  PImage frameDraw;
  
  StateDraw() {
    super();
  }
  
  StateDraw(StateMgr _stateMgr) {
    super(_stateMgr); 
  }
  
  void setup(){
    ps.reset();
    
    gen.setColorMode((int)random(0,4));
    updatePlayerColors();
    
    guide.randomShape();
    guide.setShapeDraw(false);
    
    //kps.add(new KeyboardPlayer("wasd"));
    //kps.add(new KeyboardPlayer("ijkl"));
    //kps.add(new KeyboardPlayer(UP,LEFT,DOWN,RIGHT));
    
    frameDraw = loadImage("frame_draw.png");
    frameDraw.resize(width, WallHeight);
    
    stateImgBuffer = createGraphics(width, height);
    
    stateImgBuffer.beginDraw();
    stateImgBuffer.colorMode(HSB, 255);
    stateImgBuffer.background(10,10,125);
    stateImgBuffer.image(paperTexture,0,WallHeight);
    stateImgBuffer.image(frameDraw,0,0);
    stateImgBuffer.imageMode(CENTER);
    stateImgBuffer.image(paperTexture, width/2,WallHeight/2, width/2.2, WallHeight/2.2);
    stateImgBuffer.imageMode(CORNER);
    stateImgBuffer.endDraw();
    
    stateStart = millis();
  }
  
  void cleanup(){
    super.cleanup();
    background(240);
    kps.clear();
    vf.reset();
  }
  
  void draw() {
    image(stateImgBuffer,0,0);
    
    guide.draw();
   
    for(HashMap.Entry<Long, PharusPlayer> playersEntry : pc.players.entrySet()){
      PharusPlayer p = playersEntry.getValue();
      p.spawnParticles();  
    }
    vf.displace(pc.players.values().toArray());
    
    for(KeyboardPlayer p: kps){
      p.spawnParticles();        
    }
    vf.displace(kps.toArray());
    
    vf.update();
    ps.update();
    vf.draw();
    ps.draw();
    
    if(ps.doDraw){
      //imageMode(CENTER);
      //image(particleCanvas,width/2,WallHeight/2, width/2.2, WallHeight/2.2);
      //imageMode(CORNER);
      image(particleCanvas,0,WallHeight);
    }
    
    for(HashMap.Entry<Long, PharusPlayer> playersEntry : pc.players.entrySet()){
       PharusPlayer p = playersEntry.getValue();
       guide.drawGuidance(p);
    }
    
    
    for(KeyboardPlayer kp: kps){
      kp.update();
      kp.draw();
      
      // draw direction guidance
      guide.drawGuidance(kp);
    }
    
    int remainingTime = stateStart + stateDuration - millis();
    
    String formattedTime = (remainingTime/60000+":"+nf((remainingTime/1000)%60,2));
    text(formattedTime, 30,30);
    if(remainingTime < 0){stateMgr.setState(STATE_END);}
    
    super.draw();
    
  }  
  
}