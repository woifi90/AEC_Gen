class StateA extends State {
  
  int brushSize = 20;
  
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
            color(
              constrain(hue(p.col) + random (10), 0, 255),
              constrain(saturation(p.col) + random (10), 0, 255),
              constrain(brightness(p.col) + random (10), 0, 255)
              )
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
            color(
              constrain(hue(p.col) + random (10), 0, 255),
              constrain(saturation(p.col) + random (10), 0, 255),
              constrain(brightness(p.col) + random (10), 0, 255)
              )
          );
        }
        heightfield.fill(p.displ);
        heightfield.ellipse(pos.x, pos.y-WallHeight, 10,10);
        
      }
    heightfield.endDraw();
    
    
    vf.update();
    ps.update();
    vf.draw(true,false);
    ps.draw();
    
    image(particleCanvas,0,0);
    
    for(KeyboardPlayer kp: kps){
      kp.update();
      kp.draw();
    }
    
  }  
  
}