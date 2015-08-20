
class SideBar extends Box {
  Editer e;
  
  int a; // (*, a) = top
  
  IVector mp; // mouse_position
  
  PImage ec;
  
  SideBar(Editer e) {
    this.e = e;
    
    p = new IVector(width-e.c*10, 0);
    s = new IVector(e.c*10, height);
    
    mp = new IVector(0, 0);
    
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
    rect(cx(0)+mp.x*e.c, cy(0)+(mp.y-a)*e.c, e.ml.cs.x*e.c, e.ml.cs.y*e.c);
    
    if(e.d)area();
  }
  
  boolean press_event(int mx, int my) {
    if(!this.inside(mx, my))return false;
    
    if(e.i.kshift) {
      IVector np = new IVector(max(mp.x, px(mouseX)/e.c), max(mp.y, (py(mouseY)/e.c)+a));
      mp.set(min(mp.x, px(mouseX)/e.c), min(mp.y, (py(mouseY)/e.c)+a));
      e.ml.cs.set(np.x-mp.x+1, np.y-mp.y+1);
    }else {
      mp.set(px(mouseX)/e.c, (py(mouseY)/e.c)+a);
      e.ml.cs.set(1, 1);
    }
    e.ml.set_chip(ec, mp);
    
    return true;
  }
  
  void wheel_event(int delta) {
    a += delta;
    if(a<0 || a*e.c>ec.height)a = 0;
    
  }
  
}

