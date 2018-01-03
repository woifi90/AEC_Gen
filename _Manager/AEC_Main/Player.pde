

abstract class Player{
  
  private final int BRUSH_SIZE = 60/shrink;
  private final int PARTICLE_COUNT = 5;
  
  private color col;
  
  float smoothingFactor = 0.5;
  float smoothedArrowDirection = 0;
  
  public Player(){
    col = gen.getColor();
  }
  
  public color getColor(){
    return col;
  }
  
  public void updateColor(){
    col = gen.getColor();
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