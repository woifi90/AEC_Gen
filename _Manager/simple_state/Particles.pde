// the canvas to which particles paint
PGraphics particleCanvas;

// manages particles motion, spawning and killing
class ParticleSystem{
  
  // Debug
  private final boolean debugDraw = false;
  
  private ArrayList<Particle> particles = new ArrayList();

  // the canvas is created on instantiation
  public ParticleSystem(){
    particleCanvas = createGraphics(WindowWidth, FloorHeight);
  }
  
  // create a particle needs color, a lifetime and a color
  // lifetime < 0 lives forever
  public void spawnParticle(PVector pos, int lifetime, color col){
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
      if(p.velocity.mag() > 5 || debugDraw){
        particleCanvas.set((int)p.pos.x, (int)p.pos.y, p.col);
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
  }
  
  public void update(){
    // todo get acceleration from vector field
    this.pos.add(PVector.mult(this.velocity, dt));
    // damp
    this.velocity.mult(0.8);
  }
}