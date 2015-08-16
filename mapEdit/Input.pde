
class Input {
  Editer e;
  
  boolean kw, ka, ks, kd;
  boolean md;
  
  Input(Editer e) {
    this.e = e;
    
    kw = false;
    ka = false;
    ks = false;
    kd = false;
    
    md = false;
  }
  
  void keyPressed() {
    if(key==CODED) {
    }else {
      switch(key) {
       case 'w':kw=true;break;
       case 'a':ka=true;break;
       case 's':ks=true;break;
       case 'd':kd=true;break;
      }
    }
  }
  
  void keyReleased() {
    if(key==CODED) {
    }else {
      switch(key) {
       case 'w':kw=false;break;
       case 'a':ka=false;break;
       case 's':ks=false;break;
       case 'd':kd=false;break;
      }
    }
  }
  
  void mousePressed() {
    e.b = 0;
    md = true;
    
    if(mouseX>width-160){
      e.mapLayer.PmouseX = mouseX;
      e.mapLayer.PmouseY = mouseY;
      
      e.mapLayer.paint = e.mapLayer.PmouseX/e.c + 8*(e.mapLayer.PmouseY/e.c-e.a) - 35 ;
      e.mapLayer.copy = e.mapLayer.editmap.get((e.mapLayer.paint%8)*e.c, (e.mapLayer.paint/8)*e.c, e.c, e.c);
    }
    
    //println(mouseX+","+mouseY+","+e.mapLayer.maskTool);
    
  }
  
  void mouseReleased() {
    for(int i=0;i<e.gui.bs.length;i++) {
      if(e.gui.bs[i].press(mouseX, mouseY))break;
    }
    md = false;
  }
  
  void mouseWheel(int delta) {
    if(mouseX > width-160) {
      e.a -= delta*e.c;
      e.b -= delta*e.c;
    }
    
    if(e.a > 0){
      e.a = 0;
      e.b = 0;
    }
    
    if(e.a < -e.mapLayer.editmap.height){
      e.a = 0;
    }
    
  }
  
}
