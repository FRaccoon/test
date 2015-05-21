
World world;

void setup() {
  size(800, 600);
  world = new World();
}

void draw() {
  background(0);
  world.update();
  world.draw();
}

class World {
  PVector g;
  
  Huriko h;
  
  World() {
    g = new PVector(0, .9);
    
    h = new Huriko(this, 5);
    
  }
  
  void update() {
    h.update();
    
  }
  
  void draw() {
    h.draw();
    
  }
  
}

class Huriko {
  World w;
  int n;
  Ball[] bs;
  Line[] ls;
  
  Huriko(World w, int n) {
    this.w = w;
    this.n = (n<1?1:n);
    
    bs = new Ball[this.n+1];
    ls = new Line[this.n];
    PVector p = new PVector(-300, 20);
    p.div(this.n);
    float m = 50.0/this.n;
    
    bs[0] = new Ball(w, new PVector(width/2, 7.5));
    for(int i=0;i<this.n;i++) {
      bs[i+1] = new Ball(w, PVector.add(bs[i].p, p), m);
      ls[i] = new Line(bs[i], bs[i+1], p.mag());
    }
    
  }
  
  Ball get_b(int i) {
   return bs[i];
  }
  
  Line get_l(int i) {
   return ls[i];
  }
  
  void update() {
    for(int i=0;i<n;i++) {
      get_l(i).update();
    }
    
    get_b(0).reset();
    for(int i=0;i<n;i++) {
      get_b(i+1).update();
      get_b(i+1).reset();
    }
    
  }
  
  void draw() {
    for(int i=0;i<n;i++) {
      get_l(i).draw();
      get_b(i+1).draw();
    }
    
  }
  
}

class Ball {
  World w;
  PVector p = new PVector(0, 0), 
  v = new PVector(0, 0), 
  f = new PVector(0, 0);
  float m=10.0;
  
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
  
  Ball(World w, PVector p, float m, PVector v) {
    this.w = w;
    this.p = p;
    this.v = v;
    this.m = m;
  }
  
  void update() {
    f.add(PVector.mult(w.g, m));
    f.div(m);
    v.add(f);
    p.add(v);
  }
  
  void reset() {
    f.set(0, 0, 0);
  }
  
  void draw() {
    stroke(255);
    noFill();
    ellipse(p.x, p.y, m*2, m*2);
  }
  
}

class Line {
  float l=50, k=.5;
  Ball b1, b2;
  
  Line(Ball b1, Ball b2, float l) {
    this.b1 = b1;
    this.b2 = b2;
    this.l = l;
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
    line(b1.p.x, b1.p.y, b2.p.x, b2.p.y);
  }
  
}


