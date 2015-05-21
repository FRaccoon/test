
class Ball {
  World w;
  PVector p = new PVector(0, 0), 
  v = new PVector(0, 0), 
  f = new PVector(0, 0);
  float m=25.0, r=10.0;
  
  Ball(World w) {
    this.w = w;
  }
  
  Ball(World w, PVector p) {
    this.w = w;
    this.p = p;
  }
  
  Ball(World w, PVector p, float m) {
    this.w = w;
    this.p = p;
    this.m = m;
  }
  
  void update() {
    f.div(m);
    
    v.add(f);
    bound();
    
    p.add(v);
  }
  
  void reset() {
    f.set(0, 0, 0);
  }
  
  void set_g() {
    f.add(PVector.mult(w.g, m));
  }
  
  void bound() {
    /*if ((p.x < r && v.x < 0) || (p.x > w.w-r && v.x > 0)) {
      v.x *= -.95;
    }*/
    if ((p.y < r && v.y < 0) || (p.y > w.h-r && v.y > 0)) {
      v.x *= -.8;
      v.y *= -.8;
    }
  }
  
  void draw() {
    stroke(255);
    noFill();
    ellipse(p.x, p.y, r*2, r*2);
  }
  
}

