
class SideBar extends Box {
  MEditer e;
  
  int ss; // scroll_speed;
  IVector a, ms; // (a.x, a.y) = (0, 0); ms: margin_size
  
  IVector mp; // mouse_position
  boolean pr; // mouse_press
  
  EImage ec;
  int w; // chip_width
  
  SideBar(MEditer e) {
    this.e = e;
    
    p = new IVector(e.s.x-e.c*10, 0); // e.c*10);
    s = new IVector(e.c*10, e.s.y); // -e.c*10);
    
    mp = new IVector(0, 0);
    
    ss = 18;
    a = new IVector(-e.c, 0);
    ms = new IVector(2*s.x/3, 2*s.y/3);
    
    pr = false;
    
    ec = new EImage();
    ec.set_img(loadImage("base_img.png"));
    w = ec.l.width/e.c;
    
  }
  
  void update() {
    if(inside(mouseX, mouseY)) {
      if((e.i.kw || e.i.kup))a.y-=ss;
      if((e.i.ks || e.i.kdown))a.y+=ss;
      
      //if(a.y<-ms.x)a.x=-ms.x;
      if(a.y<-ms.y)a.y=-ms.y;
      //if(a.x>ec.l.width+ms.x-s.x)a.x=ec.l.width+ms.x-s.x;
      if(a.y>ec.l.height+ms.y-s.y)a.y=ec.l.height+ms.y-s.y;
      
    }
    
  }
  
  int px(int px) {return e.px(px)-p.x;}
  int py(int py) {return e.py(py)-p.y;}
  
  int cx(int cx) {return e.cx(cx+p.x);}
  int cy(int cy) {return e.cy(cy+p.y);}
  
  int mx(int px) {return (px(px+a.x)/e.c)-(px(px+a.x)<0?1:0);}
  int my(int py) {return (py(py+a.y)/e.c)-(py(py+a.y)<0?1:0);}
  
  void draw() {
    ec.draw((Box)this, a);
    
    stroke(255);
    fill(0, 204, 255, 100);
    if(pr) {
      IVector xp = new IVector(max(mp.x, mx(mouseX)), max(mp.y, my(mouseY))),
      ip = new IVector(min(mp.x, mx(mouseX)), min(mp.y, my(mouseY)));
      cp(ip.mult(e.c)).sub(a).box(xp.sub(ip).add(1, 1).mult(e.c));
    }else {
      cp(mp.mult(e.c)).sub(a).box(e.ml.ls.chip.cs.mult(e.c));
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
  
  boolean wheel_event(int delta) {
    if(!inside(mouseX, mouseY))return false;
    a.y += delta*ss;
    
    //if(a.y<-ms.x)a.x=-ms.x;
    if(a.y<-ms.y)a.y=-ms.y;
    //if(a.x>ec.l.width+ms.x-s.x)a.x=ec.l.width+ms.x-s.x;
    if(a.y>ec.l.height+ms.y-s.y)a.y=ec.l.height+ms.y-s.y;
    
    return true;
    
  }
  
}