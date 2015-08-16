
class Player {
  Game g;
  float p, r;
  
  Player(Game g) {
    this.g = g;
    p = height/2;
    r = 20;
  }
  
  void update() {
    //if(g.keys.ku)p-=3.6;
    //if(g.keys.kd)p+=3.6;
    
    p = mouseY;
    
    if(p+r<g.wave.pos(0)||p-r>g.wave.pos(0))g.score.life--;
  }
  
  void draw(){
    stroke(255,0,0);
    line(g.o.x, p-r, g.o.x, p+r);
  }
  
}

