class StateA extends State {
  
  int brushSize = 20;
  Guidance guide;
  PImage arrow;
  
  StateA() {
    super();
  }
  
  StateA(StateMgr _stateMgr) {
    super(_stateMgr); 
  }
  
  void setup(){
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
    guide.draw();
    
    heightfield.beginDraw();
    heightfield.blendMode(MULTIPLY);
    heightfield.noStroke();
      for(HashMap.Entry<Long, PharusPlayer> playersEntry : pc.players.entrySet()){
        PharusPlayer p = playersEntry.getValue();
        PVector pos = p.getPosition();
        // spawn particles on every player
        for(int i = 0; i<5; i++){
          ps.spawnParticle(
            new PVector(pos.x+random(brushSize)-brushSize/2,pos.y-WallHeight+random(brushSize)-brushSize/2),
            2500, 
            p.col
          );
        }
        // influence heightfield on every player
        heightfield.fill(p.displ);
        heightfield.ellipse(pos.x, pos.y-WallHeight, 10,10);
      }
      
      for(KeyboardPlayer p: kps){
        PVector pos = p.pos;
        for(int i = 0; i<5; i++){
          ps.spawnParticle(
            new PVector(pos.x+random(brushSize)-brushSize/2,pos.y-WallHeight+random(brushSize)-brushSize/2),
            2500, 
            p.col
          );
        }
        heightfield.fill(p.displ);
        heightfield.ellipse(pos.x, pos.y-WallHeight, 10,10);
        
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
  
}