

abstract class Player{
  
  private final int BRUSH_SIZE = 60/shrink;
  private final int PARTICLE_COUNT = 5;
  
  private color col;
  
  public Player(){
    col = getColor();//color(random(255), random(100,240),random(50,240));
  }
  

  
  public color getColor(){
    println(gen.getColor());
    return gen.getColor();
  }
  
  public void spawnParticles(){
    for(int i = 0; i<PARTICLE_COUNT; i++){
      PVector pos = this.getPosition();
        ps.spawnParticle(
          new PVector(pos.x+random(- BRUSH_SIZE,BRUSH_SIZE),pos.y-WallHeight+random(-BRUSH_SIZE,BRUSH_SIZE)),
          2000, 
          col
        );
      }
  }
  
  abstract public PVector getPosition();
  
  abstract public int getDisplacement();
}