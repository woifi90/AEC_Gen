
class StateC extends State {
  
  StateC() {
    super();
  }
  
  StateC(StateMgr _stateMgr, int _idOfStateA) {
    super(_stateMgr); 
    idOfStateA = _idOfStateA;
  }
  
  void setup(){
    guide.fadeinShape();  
  }
  
  void draw() {
    background(255);
    image(particleCanvas,0,0);
    guide.draw();
  }

  // state transition from inside of state:
  // after 3 seconds, next state is A
  int getNextStateID() {
    if (stateMgr.getTimeInState() > 20000)
    {
      return 0; 
    }
    return super.getNextStateID();
  }  
  
  int idOfStateA;
}