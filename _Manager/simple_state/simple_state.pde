/*
* Simple finite state machine
* v1.1
*/

int shrink = 6;
int WindowWidth = 3030/shrink; // for real Deep Space this should be 3030
int WindowHeight = 3712/shrink; // for real Deep Space this should be 3712
int WallHeight = 1914/shrink; // for real Deep Space this should be 1914 (Floor is 1798)
int FloorHeight = 1798/shrink;

// delta time. calc in draw
float dt = 0;

StateMgr stateMgr;

VectorField vf;
ParticleSystem ps;

int STATEA;
int STATEB;
int STATEC;

void settings(){
  size(WindowWidth, WindowHeight);
}

void setup() {
  frameRate(30);
  noStroke();
  colorMode(HSB, 255,255,255);
  
  vf = new VectorField();
  ps = new ParticleSystem();
  
  stateMgr = new StateMgr();
  /* TODO States
  Intro (10 bis 15 sec)
  Jede minute einen state (3 states), intensität steigert sich
  
  Ende (bilder zeigen)
  */
  STATEA = stateMgr.addState(new StateA(stateMgr));
  STATEB = stateMgr.addState(new StateB(stateMgr));
  STATEC = stateMgr.addState(new StateC(stateMgr, STATEA));
  
  stateMgr.setState(STATEA);
}

void draw() {
  dt = 1/frameRate;
  stateMgr.getCurrentState().draw();
  stateMgr.updateStates();
  
  // state transition from application:
  // switch from state B to state A or C after 2 seconds (randomly)
  if (stateMgr.getCurrentStateID() == STATEB && stateMgr.getTimeInState() > 2000) {
    if (int (random(2)) == 0)
      stateMgr.setState(STATEA);
    else
      stateMgr.setState(STATEC);
  }
  
  // draw UI
  fill(0);
  textSize(20);
  text((int)frameRate + " FPS", width / 2, 30);
  text(ps.getParticleCount(), width / 2, 60);
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