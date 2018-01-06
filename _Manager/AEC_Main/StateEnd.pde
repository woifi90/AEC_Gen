
class StateEnd extends State {
  
  // after 20 seconds switch back to drawing
  private final int END_DURATION = 20 * 1000;
  
  StateEnd() {
    super();
  }
  
  StateEnd(StateMgr _stateMgr, int _idOfStateA) {
    super(_stateMgr); 
    idOfStateA = _idOfStateA;
  }
  
  void setup(){
    guide.setShapeDraw(true);
  }
  
  void draw() {
    background(40);
    guide.draw();
    imageMode(CENTER);
    image(paperTexture,width/2,WallHeight/2);
    image(particleCanvas,width/2,WallHeight/2);
    imageMode(CORNER);
    
    super.draw();
  }

  // state transition from inside of state:
  // after 20 seconds, next state is A
  int getNextStateID() {
    if (stateMgr.getTimeInState() > END_DURATION)
    {
      return STATE_DRAW; 
    }
    return super.getNextStateID();
  }  
  
  int idOfStateA;
}