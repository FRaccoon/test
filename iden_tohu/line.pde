
class Line {
  float l, k;
  Ball b1, b2;
  
  Line(Ball b1, Ball b2) {
    this.b1 = b1;
    this.b2 = b2;
    this.l = (PVector.sub(b1.p, b2.p)).mag();
    this.k = .4;
  }
  
  Line(Ball b1, Ball b2, float l) {
    this.b1 = b1;
    this.b2 = b2;
    this.l = l;
    this.k = k;
  }
  
  void update() {
    PVector v = PVector.sub(b2.p, b1.p);
    float mk;
    
    mk = k*(v.mag()-l);
    v.normalize();
    v.mult(mk);
    
    b1.f.add(v);
    b2.f.sub(v);
    
  }
  
  void draw() {
    stroke(255);
    line(b1.p.x, b1.p.y, 0, b2.p.x, b2.p.y, 0);
  }
  
}

