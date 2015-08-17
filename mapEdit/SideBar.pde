
class SideBar extends Box {
  Editer e;
  
  int a; // (*, a) = top
  
  int mpx, mpy; // mouse_position
  
  PImage ec;
  
  SideBar(Editer e) {
    this.e = e;
    
    p = new IVector(width-160, 0);
    s = new IVector(160, height);
    
    mpx = 0;
    mpy = 0;
    
    a = 0;
    
    ec = loadImage("base_img.png");
    
  }
  
  void update() {
    if(inside(mouseX, mouseY)) {
      if((e.input.kw || e.input.kup) && a>0)a--;
      if((e.input.ks || e.input.kdown) && a*e.c+s.y<ec.height)a++;
      
    }
    
  }
  
  void draw() {
    image(ec, p.x, p.y-a*16);
    stroke(0);
    fill(0,204,255,100);
    rect(p.x+mpx*e.c, p.y+(mpy-a)*e.c, e.c, e.c);
    
  }
  
  boolean press_event(int mx, int my) {
    if(!this.inside(mx, my))return false;
    mpx = ((mouseX-p.x)/e.c);
    mpy = ((mouseY-p.y)/e.c)+a;
    
    e.ml.paint(e.ml.chip, ec.get(mpx*e.c, mpy*e.c, e.c, e.c), 0, 0);
    return true;
  }
  
  void wheel_event(int delta) {
    a += delta;
    if(a<0 || a*e.c>ec.height)a = 0;
    
  }
  
}

