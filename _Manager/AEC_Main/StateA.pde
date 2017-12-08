class StateA extends State {
  
  StateA() {
    super();
  }
  
  StateA(StateMgr _stateMgr) {
    super(_stateMgr); 
  }
  
  void setup(){
    kps.add(new KeyboardPlayer("wasd"));
    kps.add(new KeyboardPlayer("ijkl"));
    imageMode(CORNER);
  }
  
  void draw() {
    fill(255, 0, 0);
    rect(0, 0, width, height);
    
    heightfield.beginDraw();
      for(HashMap.Entry<Long, PharusPlayer> playersEntry : pc.players.entrySet()){
        PharusPlayer p = playersEntry.getValue();
        PVector pos = p.getPosition();
        // spawn particles on every player
        for(int i = 0; i<5; i++){
          ps.spawnParticle(
            new PVector(pos.x+random(10),pos.y-WallHeight+random(10)),
            2500, 
            p.col +color(random(20),random(20),random(50))
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
            new PVector(pos.x+random(10),pos.y-WallHeight+random(10)),
            2500, 
            p.col +color(random(20),random(20),random(50))
          );
        }
        heightfield.fill(p.displ);
        heightfield.ellipse(pos.x, pos.y-WallHeight, 10,10);
        
      }
    heightfield.endDraw();
    
    image(heightfield,0,0);
    
    vf.update();
    ps.update();
    ps.draw();
    
    image(particleCanvas,0,0);
    
    for(KeyboardPlayer kp: kps){
      kp.update();
      kp.draw();
    }
    
  }  
  
}