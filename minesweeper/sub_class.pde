
class Box {
  IV p, s;
  
  Box(IV p, IV s) {
    this.p = p;
    this.s = s;
  }
  
  boolean inside(int px, int py) {
    return px(px)>0 && px(px)<s.x && py(py)>0 && py(py)<s.y;
  }
  
  int px(int px) {return px-p.x;}
  int py(int py) {return py-p.y;}
  
  int cx(int cx) {return cx+p.x;}
  int cy(int cy) {return cy+p.y;}
  
  void draw() {
    rect(p.x, p.y, s.x, s.y);
  }
  
}

class IV {
  int x, y;
  
  IV(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
}