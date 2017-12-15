// the canvas to which particles paint
PGraphics particleCanvas;

// manages particles motion, spawning and killing
class ParticleSystem{
  
  // random value applied to particle color on spawn to get variation
  private final int RAND_COL = 30;
  
  // Debug
  public boolean doDraw = true;
  
  private ArrayList<Particle> particles = new ArrayList();

  // the canvas is created on instantiation
  public ParticleSystem(){
    particleCanvas = createGraphics(WindowWidth, FloorHeight);
    particleCanvas.beginDraw();
    particleCanvas.background(255,255,255,0);
    particleCanvas.endDraw();
  }
  
  // create a particle needs position, a lifetime and a color
  // lifetime < 0 lives forever
  public void spawnParticle(PVector pos, int lifetime, color col){
    // randomise color
    col = color(  constrain(hue(col) + random (10), 0, 255),
                  constrain(saturation(col) + random (-RAND_COL,RAND_COL), 0, 255),
                  constrain(brightness(col) + random (-RAND_COL,RAND_COL), 0, 255));
    particles.add(new Particle(pos.copy(), lifetime, col));
  }
  
  // returns amount of live particles
  public int getParticleCount(){
    return particles.size();
  }
  
  // call each frame to move and kill particles
  public void update(){
    //remember dead particles
    ArrayList<Particle> deadParticles = new ArrayList();
    
    // check all particles
    for(Particle p: particles){
      if(p.lifetime > 0 && millis() - p.spawnTime > p.lifetime){
        deadParticles.add(p);
        continue;
      }
      p.update();
    }
    
    // remove dead
    for(Particle p: deadParticles){
      particles.remove(p); 
    }
  }
  
  // paint to particleCanvas
  public void draw(){
    particleCanvas.beginDraw();
    
    // paint each particle that moves faster than threshold 
    // in the color of the particle
    for(Particle p: particles){
      if(p.velocity.mag() > 5){
        color currentCol = particleCanvas.get((int)p.pos.x, (int)p.pos.y);
        color newCol = color(
          lerp(hue(currentCol), hue(p.col), 0.3),
          lerp(saturation(currentCol), saturation(p.col), 0.1),
          lerp(brightness(currentCol), brightness(p.col), 0.01)
        );
        particleCanvas.set((int)p.pos.x, (int)p.pos.y, newCol);
      }
    }
    
    particleCanvas.endDraw();
  }
}

class Particle{
  
  PVector pos;
  PVector velocity;
  int lifetime;
  int spawnTime;
  color col;
  
  public Particle(PVector pos, int lifetime, color col){
    this.pos = pos;
    this.lifetime = lifetime;
    this.col = col;
    this.velocity = new PVector();
    spawnTime = millis();
  }
  
  public void update(){
    this.velocity.add(PVector.mult(vf.getAcc(pos), dt));
    this.pos.add(PVector.mult(this.velocity, dt));
    // damp
    this.velocity.mult(0.95);
  }
}