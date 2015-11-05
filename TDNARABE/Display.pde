
class Disp {
  Game g;
  
  Box b; // area
  PGraphics pg;
  PVector eye, ct, up; // camera
  float len;
  
  Board bd;
  
  Disp(Game g, int w, int h) {
    this.g = g;
    
    b = new Box(0, 0, w, h);
    pg = createGraphics(b.s.x, b.s.y, P3D);
    
    len = 100;
    
    bd = new Board(this, w-150, h-150, 30, 20, 10);
    
    set_cam();
  }
  
  void set_cam() {
    eye = new PVector(PI/6, len*g.n()*1.5, len*g.n()*.5); // theta, len, high
    ct = new PVector(0, 0, 0);
    up = new PVector(0, 0,-1);
  }
  
  void cam() {
    pg.camera(cos(eye.x)*eye.y, sin(eye.x)*eye.y, eye.z, ct.x, ct.y, ct.z, up.x, up.y, up.z);
  }
  
  void draw() {
    switch(g.st.state) {
      case 0:
        dstr("game start.");
      break;
      case 1:
        dbd();
        image(pg, b.p.x, b.p.y);
        bd.draw();
      break;
      case 2:
        dbd();
        image(pg, b.p.x, b.p.y);
        dstr("you win.");
      break;
      case 3:
        dbd();
        image(pg, b.p.x, b.p.y);
        dstr("you lose.");
      break;
      default:break;
    }
  }
  
  void dstr(String str) { //draw_string
    textSize(36);
    textAlign(CENTER, CENTER);
    noStroke();fill(255,0,0);
    text(str, b.p.x+b.s.x/2, b.p.y+b.s.y/2);
  }
  
  void dbd() { // draw_board
    pg.beginDraw();
    pg.background(0);
    this.cam();
    
    this.dl(1000);
    this.dg();
    
    for(int i=0;i<g.n();i++) {
      for(int j=0;j<g.n();j++) {
        for(int k=0;k<g.dt.get_h(i, j);k++) {
          int t=g.dt.get(i,j,k);
          if(t==0) {
            continue;
          }else if(t==1) {
            pg.stroke(255);
            pg.fill(255);
          }else if(t==2) {
            pg.stroke(0);
            pg.fill(0);
          }
          this.dp((i+(1-g.n())*.5)*len, (j+(1-g.n())*.5)*len, (k+.5)*len*.5, TWO_PI/12);
        }
      }
    }
    
    pg.endDraw();
  }
  
  void dl(int l) { // draw_line(direction)
    pg.stroke(255, 0, 0);
    pg.line(0,0,0,l,0,0);
    pg.stroke(0, 255, 0);
    pg.line(0,0,0,0,l,0);
    pg.stroke(0, 0, 255);
    pg.line(0,0,0,0,0,l);
  }
  
  void dp(float x, float y, float z, float p) { // draw_piece
    float r = len*.4, h = len*.25;
    pg.beginShape(TRIANGLE_FAN);
    pg.vertex(x, y, z+h);
    for(float i=0;i<TWO_PI;i+=p) {
      pg.vertex(x+r*cos(i), y+r*sin(i), z);
    }
    pg.endShape();
    pg.beginShape(TRIANGLE_FAN);
    pg.vertex(x, y, z-h);
    for(float i=0;i<TWO_PI;i+=p) {
      pg.vertex(x+r*cos(i), y+r*sin(i), z);
    }
    pg.endShape();
  }
  
  void dg() { // draw_ground
    pg.noStroke();
    pg.fill(192,192,0);
    float l=len*g.n()*.5;
    pg.beginShape(TRIANGLE_FAN);
    pg.vertex( l, l, 0);
    pg.vertex( l,-l, 0);
    pg.vertex(-l,-l, 0);
    pg.vertex(-l, l, 0);
    pg.endShape(CLOSE);
    
  }
  
  void cam_update() {
    if(g.in.ip('a'))eye.x += .03;
    if(g.in.ip('d'))eye.x -= .03;
    
    if(g.in.ip('s'))eye.y += 12;
    if(g.in.ip('w'))eye.y -= 12;
    
    if(g.in.ip('q'))eye.z += 12;
    if(g.in.ip('e'))eye.z -= 12;
  }
  
}

class Board {
  Disp d;
  Box b;
  int r, l, s;
  
  Board(Disp d, int px, int py, int l, int s, int r) {
    this.d = d;
    this.l = l;
    this.r = min(r, this.l/2);
    this.s = max(s, this.r);
    b = new Box(px, py, (d.g.n()-1)*l+2*s, (d.g.n()-1)*l+2*s);
    b.o = d.b;
  }
  
  boolean inside() {
    return b.inside(mouseX, mouseY);
  }
  
  boolean mre(int c) {
    int n=d.g.n(), mx = b.ix(mouseX-s+r), my = b.iy(mouseY-s+r);
    if(mx<0 || my<0 || mx>=n*l || my>=n*l)return false;
    int cx=mx/l, cy=my/l;
    if(mx-cx*l>2*r || mx-cx*l>2*r)return false;
    if(dist(cx*l+r, cy*l+r, mx, my)>r)return false;
    println(cx+", "+cy);
    if(d.g.dt.add(cx, cy, c)) {
      if(d.g.dt.check(cx, cy))d.g.st.state=2;
      return true;
    }else {
      println("you can't put there.");
      return false;
    }
  }
  
  void draw() {
    stroke(255);
    fill(192,192,0);
    b.draw();
    
    stroke(0);
    for(int i=0;i<d.g.n();i++) {
      line(b.ox(s), b.oy(i*l+s), 
      b.ox(b.s.y-s), b.oy(i*l+s));
    }
    
    for(int i=0;i<d.g.n();i++) {
      line(b.ox(i*l+s), b.oy(s), 
      b.ox(i*l+s), b.oy(b.s.y-s));
    }
    
    for(int i=0;i<d.g.n();i++) {
      for(int j=0;j<d.g.n();j++) {
        int h = d.g.dt.get_h(i,j)-1;
        if(h<0)fill(128);
        else if(d.g.dt.get(i,j,h)==1)fill(255);
        else if(d.g.dt.get(i,j,h)==2)fill(0);
        ellipse(b.ox(i*l+s), b.oy(j*l+s), 2*r, 2*r);
      }
    }
  }
  
}