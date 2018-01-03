// the canvas to which particles paint
PImage particleCanvas;

// manages particles motion, spawning and killing
class ParticleSystem{
  
  // random value applied to particle color on spawn to get variation
  private final int RAND_COL = 10;
  
  // Debug
  public boolean doDraw = true;
  
  private ArrayList<Particle> particles = new ArrayList();

  // the canvas is created on instantiation
  public ParticleSystem(){
    particleCanvas = createImage(WindowWidth, FloorHeight,ARGB);
    this.reset();
  }
  
  // create a particle needs position, a lifetime and a color
  // lifetime < 0 lives forever
  public void spawnParticle(PVector pos, int lifetime, color col){
    // randomise color
    col = color(  constrain(hue(col) + random(-RAND_COL,RAND_COL), 0, 255),
                  constrain(saturation(col) + random(-RAND_COL,RAND_COL), 0, 255),
                  constrain(brightness(col) + random(-RAND_COL,RAND_COL), 0, 255));
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
    particleCanvas.loadPixels();
    
    // paint each particle that moves faster than threshold 
    // in the color of the particle
    for(Particle p: particles){
      if(p.velocity.mag() > 16/shrink && this.checkBounds(p.pos) && this.checkBounds(p.oldPos)){
        color currentCol = particleCanvas.pixels[(int)p.pos.x + (int)(p.pos).y*particleCanvas.width];
        color newCol = color(
          lerp(hue(currentCol),hue(p.col),0.5),
          lerp(saturation(currentCol),saturation(p.col),0.5),
          lerp(brightness(currentCol),brightness(p.col),0.5),
          max(p.alpha,alpha(currentCol))
        );
        this.simpleLineDraw((int)p.pos.x, (int)p.pos.y, (int)p.oldPos.x, (int)p.oldPos.y, newCol); 
      }
    }
    
    particleCanvas.updatePixels();
  }
  
  private void simpleLineDraw(int x,int y,int x2, int y2, color col){
    int w = x2 - x ;
    int h = y2 - y ;
    int dx1 = 0, dy1 = 0, dx2 = 0, dy2 = 0 ;
    if (w<0) dx1 = -1 ; else if (w>0) dx1 = 1 ;
    if (h<0) dy1 = -1 ; else if (h>0) dy1 = 1 ;
    if (w<0) dx2 = -1 ; else if (w>0) dx2 = 1 ;
    int longest = Math.abs(w) ;
    int shortest = Math.abs(h) ;
    if (!(longest>shortest)) {
        longest = Math.abs(h) ;
        shortest = Math.abs(w) ;
        if (h<0) dy2 = -1 ; else if (h>0) dy2 = 1 ;
        dx2 = 0 ;            
    }
    int numerator = longest >> 1 ;
    for (int i=0;i<=longest;i++) {
        particleCanvas.pixels[x + y * particleCanvas.width] = col;
        numerator += shortest ;
        if (!(numerator<longest)) {
            numerator -= longest ;
            x += dx1 ;
            y += dy1 ;
        } else {
            x += dx2 ;
            y += dy2 ;
        }
    }
  }
  
  private boolean checkBounds(PVector pos){
    return pos.x >=0 && pos.y >= 0 && pos.x < particleCanvas.width && pos.y < particleCanvas.height;
  }
  
  //reset
  public void reset(){
    particleCanvas.loadPixels();
    color clearCol = color(255,255,255,0);
    for(int i = 0; i< particleCanvas.pixels.length; i++){
      particleCanvas.pixels[i] = clearCol;
    }
    particleCanvas.updatePixels();
    particles.clear();
  }
  
  
}

class Particle{
  
  PVector oldPos;
  PVector pos;
  PVector velocity;
  int lifetime;
  int spawnTime;
  color col;
  int alpha = 0;
  
  public Particle(PVector pos, int lifetime, color col){
    this.pos = pos;
    oldPos = pos.copy();
    this.lifetime = lifetime;
    this.col = col;
    this.velocity = new PVector();
    spawnTime = millis();
    alpha = 255-vf.getHeight(pos);
  }
  
  public void update(){
    oldPos = pos.copy();
    alpha += (255-vf.getHeight(pos)-alpha)*dt;
    this.velocity.add(PVector.mult(vf.getAcc(pos), dt));
    this.pos.add(PVector.mult(this.velocity, dt));
    this.velocity.mult(0.95);
  }
}