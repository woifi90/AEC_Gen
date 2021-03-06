
class StateMgr {
 
  State[] states;
  PImage stateTransitionBuffer;

  int transitionLength = 2000;
  int transitionStart = 0;

  int currentStateID = 0;
  int stateStamp = millis();
  
  
  int setState(int newState) {
    if (newState < 0 || newState >= states.length) {
      return -1;
    }
  
    if (newState != currentStateID) {
      states[currentStateID].cleanup();
      currentStateID = newState;
      stateStamp = millis();
      states[currentStateID].setup();
      println("switch to state " + currentStateID);
    }
    
    return currentStateID;
  }
  
  State getCurrentState() {
    return getState(currentStateID);
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
      state.setup();
    } else {
      states = (State[])append(states, state);
    }
    state.setID(states.length - 1);
    
    println("state " + state.getID() + " added");
    
    return state.getID();
  } 
  
  int updateStates() {
    // query current state for next state id
    return setState(getCurrentState().getNextStateID());
  }

  
}