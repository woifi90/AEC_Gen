

// a player instance that is controlled by keyboard inputs
class KeyboardPlayer
{
  // Movement buttons
  int forward;
  int left;
  int backward;
  int right;
  
  // save the button state. otherwise multiple players don't work
  boolean forwardState = false;
  boolean leftState = false;
  boolean backwardState = false;
  boolean rightState = false;
  
  private boolean codedKey = false;
 
  // positional information
  PVector pos;
  float angle;
  float velocity;
  float angVel;
  color col;
  private final float velDamp = 0.5;
  private final float angDamp = 4;
  private int displ = 245;
  
  
  public KeyboardPlayer(String keys)
  {
    this.forward = keys.charAt(0);
    this.left = keys.charAt(1);
    this.backward = keys.charAt(2);
    this.right = keys.charAt(3);
    
    pos = new PVector(random(WindowWidth),random(WallHeight,WindowHeight));
    angle = 0;
    velocity = 0;
    angVel = 0;
    col = color(random(255), random(50,230), random(50,230));
  }
  
  public KeyboardPlayer(int forward, int left, int backward, int right){
    this.forward = forward;
    this.left = left;
    this.backward = backward;
    this.right = right;
    
    codedKey = true;
    pos = new PVector(random(WindowWidth),random(WallHeight,WindowHeight));
    angle = 0;
    velocity = 0;
    angVel = 0;
    col = color(random(255), random(255), random(255));
  }
  
  public int getDispl(){
    return (int)map(velocity, 0, 60, 255, 245);
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
    angVel = constrain(angVel, -5, 5);
    
    // move
    angle += angVel * dt;
    pos.add(PVector.mult(PVector.fromAngle(angle),velocity * dt));

    // damp
    velocity *= 1-velDamp * dt;
    angVel *= 1- angDamp * dt;
    
    // check for out of bounds
    pos.x = constrain(pos.x, 0, WindowWidth);
    pos.y = constrain(pos.y, WallHeight, WindowHeight);
  }
  
  
  public void keyPressed(){
    if(codedKey){
      if(keyCode == forward){
        forwardState = true;
      }
      if(keyCode == left){
        leftState = true;
      }
      if(keyCode == backward){
        backwardState = true;
      }
      if(keyCode == right){
        rightState = true;
      }
    }
    else{
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
  }
  
  public void keyReleased(){
    if(codedKey){
      if(keyCode == forward){
        forwardState = false;
      }
      if(keyCode == left){
        leftState = false;
      }
      if(keyCode == backward){
        backwardState = false;
      }
      if(keyCode == right){
        rightState = false;
      }
    }else{
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
  }
  
  
  public void draw()
  {
    fill(0);

    pushMatrix();
      translate(pos.x,pos.y);
      rotate(angle);
      triangle(10,0,-7,7,-7,-7);
    popMatrix();
  }
}