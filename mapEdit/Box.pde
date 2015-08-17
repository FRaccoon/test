
class Box {
  PVector p, s;
  
  Box() {}
  
  boolean inside(int mx, int my) {
    return mx>p.x && mx<p.x+s.x && my>p.y && my<p.y+s.y;
  }
  
}
