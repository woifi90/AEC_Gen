
class StateC extends State {
  
  void draw() {
    fill(0, 0, 255);
    rect(0, 0, width, height);    
  }

  int getNextStateID() {
    if (stateMgr.getTimeInState() > 3000)
    {
      return 0; 
    }
    return super.getNextStateID();
  }  
}

