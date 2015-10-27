
class Game {
  int[][] a;
  boolean[][] b;
  IV o, s;
  Box t; // this
  int nb, l; // number of bomb, length of cell
  
  int st; // 0:start, 1:main, 2:clear, 3:over
  
  Game(int x, int y, int nb, int l) {
    t = new Box(new IV(0, 0), new IV(width, height));
    o = new IV(10, 10);
    s = new IV(x, y);
    this.nb = nb;
    this.l = l;
    st=0;
  }
  
  void random_set() {
    a = new int[s.x][s.y];
    b = new boolean[s.x][s.y];
    
    for(int i=0;i<s.x;i++) {
       for(int j=0;j<s.y;j++) {
         a[i][j] = -1; // not opened
       }
    }
    
    for(int i=0;i<nb;i++) {
      int bx = (int)random(0, s.x),
      by = (int)random(0, s.y);
      if(b[bx][by]) {
        i--;
        continue;
      }
      b[bx][by] = true;
    }
    
  }
  
  void update() {
  }
  
  void draw() {
    textAlign(CENTER, CENTER);
    switch(this.st) {
      case 0:
        textSize(36);
        fill(255);
        text("press mouse button to start.", 
        t.p.x+t.s.x/2, t.p.y+t.s.y/2);
      break;
      case 1:
        this.draw_map();
      break;
      case 2:
        this.draw_map();
        noStroke();
        fill(192, 128);
        t.draw();
        textSize(36);
        fill(255,0,0);
        text("game claer!", 
        t.p.x+t.s.x/2, t.p.y+t.s.y/2);
      break;
      case 3:
        this.draw_map();
        noStroke();
        fill(192, 128);
        t.draw();
        textSize(36);
        fill(255,0,0);
        text("game over.", 
        t.p.x+t.s.x/2, t.p.y+t.s.y/2);
      break;
      default:break;
    }
    
  }
  
  void draw_map() {
    for(int i=0;i<s.x;i++) {
      for(int j=0;j<s.y;j++) {
        
        if(a[i][j]<0) {
          stroke(0);
          fill(255);
        }else {
          stroke(0);
          fill(192);
        }
        rect(o.x+(i+.02)*l, o.y+(j+.02)*l, l*.96, l*.96);
        
        if(a[i][j]>0) {
          textSize(l-2);
          fill(0);
          text(a[i][j]+"" ,
          o.x+(i+.5)*l, o.y+(j+.5)*l);
        }else if(a[i][j]==-2) {
          textSize(l-2);
          fill(0);
          text("F", o.x+(i+.5)*l, o.y+(j+.5)*l);
        }
        
        if(st!=1 && b[i][j]) {
          noStroke();
          fill(255, 0, 0);
          ellipse(o.x+(i+.5)*l, o.y+(j+.5)*l, l*.7, l*.7);
        }
        
      }
    }
  }
  
  void mouseReleased() {
    if((mouseX<o.x || !(mouseX<o.x+s.x*l)) || 
    (mouseY<o.y || !(mouseY<o.y+s.y*l)))return ;
    
    int mx = (mouseX-o.x)/l, my = (mouseY-o.y)/l;
    switch(this.st) {
      case 0:
        this.random_set();
        st=1;
      break;
      case 1:
        switch(mouseButton) {
          case LEFT:
            this.open(mx, my);
            this.isclear();
          break;
          case RIGHT:
            if(a[mx][my]==-1)a[mx][my]=-2;
            else if(a[mx][my]==-2)a[mx][my]=-1;
          break;
        }
      break;
      case 2:st=0;break;
      case 3:st=0;break;
      default:break;
    }
    if(st==1) {
    }
  }
  
  void keyReleased() {
    switch(this.st) {
      case 0:
        this.random_set();
        st=1;
      break;
      case 1:break;
      case 2:st=0;break;
      case 3:st=0;break;
      default:break;
    }
  }
  
  void open(int px, int py) {
    if(!(a[px][py]<0) || a[px][py]==-2)return ;
    a[px][py]=0;
    if(b[px][py]) {
      st=3;
      return ;
    }
    
    for(int k=0;k<9;k++) {
      int rx = px+(k%3-1), ry = py+(int(k/3)-1);
      if((rx<0 || !(rx<s.x)) || (ry<0 || !(ry<s.y)))continue;
      if(b[rx][ry])a[px][py]++;
    }
    
    if(a[px][py]>0)return;
    
    for(int k=0;k<9;k++) {
      int rx = px+(k%3-1), ry = py+(int(k/3)-1);
      if((rx<0 || !(rx<s.x)) || (ry<0 || !(ry<s.y)))continue;
      this.open(rx, ry);
    }
    
  }
  
  void isclear() {
    if(st!=1)return ;
    int c=0;
    for(int i=0;i<s.x;i++) {
       for(int j=0;j<s.y;j++) {
         if(a[i][j]<0)c++;
       }
    }
    if(c<=nb)st=2;
  }
  
}