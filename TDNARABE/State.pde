
class State {
  Game g;
  
  int state; // 0:start, 1:main, 2:win, 3:lose
  int c;
  
  State(Game g) {
    this.g = g;
    
    this.state = 0;
    c=0;
  }
  
  void update() {
    g.dp.cam_update();
  }
  
  void mre() {
    switch(state) {
      case 0:
        g.dt.reset();
        state=1;
      break;
      case 1:
        if(g.dp.bd.inside()) {
          if(g.dp.bd.mre(c%2+1))c++;
        }
      break;
      case 2:
        state=0;
      break;
      case 3:
        state=0;
      break;
      default:
        
      break;
    }
  }
  
}