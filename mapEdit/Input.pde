
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
    md = true;
    
  }
  
  void mouseReleased() {
    md = false;
    
    if(e.sb.press_event(mouseX, mouseY))return;
    for(int i=0;i<e.gui.bs.length;i++) {
      if(e.gui.bs[i].press_event(mouseX, mouseY))return;
    }
    
  }
  
  void mouseWheel(int delta) {
    if(e.sb.inside(mouseX, mouseY))e.sb.wheel_event(delta);
    
  }
  
}
