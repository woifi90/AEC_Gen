
import ddf.minim.*;
AudioPlayer sound;


class SoundManager{
  String[] joinFiles;
  AudioPlayer[] joinSounds;
  AudioPlayer[] ambience;
  
  Minim audioplayer;
  AudioPlayer general;
  AudioPlayer [] music;
  AudioPlayer[] playerBuffer;
  int playerBufferSize = 10;
  File [] files;
  String filenames[];
  
  
  int musicCount = 0;
  
  public SoundManager(Minim minim){
    audioplayer = minim;
    
    playerBuffer = new AudioPlayer[playerBufferSize];
    
    String folder = dataPath("music") + '/';
    files = new File(folder).listFiles(); 
    filenames = new String[files.length]; 
    
    for(int y=0; y<files.length; y++) { 
      filenames[y]=files[y].getAbsolutePath(); 
    } 
    
    music = new AudioPlayer[filenames.length];
    
    for(int x = 0; x < filenames.length; x++){
        music[x] = audioplayer.loadFile(filenames[x]);;    
    }
   
    // LOAD JOIN SOUNDS
    files = new File(dataPath("joinSounds") + '/').listFiles(); 
    joinFiles = new String[files.length]; 
    //String[] joinFiles = { "Gong Clear 1.wav", "Gong Clear 2.wav", "Gong Clear 3.wav"};
    joinSounds = new AudioPlayer[joinFiles.length];
    for(int i = 0; i < joinFiles.length; i++){
     print(i);
     joinFiles[i] = files[i].getAbsolutePath(); 
     joinSounds[i] = audioplayer.loadFile(joinFiles[i]);    
    }
    println("");
    
    // LOAD AMBIENCE
    ambience = new AudioPlayer[3];
    ambience[0] = audioplayer.loadFile("ambience/Leafy_Tree_Wind_Lite.wav");
    ambience[1] = audioplayer.loadFile("ambience/Low_Wind_Tone_Atmosphere.wav");
    ambience[2] = audioplayer.loadFile("ambience/phurpa_intense.wav");
    
    for(int i = 0; i < 3; i++){
      ambience[i].setGain(-100);
      ambience[i].loop();
    }
    
  }
  
  float sampleThresholds[] = {0.0,0.5,0.8};
  float fadeInRange = 0.1;
  public void setIntensity(float i){
    
  }
  
  public void playIntroGong(){
      println("GONG");
     general = audioplayer.loadFile("gong.wav");
     general.setGain(-10);
     general.play();
  }
  
  public void playOutroGong(){
          println("GONG");
     general = audioplayer.loadFile("gong2.wav");
     general.setGain(-10);
     general.play();
  }
  
  
  int joinIter = 0;
  public void playJoinSound(){
    println("join sound");
    int rnd = int(random(joinFiles.length));
    
    playerBuffer[joinIter] = audioplayer.loadFile(joinFiles[rnd]);
    playerBuffer[joinIter].rewind();
    playerBuffer[joinIter].setGain(-20);
    playerBuffer[joinIter].play();
        
    joinIter++;
    if(joinIter >= playerBufferSize){
      joinIter = 0;
    }
  }
  
  public void playPlayerMusic(){
    if(musicCount < 11){
      int temp = (int)random(0,10);
      if(temp == 3){
        temp = (int)random(4,10);
      }
      music[temp].play();
      musicCount++;
    }
    else{
      musicCount = 0;
    }
  }
  
  public void playAmbience(){
    AudioPlayer ambience = audioplayer.loadFile("ambience/Low_Wind_Tone_Atmosphere.wav");    
    ambience.loop();
  }
  
  public void playMusic(){
    music[3].loop();
    println("playing music");
  }
  
}