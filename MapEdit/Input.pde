
class Input {
  MEditer e;
  
  boolean kw, ka, ks, kd;
  boolean kup, kdown, kleft, kright, kshift;
  boolean md;
  
  Input(MEditer e) {
    this.e = e;
    
    kw = false;
    ka = false;
    ks = false;
    kd = false;
    
    kup = false;
    kdown = false;
    kleft = false;
    kright = false;
    kshift = false;
    
    md = false;
    
  }
  
  void keyPressed() {
    if(key==CODED) {
      switch(keyCode) {
       case UP:kup=true;break;
       case DOWN:kdown=true;break;
       case LEFT:kleft=true;break;
       case RIGHT:kright=true;break;
       case SHIFT:kshift=true;break;
       default:break;
      }
    }else {
      switch(key) {
       case 'w':kw=true;break;
       case 'a':ka=true;break;
       case 's':ks=true;break;
       case 'd':kd=true;break;
       default:break;
      }
    }
  }
  
  void keyReleased() {
    if(key==CODED) {
      switch(keyCode) {
       case UP:kup=false;break;
       case DOWN:kdown=false;break;
       case LEFT:kleft=false;break;
       case RIGHT:kright=false;break;
       case SHIFT:kshift=false;break;
       default:break;
      }
    }else {
      switch(key) {
       case 'w':kw=false;break;
       case 'a':ka=false;break;
       case 's':ks=false;break;
       case 'd':kd=false;break;
       default:break;
      }
    }
  }
  
  void mousePressed() {
    if(!md) {
      md = true;
      
    if(e.sb.press_event(mouseX, mouseY))return;
    if(e.g.press_event(mouseX, mouseY))return;
    if(e.ml.press_event(mouseX, mouseY))return;
    }
    
  }
  
  void mouseReleased() {
    if(md) {
      md = false;
      
      if(e.sb.release_event(mouseX, mouseY))return;
    }
  }
  
  void mouseWheel(int delta) {
    if(e.sb.inside(mouseX, mouseY))e.sb.wheel_event(delta);
    
  }
  
}