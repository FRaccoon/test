
class SideBar extends Box {
  Editer e;
  
  int a; // (*, a) = top
  
  IVector mp; // mouse_position
  boolean pr; // mouse_press
  
  PImage ec;
  
  SideBar(Editer e) {
    this.e = e;
    
    p = new IVector(width-e.c*10, 0);
    s = new IVector(e.c*10, height);
    
    mp = new IVector(0, 0);
    
    a = 0;
    
    pr = false;
    
    ec = loadImage("base_img.png");
    
  }
  
  void update() {
    if(inside(mouseX, mouseY)) {
      if((e.i.kw || e.i.kup) && a>0)a--;
      if((e.i.ks || e.i.kdown) && a*e.c+s.y<ec.height)a++;
      
    }
    
  }
  
  int mx(int px) {return (px(px)/e.c);}
  int my(int py) {return (py(py)/e.c)+a;}
  
  void draw() {
    image(ec.get(0, a*e.c, s.x, s.y), cx(0), cy(0));
    
    stroke(255);
    fill(0, 204, 255, 100);
    if(pr) {
      IVector xp = new IVector(max(mp.x, mx(mouseX)), max(mp.y, my(mouseY))),
      ip = new IVector(min(mp.x, mx(mouseX)), min(mp.y, my(mouseY)));
      rect(cx(0)+ip.x*e.c, cy(0)+(ip.y-a)*e.c, (xp.x-ip.x+1)*e.c, (xp.y-ip.y-a+1)*e.c);
    }else {
      rect(cx(0)+mp.x*e.c, cy(0)+(mp.y-a)*e.c, e.ml.cs.x*e.c, e.ml.cs.y*e.c);
    }
    
    if(e.d)area();
  }
  
  boolean press_event(int mx, int my) {
    if(!this.inside(mx, my))return false;
    
    pr = true;
    
    mp.set(mx(mouseX), my(mouseY));
    e.ml.cs.set(0, 0);
    
    e.ml.set_chip(ec, mp);
    
    return true;
  }
  
  
  boolean release_event(int mx, int my) {
    pr = false;
    if(!this.inside(mx, my))return false;
    
    IVector np = new IVector(max(mp.x, mx(mouseX)), max(mp.y, my(mouseY)));
    mp.set(min(mp.x, mx(mouseX)), min(mp.y, my(mouseY)));
    e.ml.cs.set(np.x-mp.x+1, np.y-mp.y+1);
    
    e.ml.set_chip(ec, mp);
    
    return true;
  }
  
  void wheel_event(int delta) {
    a += delta;
    if(a<0 || a*e.c>ec.height)a = 0;
    
  }
  
}

