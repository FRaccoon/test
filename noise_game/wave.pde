
class Wave {
  Game g;
  float l, t, p;
  int n;
  
  Wave(Game g, int n) {
    this.g = g;
    l = height*.45;
    p = .95*width/(n+1);
    t = .01;
    this.n = n;
  }
  
  float pos(int i) {
    return g.o.y+l*ns(i);
  }
  
  float ns(int i) {
    return noise((g.count+i)*t)*2-1;
  }
  
  void update() {}
  
  void draw() {
    stroke(255);
    for(int i=0;i<n;i++) {
      line(g.o.x+i*p, pos(i), g.o.x+(i+1)*p, pos(i+1));
    }
    
  }
  
}

