
class State
{
  void State(int _stateID) {
    stateID = _stateID;
  }
  
  void setup() {
  }
  
  void draw() {
  }
  
  int getNextStateID() {
    return stateID;
  }
 
  void setID(int _stateID) {
    stateID = _stateID;
  }

  int getID() {
    return stateID;
  }
  
  void setStateMgr(StateMgr _stateMgr) {
    stateMgr = _stateMgr;
  }

  int stateID; 
  StateMgr stateMgr;
}
