
class State
{
  State() {
  }
  
  State(StateMgr _stateMgr) {
    stateMgr = _stateMgr;
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