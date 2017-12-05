class IntroState extends State {
  
  IntroState() {
    super();
  }
  
  IntroState(StateMgr _stateMgr) {
    super(_stateMgr); 
  }
  
  void draw() {
    fill(255, 0, 0);
    rect(0, 0, width, height);
  }  
  
}