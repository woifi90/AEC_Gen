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
    
    //sm.playMusic();
    
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
    sm.playIntroGong();
  }
  
  void cleanup(){
    super.cleanup();
    background(240);
    kps.clear();
    vf.reset();
  }
  
  float intensityPrev = 0;
  float intensityDamping = 0.99;
  void draw() {
    image(stateImgBuffer,0,0);
    
    guide.draw();
   
    float highestVelocity = 0;
    float averageVelocity = 0;
    for(HashMap.Entry<Long, PharusPlayer> playersEntry : pc.players.entrySet()){
      PharusPlayer p = playersEntry.getValue();
      p.spawnParticles();  
      
      float velocity = p.getAverageVelocity().mag();
      averageVelocity += velocity;
      if(velocity > highestVelocity){
        highestVelocity = velocity;
      }
    }
    
    // calculate sound intensity
    if(pc.players.size() > 0 && !Float.isNaN(averageVelocity)){
      averageVelocity /= pc.players.size();
      averageVelocity = (averageVelocity+highestVelocity) / 2f; // weight average towards highest velocity
      float intensity = map(averageVelocity, 50, 250, 0, 1f);
      intensity = constrain(intensity, 0,1);
      intensity = lerp(intensityPrev, intensity, 1-intensityDamping);
      sm.setIntensity(intensity);
      intensityPrev = intensity;
      
      // draw UI
      if(globalDebug){
        fill(240);
        textSize(20);
        text(intensity, width / 3, 30);
      }
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
      imageMode(CENTER);
      image(particleCanvas,width/2,WallHeight/2, width/2.2, WallHeight/2.2);
      imageMode(CORNER);
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
    if(globalDebug){
      text(formattedTime, 30,30);
    }
    if(remainingTime < 0){stateMgr.setState(STATE_END);}
    
    super.draw();
    
  }  
  
}