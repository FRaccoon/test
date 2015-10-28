
class Game {
  int[][] a;
  boolean[][] b;
  IV o, s;
  Box t; // this
  int nb, l; // number of bomb, length of cell
  int nf;
  
  int st; // 0:start, 1:main, 2:clear, 3:over
  
  PImage bg;
  int wc;
  
  Game(int x, int y, int nb, int l) {
    t = new Box(new IV(0, 0), new IV(width, height));
    o = new IV(10, 10);
    s = new IV(x, y);
    this.nb = nb;
    this.l = l;
    st=0;
    bg = loadImage("./data/bg.jpg");
    bg.resize(t.s.x, t.s.y);
    wc=0;
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
    nf=0;
  }
  
  //void update() {}
  
  void draw() {
    textAlign(CENTER, CENTER);
    switch(this.st) {
      case 0:
        noStroke();
        fill(192);
        t.draw();
        textSize(36);
        fill(255,0,0);
        text("press mouse button to start.", 
        t.p.x+t.s.x/2, t.p.y+t.s.y/2);
      break;
      case 1:
        this.draw_map();
      break;
      case 2:
        this.draw_map();
        noStroke();
        fill(255, 128);
        t.draw();
        textSize(36);
        fill(255,0,0);
        text("game claer!", 
        t.p.x+t.s.x/2, t.p.y+t.s.y/2);
      break;
      case 3:
        this.draw_map();
        noStroke();
        fill(255, 128);
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
    if(wc!=3)image(bg, t.p.x, t.p.y);
    for(int i=0;i<s.x;i++) {
      for(int j=0;j<s.y;j++) {
        
        if(a[i][j]<0) {
          stroke(0);
          fill(255);
        }else {
          if(wc==2)noStroke();
          else stroke(0);
          noFill();
        }
        rect(o.x+(i+.02)*l, o.y+(j+.02)*l, l*.96, l*.96);
        
        if((st==2 || st==3 || wc==4) && b[i][j]) {
          noStroke();
          fill(255, 0, 0);
          ellipse(o.x+(i+.5)*l, o.y+(j+.5)*l, l*.7, l*.7);
        }
        
        if(a[i][j]>0) {
          textSize(l-2);
          switch(wc) {
            case 1:fill(255);break;
            case 4:fill(0,0,255);break;
            default:fill(0);break;
          }
          if(wc!=2)text(a[i][j]+"" ,
          o.x+(i+.5)*l, o.y+(j+.5)*l);
        }else if(a[i][j]==-2) {
          textSize(l-2);
          fill(0);
          text("F", o.x+(i+.5)*l, o.y+(j+.5)*l);
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
            if(a[mx][my]==-1) {
              a[mx][my]=-2;
              nf++;
              println(nb-nf);
            }else if(a[mx][my]==-2) {
              a[mx][my]=-1;
              nf--;
            }else if(a[mx][my]>0){
              this.ab(mx, my, 2);
            }
          break;
        }
      break;
      case 2:st=0;break;
      case 3:st=0;break;
      default:break;
    }
  }
  
  void keyReleased() {
    switch(this.st) {
      case 0:
        this.random_set();
        st=1;
      break;
      case 1:
      switch(key) {
        case 'a':wc=0;break;
        case 's':wc=1;break;
        case 'd':wc=2;break;
        case 'f':wc=3;break;
        case 'q':wc=4;break;
      }
      break;
      case 2:st=0;break;
      case 3:st=0;break;
      default:break;
    }
  }
  
  void open(int px, int py) {
    if(a[px][py]!=-1)return ;
    if(b[px][py]) {
      a[px][py] = 0;
      st=3;
      return ;
    }
    
    this.ab(px, py, 0);
    if(a[px][py]>0)return;
    this.ab(px, py, 1);
  }
  
  void ab(int i, int j,int type) {
    int n=0;
    for(int k=0;k<9;k++) {
      int rx = i+(k%3-1), ry = j+(int(k/3)-1);
      if((rx<0 || !(rx<s.x)) || (ry<0 || !(ry<s.y)))continue;
      switch(type) {
        case 0:
          if(b[rx][ry])n++;
        break;
        case 1:
          this.open(rx, ry);
        break;
        case 2:
          if(a[rx][ry]==-2)n++;
        break;
        case 3:
          if(a[rx][ry]==-1)this.open(rx, ry);
        break;
      }
    }
    switch(type) {
      case 0:a[i][j]=n;break;
      case 2:
      if(a[i][j]==n)ab(i, j, 3);
      break;
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