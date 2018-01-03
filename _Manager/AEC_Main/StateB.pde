class StateB extends State {
  
  StateB() {
    super();
  }
  
  StateB(StateMgr _stateMgr) {
    super(_stateMgr); 
  }
  
  void draw() {
    fill(0, 255, 0);
    rect(0, 0, width, height);
    super.draw();
  }
  
}