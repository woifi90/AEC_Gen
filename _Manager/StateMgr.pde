
class StateMgr {
 
  State[] states;
  
  int currentStateID;
  int stateStamp;
  
  void setState(int newState) {
    if (newState == currentStateID || newState < 0 || newState >= states.length)
      return;
      
    currentStateID = newState;
    stateStamp = millis();
    
    println("switch to state "+currentStateID);
  }
  
  State getCurrentState() {
    return states[currentStateID];
  }

  int getCurrentStateID() {
    return currentStateID;
  }
  
  State getState(int stateID) {
   if (stateID < 0 || stateID >= states.length)
      return null;
    
    return states[stateID]; 
  }
  
  int getTimeInState() {
    return millis() - stateStamp;
  }
  
  int addState(State state) {
    if (states == null) {
      println("creating new states array");
      states = new State[1];
      states[0] = state;
    } else {
      states = (State[])append(states, state);
    }
    state.setID(states.length - 1);
    state.setStateMgr(this);
    
    println("state " + state.getID() + " added");
    
    return state.getID();
  } 
  
}
