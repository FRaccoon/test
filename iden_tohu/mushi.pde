
class Mushi {
  World w;
  int n;
  ArrayList<Ball> bs;
  ArrayList<Line> ls;
  
  float l1, l2;
  Data d;
  
  Mushi(World w, int n) {
    this.w = w;
    this.n = (n<1?1:n);
    d = new Data();
    bs = new ArrayList<Ball>();
    ls = new ArrayList<Line>();
    
    set_up();
    
  }
  
  Mushi(World w, int n, Data d) {
    this.w = w;
    this.n = (n<1?1:n);
    this.d = new Data();
    this.d.set(d);
    bs = new ArrayList<Ball>();
    ls = new ArrayList<Line>();
    
    set_up();
    
  }
  
  void set_up() {
    bs.clear();
    ls.clear();
    
    PVector o = new PVector(10, height-70);
    PVector wid = new PVector(5, 50), hei = new PVector(50, -5);
    
    Ball b1 = new Ball(w, o.get()),
    b2 = new Ball(w, o.get());
    b2.p.add(wid);
    
    bs.add(b1);
    bs.add(b2);
    
    ls.add(new Line(b1, b2));
    
    for(int i=0;i<this.n;i++) {
      Ball b3 = new Ball(w, b1.p.get()),
      b4 = new Ball(w, b2.p.get());
      
      b3.p.add(hei);
      b4.p.add(hei);
      
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
    
    Ball cb = new Ball(w, hei.get());
    cb.p.mult(this.n*.5);
    cb.p.add(o);
    cb.p.add(PVector.mult(wid, .5));
    
    bs.add(cb);
    ls.add(new Line(cb, bs.get(0))); //, this.n*hei.x/2));
    l1 = get_l(len_l()-1).l;
    ls.add(new Line(cb, b1)); //, this.n*hei.x/2));
    l2 = get_l(len_l()-1).l;
    
  }
  
  void change_l() {
    get_l(len_l()-1).l = l1*(d.pop()/2.0+.5);
    get_l(len_l()-2).l = l2*(d.pop()/2.0+.5);
  }
  
  Ball get_b(int i) {
   return bs.get(i);
  }
  
  Line get_l(int i) {
   return ls.get(i);
  }
  
  int len_b() {
   return bs.size();
  }
  
  int len_l() {
   return ls.size();
  }
  
  PVector get_c() {
    PVector r = new PVector(0, 0);
    for(int i=0;i<len_b()-1;i++) {
      r.add(PVector.div(get_b(i).p, len_b()-1));
    }
    return r;
  }
  
  void update() {
    
    if(w.iden.count%10==0) {
      change_l();
    }
    
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

