/*
* Simple finite state machine
* v1.1
*/

import ddf.minim.*;

static int shrink = 4;
int WindowWidth = 3030/shrink; // for real Deep Space this should be 3030
int WindowHeight = 3712/shrink; // for real Deep Space this should be 3712
int WallHeight = 1914/shrink; // for real Deep Space this should be 1914 (Floor is 1798)
int FloorHeight = 1798/shrink;

// delta time. calc in draw
float dt = 0;

StateMgr stateMgr;
Minim player;
AudioPlayer sound;
//Use AudioPlayer to load and play sound

VectorField vf;
ParticleSystem ps;

ArrayList<KeyboardPlayer> kps;

int INTROSTATE;
int STATEA;
int STATEB;
int STATEC;

void settings(){
  size(WindowWidth, WindowHeight);
}

void setup() {
  frameRate(30);
  noStroke();
  colorMode(HSB, 255);
  
  player = new Minim(this);
  
  vf = new VectorField();  
  ps = new ParticleSystem();
  kps = new ArrayList<KeyboardPlayer>();
  
  stateMgr = new StateMgr();
  /* TODO States
  Intro (10 bis 15 sec)
  Jede minute einen state (3 states), intensität steigert sich
  
  Ende (bilder zeigen)
  */
  INTROSTATE = stateMgr.addState(new IntroState(stateMgr));
  STATEA = stateMgr.addState(new StateA(stateMgr));
  STATEB = stateMgr.addState(new StateB(stateMgr));
  STATEC = stateMgr.addState(new StateC(stateMgr, STATEA));
  
  stateMgr.setState(STATEA);
  
  initPlayerTracking();
}

void draw() {
  dt = 1/frameRate;
  stateMgr.getCurrentState().draw();
  stateMgr.updateStates();
  
  // state transition from application:
  // switch from state B to state A or C after 2 seconds (randomly)
  /*if (stateMgr.getCurrentStateID() == STATEB && stateMgr.getTimeInState() > 2000) {
    if (int (random(2)) == 0)
      stateMgr.setState(STATEA);
    else
      stateMgr.setState(STATEC);
  }*/
  
  // draw UI
  fill(0);
  textSize(20);
  text((int)frameRate + " FPS", width / 2, 30);
  text(ps.getParticleCount(), width / 2, 60);
}

void keyPressed() {
  for(KeyboardPlayer kp: kps){
    kp.keyPressed();
  }
  switch(key)
  {
    case '1':
      stateMgr.setState(INTROSTATE);
      break;
    case '2':
      stateMgr.setState(STATEA);
      break;
    case '3':
      stateMgr.setState(STATEB);
      break;
    case '4':
      stateMgr.setState(STATEC);
      break;
    case 'y':
      ps.doDraw = !ps.doDraw;
      break;
    case 'x':
      vf.drawHeightfield = !vf.drawHeightfield;
      break;
    case 'c':
      vf.drawHeights = !vf.drawHeights;
      break;
    case 'v':
      vf.drawVectors = !vf.drawVectors;
      break;
  }
} 

void keyReleased(){
  for(KeyboardPlayer kp: kps){
    kp.keyReleased();
  }
}

void backgroundColor(){
  PImage img = loadImage("sand_texture.jpg");
  background(color(237, 201, 175));
  tint(255, 150);
  image(img, 0, 0);
  img.resize(width,height);   
}