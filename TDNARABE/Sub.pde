
class Box {
  IV p, s;
  
  Box(int px, int py, int sx, int sy) {
    p = new IV(px, py);
    s = new IV(sx, sy);
  }
  
  boolean inside(int x, int y) {
    return ix(x)>0 && ix(x)<s.x && iy(y)>0 && iy(y)<s.y;
  }
  
  int ix(int x) {return x-p.x;}
  int iy(int y) {return y-p.y;}
  
  int ox(int x) {return x+p.x;}
  int oy(int y) {return y+p.y;}
  
}

class IV { // int_vector
  int x, y;
  
  IV(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
}