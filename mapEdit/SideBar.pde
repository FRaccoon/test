
class SideBar extends Box {
  Editer e;
  
  int a; // (*, a) = top
  
  int mpx, mpy; // mouse_position
  
  PImage ec;
  
  SideBar(Editer e) {
    this.e = e;
    
    p = new IVector(width-e.c*10, 0);
    s = new IVector(e.c*10, height);
    
    mpx = 0;
    mpy = 0;
    
    a = 0;
    
    ec = loadImage("base_img.png");
    
  }
  
  void update() {
    if(inside(mouseX, mouseY)) {
      if((e.i.kw || e.i.kup) && a>0)a--;
      if((e.i.ks || e.i.kdown) && a*e.c+s.y<ec.height)a++;
      
    }
    
  }
  
  void draw() {
    image(ec.get(0, a*e.c, s.x, s.y), cx(0), cy(0));
    
    stroke(255);
    fill(0, 204, 255, 100);
    rect(cx(0)+mpx*e.c, cy(0)+(mpy-a)*e.c, e.c, e.c);
    
    if(e.d)area();
  }
  
  boolean press_event(int mx, int my) {
    if(!this.inside(mx, my))return false;
    mpx = (px(mouseX)/e.c);
    mpy = (py(mouseY)/e.c)+a;
    
    e.ml.chip.paint(ec.get(mpx*e.c, mpy*e.c, e.c, e.c), 0, 0);
    return true;
  }
  
  void wheel_event(int delta) {
    a += delta;
    if(a<0 || a*e.c>ec.height)a = 0;
    
  }
  
}

