
import ddf.minim.*;
AudioPlayer sound;


class SoundManager{
  AudioPlayer[] joinSounds;
  Minim audioplayer;
  AudioPlayer general;
  
  public SoundManager(Minim minim){
    audioplayer = minim;
    
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
}