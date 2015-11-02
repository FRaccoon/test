
class Disp {
  Game g;
  
  Box b; // area
  PGraphics pg;
  PVector eye, ct, up; // camera
  float len;
  
  Disp(Game g, int w, int h) {
    this.g = g;
    
    b = new Box(0, 0, w, h);
    pg = createGraphics(b.s.x, b.s.y, P3D);
    
    len = 100;
    
    set_cam();
  }
  
  void set_cam() {
    eye = new PVector(PI/6, len*g.dt.n*1.5, len*g.dt.n*.5); // theta, len, high
    ct = new PVector(0, 0, 0);
    up = new PVector(0, 0, -1);
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
    
    for(int i=0;i<g.dt.n;i++) {
      for(int j=0;j<g.dt.n;j++) {
        for(int k=0;k<g.dt.h[i][j];k++) {
          int t=g.dt.get(i,j,k);
          if(t==0) {
            continue;
          }else if(t==1) {
            pg.stroke(0);
            pg.fill(255);
          }else if(t==2) {
            pg.stroke(255);
            pg.fill(0);
          }
          this.dp((i+(1-g.dt.n)*.5)*len, (j+(1-g.dt.n)*.5)*len, (k+.5)*len*.5, TWO_PI/12);
        }
      }
    }
    
    pg.endDraw();
  }
  
  void dl(int l) { // draw_line(direction)
    pg.stroke(255,0,0);
    pg.line(0,0,0,l,0,0);
    pg.stroke(0,255,0);
    pg.line(0,0,0,0,l,0);
    pg.stroke(0,0,255);
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
    pg.stroke(0);
    pg.fill(192,192,0);
    float l=len*g.dt.n*.5;
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