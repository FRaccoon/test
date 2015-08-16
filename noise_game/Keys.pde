
class Keys {
  Game g;
  boolean ku, kd;
  
  Keys(Game g) {
    this.g = g;
    ku = false;
    kd = false;
  }
  
  void keyPressed(){
    if(key==CODED) {
      if(keyCode==UP)ku=true;
      else if(keyCode==DOWN)kd=true;
    }
  }
  
  void keyReleased(){
    if(key==CODED) {
      if(keyCode==UP)ku=false;
      else if(keyCode==DOWN)kd=false;
    }else {
      if(key=='q')g.fin();
    }
  }
}

