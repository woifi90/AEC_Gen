/*
* Simple finite state machine
* v1.1
*/



static int shrink = 3;
int WindowWidth = 3030/shrink; // for real Deep Space this should be 3030
int WindowHeight = 3712/shrink; // for real Deep Space this should be 3712
int WallHeight = 1914/shrink; // for real Deep Space this should be 1914 (Floor is 1798)
int FloorHeight = 1798/shrink;

// delta time. calc in draw
float dt = 0;

StateMgr stateMgr;
SoundManager sm;

ColorGen gen = new ColorGen();
//Use AudioPlayer to load and play sound

VectorField vf;
ParticleSystem ps;

PImage paperTexture;
PImage logo;
PImage sandTexture;
PImage stateTransitionBuffer;

ArrayList<KeyboardPlayer> kps;

int STATE_INTRO;
int STATE_DRAW;
int STATE_END;

StateDraw stateA;

Guidance guide;

void settings(){
  size(WindowWidth, WindowHeight);
}

void setup() {
  
  frameRate(30);
  noStroke();
  
  colorMode(HSB,255);
  
  sm = new SoundManager(new Minim(this));
  
  paperTexture = loadImage("paper.png");
  logo = loadImage("logo.png");
  sandTexture = loadImage("sand_texture.jpg");
  
  paperTexture.resize(WindowWidth,FloorHeight);
  logo.resize(0,WallHeight/6);
  
  stateTransitionBuffer = createImage(WindowWidth, WindowHeight, ARGB);
  
  vf = new VectorField();  
  ps = new ParticleSystem();
  kps = new ArrayList<KeyboardPlayer>();
  
  stateMgr = new StateMgr();

  STATE_INTRO = stateMgr.addState(new StateIntro(stateMgr));
  
  guide = new Guidance();
  
  stateA = new StateDraw(stateMgr);
  STATE_DRAW = stateMgr.addState(stateA);
  STATE_END = stateMgr.addState(new StateEnd(stateMgr, STATE_DRAW));
  
  stateMgr.setState(STATE_INTRO);
  
  initPlayerTracking();
  
  
}

void draw() {
  dt = 1/frameRate;
  
  stateMgr.getCurrentState().draw();
  stateMgr.updateStates();
  
  // draw UI
  fill(240);
  textSize(20);
  text((int)frameRate + " FPS", width / 2, 30);
}

void keyPressed() {
  for(KeyboardPlayer kp: kps){
    kp.keyPressed();
  }
  switch(key)
  {
    case '1':
      stateMgr.setState(STATE_INTRO);
      break;
    case '2':
      stateMgr.setState(STATE_DRAW);
      break;
    case '3':
      stateMgr.setState(STATE_END);
      break;
      
    case '4':
      gen.setColorMode(1);
      updatePlayerColors();
      break;
    case '5':
      gen.setColorMode(2);
      updatePlayerColors();
      break;
    case '6':
      gen.setColorMode(3);
      updatePlayerColors();
      break;
      
    case 'x':
      ps.doDraw = !ps.doDraw;
      break;
      
    case 'c':
      vf.drawHeightfield = !vf.drawHeightfield;
      break;
    case 'v':
      vf.drawVectors = !vf.drawVectors;
      break;
      
    case 'b':
      guide.changeShape();
      break;
    case 'n':
      guide.toggleGuidanceDebug();
      break;
      
    case '+':
      ((StateDraw)stateMgr.getState(STATE_DRAW)).stateDuration+=10*1000;
      break;
    case '-':
      ((StateDraw)stateMgr.getState(STATE_DRAW)).stateDuration-=10*1000;
      break;
  }
} 

void keyReleased(){
  for(KeyboardPlayer kp: kps){
    kp.keyReleased();
  }
}

void updatePlayerColors(){
  for(HashMap.Entry<Long, PharusPlayer> playersEntry : pc.players.entrySet()){
    Player p = playersEntry.getValue();
    p.updateColor();
  } 
}