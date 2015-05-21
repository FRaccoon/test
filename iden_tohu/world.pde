
class World {
  PVector g;
  int w, h;
  Cam c;
  
  Iden iden;
  
  World() {
    g = new PVector(0, .15);
    w = width;h = height;
    c = new Cam();
    
    iden = new Iden(this, 20, 14, "save.txt");
    
  }
  
  void update() {
    for(int i=0;i<1;i++) {
      iden.update();
    }
  }
  
  void draw() {
    
    c.cam();
    
    stroke(255, 0, 0);line(-50000, h, 0, 50000, h, 0);
    stroke(0, 255, 0);line(0, h+50000, 0, 0, h-50000, 0);
    stroke(0, 0, 255);line(0, h, 50000, 0, h, -50000);
    //stroke(255);noFill();rect(0, 0, w, h);
    
    iden.draw();
    
  }
  
  void keyPressed() {
    c.keyPressed();
  }
  
  void keyReleased() {
    if(keyCode==CODED) {
      switch(key) {
        case 'p':
          this.save();
        break;
      }
    }
  }
  
  void save() {
    String[] str = new String[iden.d.length*2];
    for(int i=0;i<iden.d.length;i++) {
      str[2*i] = "";
      str[2*i+1] = iden.d[i].output();
    }
    str[0] = ""+iden.g;
    saveStrings("save.txt", str);
  }
  
}

