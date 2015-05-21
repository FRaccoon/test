
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
  int w, h;
  
  Mushi m;
  
  World() {
    g = new PVector(0, .15);
    w = width;h = height;
    
    m = new Mushi(this, 5);
    
  }
  
  void update() {
    m.update();
    
  }
  
  void draw() {
    m.draw();
    
  }
  
}

class Mushi {
  World w;
  int n;
  ArrayList<Ball> bs;
  ArrayList<Line> ls;
  
  Mushi(World w, int n) {
    this.w = w;
    this.n = (n<1?1:n);
    
    bs = new ArrayList<Ball>();
    ls = new ArrayList<Line>();
    
    PVector o = new PVector(100, 100);
    PVector wid = new PVector(60, -15), hei = new PVector(15, 60);
    
    Ball b1 = new Ball(w, o.get()),
    b2 = new Ball(w, PVector.add(o, wid));
    bs.add(b1);bs.add(b2);ls.add(new Line(b1, b2));
    
    for(int i=0;i<this.n;i++) {
      Ball b3 = new Ball(w, PVector.add(b1.p, hei)),
      b4 = new Ball(w, PVector.add(b2.p, hei));
      bs.add(b3);
      bs.add(b4);
      ls.add(new Line(b1, b3));
      ls.add(new Line(b2, b4));
      ls.add(new Line(b1, b4));
      ls.add(new Line(b2, b3));
      ls.add(new Line(b3, b4));
      b1 = b3;
      b2 = b4;
    }
    
  }
  
  Ball get_b(int i) {
   return bs.get(i);
  }
  
  Line get_l(int i) {
   return ls.get(i);
  }
  
  void update() {
    
    for(Line l : ls) {
      l.update();
    }
    
    for(Ball b : bs) {
      b.set_g();
      b.update();
      b.reset();
    }
    
  }
  
  void draw() {
    for(Line l : ls) {
      l.draw();
    }
    for(Ball b : bs) {
      b.draw();
    }
    
  }
  
}

class Ball {
  World w;
  PVector p = new PVector(0, 0), 
  v = new PVector(0, 0), 
  f = new PVector(0, 0);
  float m=20.0, r=10.0;
  
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
    if ((p.x < r && v.x < 0) || (p.x > w.w-r && v.x > 0)) {
      v.x *= -.95;
    }
    if ((p.y < r && v.y < 0) || (p.y > w.h-r && v.y > 0)) {
      v.y *= -.95;
    }
  }
  
  void draw() {
    stroke(255);
    noFill();
    ellipse(p.x, p.y, r*2, r*2);
  }
  
}

class Line {
  float l, k;
  Ball b1, b2;
  
  Line(Ball b1, Ball b2) {
    this.b1 = b1;
    this.b2 = b2;
    this.l = (PVector.sub(b1.p, b2.p)).mag();
    this.k = .2;
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
    line(b1.p.x, b1.p.y, b2.p.x, b2.p.y);
  }
  
}


