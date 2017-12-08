class StateA extends State {
  
  StateA() {
    super();
  }
  
  StateA(StateMgr _stateMgr) {
    super(_stateMgr); 
  }
  
  void draw() {
    fill(255, 0, 0);
    rect(0, 0, width, height);
  }  
  
}