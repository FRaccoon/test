
//long:0, speed;1

class Item {
  Game g;
  PVector p;
  float v, l;
  boolean t, b;
  int bc;
  int type;
  
  Item(Game g) {
    this.g = g;
    p = new PVector(0, 0);
    l = 0;
    t = false;
    b = false;
    bc = 0;
  }
  
  void set() {
    reset();
    p.x = width;
    p.y = height*(random(.8)+.1);
    l = 100*random(.6,1);
    v = random(2,5);
    t = true;
    type = (int)random(2);
    println(type);
  }
  
  void reset() {
    if(type==0)g.player.r = 20;
    else if(type==1)g.wave.t = .01;
    b = false;
  }
  
  void get() {
    if(t) {
      if(type==0) {
        if(random(1)<.4)g.player.r = 40;
        else if(random(1)<.6)g.player.r = 10;
        //else g.player.r = 20;
      }else if(type==1) {
        if(random(1)<.4)g.wave.t = .03;
        else if(random(1)<.6)g.wave.t = .005;
        //else g.wave.t = .01;
      }
      b = true;
      bc = g.count;
      
      g.score.life += 40;
      //g.score.bounus += 500;
      
      p.set(0, 0);
      l = 0;
      t = false;
    }
  }
  
  void update() {
    if(t) {
      p.x -= v;
      t = (p.x+l>0);
      
      if(p.x<g.o.x&&g.o.x<p.x+l) {
        if(g.player.p+g.player.r>p.y&&p.y>g.player.p-g.player.r)get();
      }
      
    }else {
      if(g.count%600==0&&!b)set();
    }
    if(b) {
      if(g.count>bc+300)reset();
    }
  }
  
  void draw() {
    if(t) {
      stroke(0,0,255);
      line(p.x, p.y, p.x+l, p.y);
    }
  }
  
}

