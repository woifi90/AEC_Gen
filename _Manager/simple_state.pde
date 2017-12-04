
StateMgr stateMgr = new StateMgr();

int STATEA;
int STATEB;
int STATEC;

void setup() {
  noStroke();
  
  STATEA = stateMgr.addState(new StateA());
  STATEB = stateMgr.addState(new StateB());
  STATEC = stateMgr.addState(new StateC());
  
  stateMgr.setState(STATEA);
}

void draw() {
  stateMgr.getCurrentState().draw();
  stateMgr.setState(stateMgr.getCurrentState().getNextStateID());
  
  if (stateMgr.getCurrentStateID() == STATEB && stateMgr.getTimeInState() > 2000) {
    if (int (random(2)) == 0)
      stateMgr.setState(STATEA);
    else
      stateMgr.setState(STATEC);
  }
}

void keyPressed() {
 
  switch(key)
  {
    case '1':
      stateMgr.setState(STATEA);
      break;
    case '2':
      stateMgr.setState(STATEB);
      break;
    case '3':
      stateMgr.setState(STATEC);
      break;
  }
} 

