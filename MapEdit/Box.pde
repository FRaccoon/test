
class Box {
  IVector p, s;
  
  Box() {}
  
  boolean inside(int px, int py) {
    return px(px)>0 && px(px)<s.x && py(py)>0 && py(py)<s.y;
  }
  
  int px(int px) { return px - p.x; }
  int py(int py) { return py - p.y; }
  
  int cx(int cx) { return cx + p.x; }
  int cy(int cy) { return cy + p.y; }
  
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
  
  IVector get() {
    return new IVector(this.x, this.y);
  }
  
  IVector set(int x, int y) {
    this.x = x;
    this.y = y;
    return this;
  }
  
  IVector add(int x, int y) {
    this.x += x;
    this.y += y;
    return this;
  }
  
  IVector sub(int x, int y) {
    this.x -= x;
    this.y -= y;
    return this;
  }
  
  boolean equals(int x, int y) {
    return (this.x==x && this.y==y);
  }
  
  IVector set(IVector v) {return this.set(v.x, v.y);}
  IVector add(IVector v) {return this.add(v.x, v.y);}
  IVector sub(IVector v) {return this.sub(v.x, v.y);}
  boolean equals(IVector v) {return this.equals(v.x, v.y);}
  
  IVector mult(int v) {
    this.x *= v;
    this.y *= v;
    return this;
  }
  
  void print() {println("x: "+x+", y: "+y);} // debug
  
}