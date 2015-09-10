
class Gui extends Box {
  MEditer e;
  
  GButton[] bs;
  String[] ct = {"import", "layer1", "layer2", "layer3", "mask", "save", "fill", "pen", "eraser", ""};
  
  Gui(MEditer e) {
    this.e = e;
    
    p = new IVector(0, 0);
    s = new IVector(width-160, 52);
    
    bs = new GButton[ct.length-1];
    
    bs[0] = new GButton(this, ct.length-1, 6, 6);
    for(int i=1;i<bs.length;i++) {
      bs[i] = new GButton(this, i, bs[i-1].p.x+bs[i-1].s.x, 29);
    }
    bs[0].set_t(0);
  }
  
  void update() {
  }
  
  void draw(){
    for(int i=0;i<bs.length;i++) {
      bs[i].draw();
    }
    if(e.d)area();
  }
  
  boolean press_event(int mx, int my) {
    if(!this.inside(mx, my))return false;
    
    for(int i=0;i<bs.length;i++) {
      if(bs[i].press_event(mx, my))break;
    }
    return true;
  }
  
  /*void Scrollbar(int x, int y, int widthScrollbar, float part) {
     fill(0);
     triangle(x+4, y+2, x+12, y+2, x+8, y+(sqrt(3)*5)+2);
     triangle(x+4, y+widthScrollbar-2, x+12, y+widthScrollbar-2, x+8, y-(sqrt(3)*5)+widthScrollbar-2);
  }*/
  
}

class GButton extends Box { // Gui_Button
  Gui g;
  int t; // type
  int cs;
  boolean pr; // pressed
  
  GButton(Gui g, int t, int px, int py) {
    this.g = g;
    
    this.t = t;
    p = new IVector(px, py);
    s = new IVector(0, 0);
    set_cs(12);
    
    pr = false;
    
  }
  
  int px(int px) {return g.px(px) - p.x;}
  int py(int py) {return g.py(py) - p.y;}
  
  int cx(int cx) {return g.cx(cx + p.x);}
  int cy(int cy) {return g.cy(cy + p.y);}
  
  void draw() {
    if(pr) {
      tint(0, 255, 0);
      pr = false;
    }else if(this.selected())tint(255, 0, 0);
    image(g.e.bt_img, cx(0), cy(0), s.x, s.y);
    noTint();
    
    textAlign(CENTER, CENTER);
    textSize(cs);
    fill(0);
    text(g.ct[t], cx(0)+s.x*.5, cy(0)+s.y*.5);
    
    if(g.e.d)area();
  }
  
  void set_t(int t) {
    this.t = t;
    s.x = (this.cs/3*2+2)*g.ct[this.t].length();
  }
  
  void set_cs(int cs) {
    this.cs = cs;
    s.x = (this.cs/3*2+2)*g.ct[t].length();
    s.y = this.cs+5;
  }
  
  boolean selected() {
    boolean r = false;
    switch(t) {
      case 1:case 2:case 3: // layer1~3
      r=(g.e.ml.ls.et && g.e.ml.ls.now==t-1);break; // g.e.ml.get_layer(t).disp
      case 4:r=!g.e.ml.ls.et;break; // mask
      case 7:r=g.e.ml.ls.tt;break; // pen
      case 8:r=!g.e.ml.ls.tt;break; // eraser
      default:/*r=inside(mouseX, mouseY);*/break; // import, save, fill
    }
    return r;
  }
  
  boolean press_event(int mx, int my) {
    if(!this.inside(mx, my))return false;
    pr = true;
    
    switch(t) {
      case 0:g.e.ml.ls.imp();break; // import
      case 1:case 2:case 3: // layer1~3
      g.e.ml.ls.et=true;g.e.ml.ls.now=t-1;break;
      case 4:g.e.ml.ls.et=false;break; // mask
      case 5:g.e.ml.ls.save();break; // save
      case 6:g.e.ml.ls.fill_layer();break; // fill
      case 7:g.e.ml.ls.tt=true;break; // pen
      case 8:g.e.ml.ls.tt=false;break; // eraser
      default:break;
    }
    
    return true;
  }
  
}