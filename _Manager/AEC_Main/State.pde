
class State
{
  
  protected PGraphics stateImgBuffer;  // buffer to which to draw all static images first in order to reduce redrawing every frame
  int stateID; 
  StateMgr stateMgr;
  
  State() {
  }
  
  State(StateMgr _stateMgr) {
    stateMgr = _stateMgr;
  }
  
  void setup() {
  }
  
  // called just before state is changed
  void cleanup(){
    loadPixels();
    stateTransitionBuffer.loadPixels();
    arrayCopy(pixels, stateTransitionBuffer.pixels);
    stateTransitionBuffer.updatePixels();
    
    stateMgr.transitionStart = millis();
  }
  
  void draw() {
    if(stateMgr.transitionStart + stateMgr.transitionLength > millis()){
      imageMode(CORNER);
      tint(255,lerp(255,0, (millis() - stateMgr.transitionStart)/(float)stateMgr.transitionLength));
      image(stateTransitionBuffer, 0,0);
      noTint();
    }
  }
  
  int getNextStateID() {
    return stateID;
  }
 
  void setID(int _stateID) {
    stateID = _stateID;
  }

  int getID() {
    return stateID;
  }
  
  void setStateMgr(StateMgr _stateMgr) {
    stateMgr = _stateMgr;
  }

}