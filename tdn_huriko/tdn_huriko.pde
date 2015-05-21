
Huriko h;

void setup() {
  size(800, 600);
  
  h = new Huriko(5);
  
}

void draw() {
  background(0);
  
  h.update();
  h.draw();
}

class Huriko {
  PVector g;
  
  int n;
  Ball[] bs;
  
  Vec[] m;
  Vec v, alp;
    
  Huriko(int n_) {
    g = new PVector(0, .6);
    
    n = ( n_<2 ? 2 : n_ );
    
    bs = new Ball[n+1];
    bs[0] = new Ball(new PVector(width/2, 5));
    
    PVector p = new PVector(-70, 5);
    for(int i=0;i<n;i++) {
      bs[i+1] = new Ball(PVector.add(bs[i].p, p), p.mag());
    }
    
    m = new Vec[3];
    m[0] = new Vec(n);m[1] = new Vec(n);m[2] = new Vec(n);
    v = new Vec(n);
    alp = new Vec(n);
  }
  
  Ball get(int i) {
   //if(!(0>i) && i<bs.length)
   return bs[i];
  }
  
  void setM() {
    PVector pd, nd, fd;
    pd = PVector.sub(get(1).p, get(0).p);
    nd = PVector.sub(get(2).p, get(1).p);
    fd = PVector.sub(get(3).p, get(2).p);
    
    m[0].set(0, 0);
    m[1].set(0, -pd.magSq()/get(1).m);
    m[2].set(0, nd.dot(pd)/get(1).m);
    
    for(int i=1;i<n-1;i++) {
      m[0].set(i, nd.dot(pd)/get(i-1).m);
      m[1].set(i, -nd.magSq()*(get(i).m+get(i-1).m)/(get(i).m*get(i-1).m));
      m[2].set(i, pd.dot(nd)/get(i).m);
      
      pd.set(nd);
      nd.set(fd);
      fd = PVector.sub(get(i+1).p, get(i).p);
      
    }
    
    m[0].set(n-1, fd.dot(nd)/get(n-1).m);
    m[1].set(n-1, -fd.magSq()*(get(n).m+get(n-1).m)/(get(n).m*get(n-1).m));
    m[2].set(n-1, 0);
    
    v.set(0, -g.dot(PVector.sub(get(1).p, get(0).p)) 
    -get(1).v.magSq());
    for(int i=1;i<n;i++) {
      v.set(i, -(PVector.sub( get(i+1).v, get(i).v) ).magSq());
    }
    
  }
  
  void solM() {
    for(int i=0;i<n;i++) {
      if(0<i) {
        v.sub(i, v.get(i-1)*m[0].get(i));
        m[1].sub(i, m[2].get(i-1)*m[0].get(i));
        m[0].set(i, 0);
      }
      if(i<n-1)m[2].div(i, m[1].get(i));
      v.div(i, m[1].get(i));
      m[1].set(i, 1);
      
    }
    
    alp.set(n-1, v.get(n-1));
    for(int i=1;i<n;i++) {
      alp.set(n-1-i, v.get(n-1-i)-m[2].get(n-1-i)*alp.get(n-i));
    }
    
  }
  
  void calA() {
    PVector[] l = new PVector[n];
    l[0] = PVector.sub(get(1).p, get(0).p);
    PVector a;
    
    for(int i=0;i<n;i++) {
      a = PVector.mult(this.g, get(i+1).m);
      a.add(PVector.mult(l[i], -alp.get(i)));
      if(i<n-1) {
        l[i+1] = PVector.sub(get(i+2).p, get(i+1).p);
        a.add(PVector.mult(l[i+1], alp.get(i+1)));
      }
      a.div(get(i+1).m);
      get(i+1).a.set(a);
    }
  }
  
  void addA() {
    for(int i=0;i<n;i++) {
      get(i+1).update();
    }
  }
  
  void update() {
    if(bs.length<1)return ;
    else {
      this.setM();
      this.solM();
      this.calA();
      this.addA();
    }
  }
  
  void draw() {
    if(bs.length<1)return ;
    for(int i=1;i<bs.length;i++) {
      get(i).draw(get(i-1));
    }
    
  }
  
}

class Ball {
  PVector p = new PVector(0, 0),v = new PVector(0, 0),a = new PVector(0, 0);
  float m=10.0, l=50;
  
  Ball() {
  }
  
  Ball(PVector p) {
    this.p = p;
  }
  
  Ball(PVector p,  float l) {
    this.p = p;
    this.l = l;
  }
  
  /*Ball(PVector p, PVector v) {
    this.p = p;
    this.v = v;
  }*/
  
  Ball(PVector p, PVector v, float m, float l) {
    this.p = p;
    this.v = v;
    this.m = m;
    this.l = l;
  }
  
  void update() {
    //println(a);
    v.add(a);
    p.add(v);
    
  }
  
  void draw(Ball o) {
    stroke(255);
    line(o.p.x, o.p.y, p.x, p.y);
    noFill();
    ellipse(p.x, p.y, m*2, m*2);
  }
  
}

class Vec {
  float[] v;
  
  Vec(int n) {
    v = new float[n];
    
  }
  
  void reset() {
    for(int i=0;i<v.length;i++) {
      v[i] = 0;
    }
  }
  
  float get(int i) {
    //if(!(i<0) && i<v.length)
    return v[i];
  }
  
  void set(int i,float a) {
    //if(!(i<0) && i<v.length)
    v[i] = a;
  }
  
  void add(int i,float a) {
    //if(!(i<0) && i<v.length)
    v[i] += a;
  }
  
  void sub(int i,float a) {
    //if(!(i<0) && i<v.length)
    v[i] -= a;
  }
  
  void mul(int i,float a) {
    //if(!(i<0) && i<v.length)
    v[i] *= a;
  }
  
  void div(int i,float a) {
    //if(!(i<0) && i<v.length)
    v[i] /= a;
  }
  
  int len() {
    return v.length;
  }
  
}



