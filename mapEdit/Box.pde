
class Box {
  IVector p, s;
  
  Box() {}
  
  boolean inside(int mx, int my) {
    return mx>p.x && mx<p.x+s.x && my>p.y && my<p.y+s.y;
  }
  
}

class IVector { // int_vector
  int x, y;
  
  IVector(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
}
