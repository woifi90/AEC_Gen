class StateA extends State {
  
  Guidance guide;
  PImage arrow;
  
  StateA() {
    super();
  }
  
  StateA(StateMgr _stateMgr) {
    super(_stateMgr); 
  }
  
  void setup(){
    
    clearBackground();
    
    vf.reset();
    ps.reset();
    
    kps.add(new KeyboardPlayer("wasd"));
    kps.add(new KeyboardPlayer("ijkl"));
    kps.add(new KeyboardPlayer(UP,LEFT,DOWN,RIGHT));
    imageMode(CORNER);
    colorMode(HSB, 255);
    noTint();
    guide = new Guidance();
    arrow = loadImage("pfeil.png");
  }
  
  void draw() {
    background(240);
    //guide.draw();
    
    heightfield.beginDraw();
    heightfield.blendMode(MULTIPLY);
    heightfield.noStroke();
      int heightfieldStampSize = 40/shrink;
      for(HashMap.Entry<Long, PharusPlayer> playersEntry : pc.players.entrySet()){
        Player p = playersEntry.getValue();
        
        p.spawnParticles();
        
        // influence heightfield on every player
        heightfield.fill(p.getDisplacement());
        heightfield.ellipse(p.getPosition().x, p.getPosition().y-WallHeight, heightfieldStampSize,heightfieldStampSize);
      }
      
      for(KeyboardPlayer p: kps){
        p.spawnParticles();        
        heightfield.fill(p.getDisplacement());
        heightfield.ellipse(p.getPosition().x, p.getPosition().y-WallHeight, heightfieldStampSize,heightfieldStampSize);
        
      }
    heightfield.endDraw();
    
    
    vf.update();
    ps.update();
    vf.draw();
    ps.draw();
    fill(0);
    if(ps.doDraw)
      image(particleCanvas,0,0);
    
    for(KeyboardPlayer kp: kps){
      kp.update();
      kp.draw();
      
      // draw direction guidance
      float dir = guide.getDominantDirection(kp.pos.x,kp.pos.y-WallHeight, kp.angle);
      
      pushMatrix();
     
      translate(kp.pos.x,kp.pos.y);
      rotate(radians(-dir + 180 ));
       scale((1.0/AEC_Main.shrink) * 2.0);
      translate(-arrow.width/2,-arrow.height/2);
      
      image(arrow,0,0);
      popMatrix();
    }
    
  }  
  
  void clearBackground() {
     background(240);
     kps.clear();  
  }
  
}