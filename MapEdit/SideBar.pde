
class SideBar extends Box {
  MEditer e;
  
  int a, ss; // (*, a) = top; scroll_speed
  
  IVector mp; // mouse_position
  boolean pr; // mouse_press
  
  EImage ec;
  int w; // chip_width
  
  SideBar(MEditer e) {
    this.e = e;
    
    p = new IVector(width-e.c*10, 0);
    s = new IVector(e.c*10, height);
    
    mp = new IVector(0, 0);
    
    a = 0;
    
    pr = false;
    
    ec = new EImage();
    ec.set_img(loadImage("base_img.png"));
    w = ec.l.width/e.c;
    
    ss=10;
    
  }
  
  void update() {
    if(inside(mouseX, mouseY)) {
      if((e.i.kw || e.i.kup))a-=ss;
      if((e.i.ks || e.i.kdown))a+=ss;
      
      if(a<0)a=0;
      if(a+s.y>ec.l.height)a=ec.l.height;
    }
    
  }
  
  int mx(int px) {return (px(px)/e.c);}
  int my(int py) {return ((py(py)+a)/e.c);}
  
  void draw() {
    ec.draw((Box)this, new IVector(0, a));
    
    stroke(255);
    fill(0, 204, 255, 100);
    if(pr) {
      IVector xp = new IVector(max(mp.x, mx(mouseX)), max(mp.y, my(mouseY))),
      ip = new IVector(min(mp.x, mx(mouseX)), min(mp.y, my(mouseY)));
      rect(cx(ip.x*e.c), cy(ip.y*e.c-a), (xp.x-ip.x+1)*e.c, (xp.y-ip.y+1)*e.c-a);
    }else {
      rect(cx(mp.x*e.c), cy(mp.y*e.c-a), e.ml.ls.chip.cs.x*e.c, e.ml.ls.chip.cs.y*e.c);
    }
    
    if(e.d)area();
  }
  
  boolean press_event(int mx, int my) {
    if(!this.inside(mx, my))return false;
    
    pr = true;
    
    mp.set(mx(mouseX), my(mouseY));
    e.ml.ls.set_chip(mp, new IVector(1, 1));
    
    return true;
  }
  
  boolean release_event(int mx, int my) {
    pr = false;
    if(!this.inside(mx, my))return false;
    
    IVector np = new IVector(max(mp.x, mx(mouseX)), max(mp.y, my(mouseY)));
    mp.set(min(mp.x, mx(mouseX)), min(mp.y, my(mouseY)));
    
    e.ml.ls.set_chip(mp, new IVector(np.x-mp.x+1, np.y-mp.y+1));
    
    return true;
  }
  
  void wheel_event(int delta) {
    a += delta;
    if(a<0 || a>ec.l.height)a = 0;
    
  }
  
}