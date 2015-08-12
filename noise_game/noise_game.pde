
Game game;

void setup() {
  size(600, 400);
  
  game = new Game();
  
}

void draw() {
  game.update();
  game.draw();
}

void keyPressed() {
  game.keyPressed();
}

void keyReleased() {
  game.keyReleased();
}

class Game {
  PVector o;
  float p, r;
  int life, count, bounus;
  boolean ku, kd;
  Wave wave;
  Item item;
  
  Game() {
    o = new PVector(.05*width, height/2);
    
    wave = new Wave(this, 500);
    item = new Item(this);
    
    p = height/2;
    r = 20;
    life = 500;
    count = 0;
    bounus = 0;
    ku = false;
    kd = false;
    
    textAlign(LEFT,TOP);
    textSize(12);
  }
  
  void update() {
    wave.update();
    item.update();
    if(ku)p-=3.6;
    if(kd)p+=3.6;
    
    if(p+r<o.y+wave.l*wave.ns(0)||p-r>o.y+wave.l*wave.ns(0))life--;
    if(item.p.x<o.x&&o.x<item.p.x+item.l) {
      if(p+r>item.p.y&&item.p.y>p-r)item.get();
    }
    if(life<1)fin();
    
    count++;
  }
  
  void fin() {
      println("score : "+(count+5*life+bounus));
      exit();
  }
  
  void draw() {
    background(0);
    wave.draw();
    item.draw();
    stroke(255,0,0);
    line(o.x, p-r, o.x, p+r);
    text("life : "+life+"\nscore : "+(count+5*life+bounus), 3, 3);
  }
  
  void keyPressed(){
    if(key==CODED) {
      if(keyCode==UP)ku=true;
      else if(keyCode==DOWN)kd=true;
    }
  }
  
  void keyReleased(){
    if(key==CODED) {
      if(keyCode==UP)ku=false;
      else if(keyCode==DOWN)kd=false;
    }else {
      if(key=='q')fin();
    }
    
  }
  
}

class Item {
  Game g;
  PVector p;
  float v, l;
  boolean t, b;
  int bc;
  
  Item(Game g) {
    this.g = g;
    p = new PVector(0, 0);
    l = 0;
    t = false;
    b = false;
    bc = 0;
  }
  
  void set() {
    p.x = width;
    p.y = height*(random(.8)+.1);
    l = 100*random(.6,1);
    v = random(2,5);
    t = true;
  }
  
  void get() {
    if(t) {
      if(random(1)<.4)g.r = 40;
      else if(random(1)<.4)g.r = 10;
      else g.r = 20;
      b = true;
      bc = g.count;
      
      g.bounus += 500;
      
      p.set(0, 0);
      l = 0;
      t = false;
    }
  }
  
  void update() {
    if(t) {
      p.x -= v;
      t = (p.x+l>0);
    }else {
      if(g.count%500==0)set();
    }
    if(b) {
      if(g.count>bc+300) {
        g.r = 20;
        b = false;
      }
    }
  }
  
  void draw() {
    if(t) {
      stroke(0,0,255);
      line(p.x, p.y, p.x+l, p.y);
    }
  }
  
}

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
  
  float ns(int i) {
    return noise((g.count+i)*t)*2-1;
  }
  
  void update() {
  }
  
  void draw() {
    stroke(255);
    for(int i=0;i<n;i++) {
      line(g.o.x+i*p, g.o.y+l*ns(i), g.o.x+(i+1)*p, g.o.y+l*ns(i+1));
    }
    
  }
  
}
