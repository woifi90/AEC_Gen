

// a player instance that is controlled by keyboard inputs
class KeyboardPlayer
{
  // Movement buttons
  char forward;
  char left;
  char backward;
  char right;
  
  // save the button state. otherwise multiple players don't work
  boolean forwardState = false;
  boolean leftState = false;
  boolean backwardState = false;
  boolean rightState = false;
 
  // positional information
  PVector pos;
  float angle;
  float velocity;
  float angVel;
  color col;
  private final float damp = 0.5;
  
  
  public KeyboardPlayer(String keys)
  {
    this.forward = keys.charAt(0);
    this.left = keys.charAt(1);
    this.backward = keys.charAt(2);
    this.right = keys.charAt(3);
    
    pos = new PVector(100,100);
    angle = 0;
    velocity = 0;
    angVel = 0;
    col = color(random(255), random(255), random(255));
  }
  
  
  public void update()
  {
    // calc velocities
    if(forwardState){
      velocity += 40*dt;
    }
    if(leftState){
      angVel -= 10*dt;
    }
    if(backwardState){
      velocity -= 40*dt;
    }
    if(rightState){
      angVel += 10*dt;
    }
    
    velocity = constrain(velocity, -60,60);
    angVel = constrain(angVel, -7, 7);
    
    // move
    angle += angVel * dt;
    pos.add(PVector.mult(PVector.fromAngle(angle),velocity * dt));

    // damp
    velocity *= 1-damp * dt;
    angVel *= 1- damp * dt;
    
    // check for out of bounds
    pos.x = constrain(pos.x, 0, WindowWidth);
    pos.y = constrain(pos.y, 0, WindowHeight);
  }
  
  
  public void keyPressed(){
    if(key == forward){
      forwardState = true;
    }
    if(key == left){
      leftState = true;
    }
    if(key == backward){
      backwardState = true;
    }
    if(key == right){
      rightState = true;
    }
  }
  
  public void keyReleased(){
    if(key == forward){
      forwardState = false;
    }
    if(key == left){
      leftState = false;
    }
    if(key == backward){
      backwardState = false;
    }
    if(key == right){
      rightState = false;
    }
  }
  
  
  public void draw()
  {
    fill(0);

    pushMatrix();
      translate(pos.x,pos.y);
      rotate(angle);
      triangle(10,0,-7,5,-7,-5);
    popMatrix();
  }
}