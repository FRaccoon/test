
class Box {
  IVector p, s;
  
  Box() {}
  
  boolean inside(int px, int py) {
    return px(px)>0 && px(px)<s.x && py(py)>0 && py(py)<s.y;
  }
  
  int px(int px) {return px - p.x;}
  int py(int py) {return py - p.y;}
  
  int cx(int cx) {return cx + p.x;}
  int cy(int cy) {return cy + p.y;}
  
  void area() {
    noFill();
    stroke(255);
    rect(cx(0), cy(0), s.x, s.y);
  }
  
}

class IVector { // int_vector
  int x, y;
  
  IVector(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  void set(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  void print() {println("x: "+x+", y: "+y);} // debug
  
}