
class Ball {
  double m, l, t, vt, r;
  
  Ball(double m, double l, double t) {
    this.m = m;
    this.l = l;
    this.t = t;
    
    this.vt = 0;
    this.r = m/2;
    
  }
  
  void update(double at) {
    vt += at;
    t += vt;
    
  }
  
  PVector draw(PVector p) {
    PVector o = p.get();
    o.x += l*sin((float)t);
    o.y += l*cos((float)t);
    
    //strokeWeight(5);
    fill(255);
    stroke(255);
    
    line(p.x, p.y, o.x, o.y);
    ellipse(o.x, o.y, (float)r*2, (float)r*2);
    
    return o.get();
    
  }
  
}

