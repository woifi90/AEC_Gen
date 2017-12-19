

abstract class Player{
  
  private final int BRUSH_SIZE = 80/shrink;
  private final int PARTICLE_COUNT = 3;
  
  private color col;
  
  public Player(){
    col = color(random(255), random(100,240),random(50,240));
  }
  

  
  public color getColor(){
    return col;
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