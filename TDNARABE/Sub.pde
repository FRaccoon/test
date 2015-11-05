
class Box {
  IV p, s;
  Box o;
  
  Box(int px, int py, int sx, int sy) {
    p = new IV(px, py);
    s = new IV(sx, sy);
    o = null;
  }
  
  boolean inside(int x, int y) {
    return (ix(x)>0 && ix(x)<s.x && iy(y)>0 && iy(y)<s.y);
  }
  
  int ix(int x) {
    if(o==null)return x-p.x;
    else return o.ix(x)-p.x;
  }
  int iy(int y) {
    if(o==null)return y-p.y;
    else return o.iy(y)-p.y;
  }
  
  int ox(int x) {
    if(o==null)return x+p.x;
    else return o.ox(x+p.x);
  }
  int oy(int y) {
    if(o==null)return y+p.y;
    else return o.oy(y+p.y);
  }
  
  void draw() {
    rect(ox(0), oy(0), s.x, s.y);
  }
  
}

class IV { // int_vector
  int x, y;
  
  IV(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
}