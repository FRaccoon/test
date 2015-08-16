
class Gui {
  Editer e;
  
  PImage bt_img;
  Button[] bs;
  
  Gui(Editer e) {
    this.e = e;
    bt_img = loadImage("btn057_10.png");
    
    bs = new Button[9];
    
    bs[0] = new Button(this, "", 5, 5);
    String[] str = {"layer1", "layer2", "layer3", "mask", "save", "all", "pen", "eraser"};
    for(int i=1;i<str.length+1;i++) {
      bs[i] = new Button(this, str[i-1], bs[i-1].p.x+bs[i-1].s.x, 30);
    }
    bs[0].set_ct("import");
  }
  
  void draw(){
    for(int i=0;i<bs.length;i++) {
      bs[i].draw();
    }
    
  }
  
  void Scrollbar(int x, int y, int widthScrollbar, float part) {
     fill(0);
     triangle(x+4, y+2, x+12, y+2, x+8, y+(sqrt(3)*5)+2);
     triangle(x+4, y+widthScrollbar-2, x+12, y+widthScrollbar-2, x+8, y-(sqrt(3)*5)+widthScrollbar-2);
  }
  
}

