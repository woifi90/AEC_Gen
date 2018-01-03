
class StateC extends State {
  
  StateC() {
    super();
  }
  
  StateC(StateMgr _stateMgr, int _idOfStateA) {
    super(_stateMgr); 
    idOfStateA = _idOfStateA;
  }
  
  void draw() {
    background(255);
    image(particleCanvas,0,0);
  }

  // state transition from inside of state:
  // after 3 seconds, next state is A
  int getNextStateID() {
    if (stateMgr.getTimeInState() > 3000)
    {
      return 0; 
    }
    return super.getNextStateID();
  }  
  
  int idOfStateA;
}