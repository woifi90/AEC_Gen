
import ddf.minim.*;
AudioPlayer sound;


class SoundManager{
  AudioPlayer[] joinSounds;
  Minim audioplayer;
  AudioPlayer general;
  AudioPlayer [] music;
  File [] files;
  String filenames[];
  
  int musicCount = 0;
  
  public SoundManager(Minim minim){
    audioplayer = minim;
    
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
   
    
    String[] joinFiles = { "Gong Clear 1.wav", "Gong Clear 2.wav", "Gong Clear 3.wav"};
    joinSounds = new AudioPlayer[joinFiles.length];
    for(int i = 0; i < joinFiles.length; i++){
        println(i);
        joinSounds[i] = audioplayer.loadFile(joinFiles[i]);;    }
  }
  
  public void playIntroGong(){
      println("GONG");
     general = audioplayer.loadFile("gong.wav");
     general.play();
  }
  
  public void playJoinSound(){
    println("join sound");
    joinSounds[int(random(joinSounds.length))].play();
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
  
  public void playMusic(){
    music[3].loop();
    
  }
  
}