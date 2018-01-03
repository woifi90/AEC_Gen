class StateA extends State {
  
  
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
    gen.setColorMode((int)random(0,4));
    kps.add(new KeyboardPlayer("wasd"));
    kps.add(new KeyboardPlayer("ijkl"));
    kps.add(new KeyboardPlayer(UP,LEFT,DOWN,RIGHT));
    imageMode(CORNER);
    colorMode(HSB);
    noTint();
    
    stateStart = millis();
  }
  
  void cleanup(){
    super.cleanup();
    background(240);
    kps.clear();
    vf.reset();
    ps.reset();
  }
  
  void draw() {
    background(240);
    guide.draw();
   
    backgroundColor();
    
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
    
    fill(0);
    if(ps.doDraw){
      image(particleCanvas,0,0);
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
    if(remainingTime < 0){stateMgr.setState(STATEC);}
    
    super.draw();
    
  }  
  
}