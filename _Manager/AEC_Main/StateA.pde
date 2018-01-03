class StateA extends State {
  
  
  PImage arrow;
  
  int stateStart = 0;
  // minutes + seconds
  int stateDuration = 3 *60*1000 + 0 *1000;
  
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
    gen.setColorMode((int)random(0,4));
    kps.add(new KeyboardPlayer("wasd"));
    kps.add(new KeyboardPlayer("ijkl"));
    kps.add(new KeyboardPlayer(UP,LEFT,DOWN,RIGHT));
    imageMode(CORNER);
    colorMode(HSB);
    noTint();
    
    arrow = loadImage("pfeil.png");
    stateStart = millis();
  }
  
  void draw() {
    background(240);
    guide.draw();
   
    backgroundColor();
    
    for(HashMap.Entry<Long, PharusPlayer> playersEntry : pc.players.entrySet()){
      Player p = playersEntry.getValue();
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
    
    fill(0);
    if(ps.doDraw){
      image(particleCanvas,0,0);
      image(particleCanvas,0,WallHeight);
    }
    
    for(KeyboardPlayer kp: kps){
      kp.update();
      kp.draw();
      
      // draw direction guidance
      //float dir = guide.getDominantDirection(kp.pos.x,kp.pos.y-WallHeight, kp.angle);
      float dir = guide.getNewDirection(kp.pos.x,kp.pos.y-WallHeight, kp.angle);
      //if(dir!=0)println(dir);
      pushMatrix();
     
      translate(kp.pos.x,kp.pos.y);
      //rotate(radians(-dir + 180 ));
      rotate(dir + PI/2);
       scale((1.0/AEC_Main.shrink) * 2.0);
      translate(-arrow.width/2,-arrow.height/2);
      
      image(arrow,0,0);
      popMatrix();
    }
    
    int remainingTime = stateStart + stateDuration - millis();
    
    String formattedTime = (remainingTime/60000+":"+nf((remainingTime/1000)%60,2));
    text(formattedTime, 30,30);
    if(remainingTime < 0){stateMgr.setState(STATEC);}
    
  }  
  
  void clearBackground() {
     background(240);
     kps.clear();  
  }
  
}