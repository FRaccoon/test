
class MapLayer extends Box {
  Editer e;
  
  Layers ls;
  //LButton[] lb;
  
  int n;
  int now;
  
  Layer chip;
  boolean mt; // mask_tool true: pen(black), false: eraser(white)
  
  MapLayer(Editer e) {
    this.e = e;
    
    p = new IVector(0, 55);
    s = new IVector(width-160, height-52);
    
    this.n = 3;
    this.now = 1;
    
    ls = new Layers(this, layer_size()); // set m.x, m.y
    //lb = new LButton[n];
    
    mt = true;
    
    chip = new Layer(this.e, new IVector(1, 1));
    chip.paint(e.sb.ec.get(0,0,e.c,e.c), 0, 0);
    
  }
  
  void draw() {
    ls.draw();
    
    if(e.d)area();
  }
  
  void update() {
    if(ls.update())return ;
    
  }
  
  IVector layer_size() { //このクラスはjavaで作られてます
    JPanel panel = new JPanel();
    panel.setPreferredSize(new Dimension(150, 60));
    panel.setLayout(null);
  
    JTextField text1 = new JTextField();
    panel.add(new JLabel("X"));
    text1.setBounds(10, 10, 60, 30);
    panel.add(text1);
    
    JTextField text2 = new JTextField();
    panel.add(new JLabel("Y"));
    text2.setBounds(80, 10, 60, 30);
    panel.add(text2);
    
    JOptionPane.showConfirmDialog( null, panel, "layer size", JOptionPane.OK_CANCEL_OPTION, JOptionPane.QUESTION_MESSAGE );
    
    int gX = 0, gY = 0;
    try{
      gX = int(text1.getText());
      gY = int(text2.getText());
    }catch(NumberFormatException e){
    }catch(NullPointerException e){
    }
    
    return new IVector(gX==0?40:gX, gY==0?40:gY);
    
  }
  
}

class Layers extends Box {
  MapLayer ml;
  
  Layer bg_img;
  
  IVector m; // map_size
  IVector c; // canvas_size
  IVector a; // (a.x, a.y) = (0, 0)
  
  Layer[] ls;
  Layer mask;
  
  Layers(MapLayer ml, IVector m) {
    this.ml = ml;
    
    p = new IVector(5, 5);
    c = new IVector(34, 25);
    s = new IVector(c.x*ml.e.c, c.y*ml.e.c);
    
    this.m = m;
    a = new IVector(0, 0);
    
    ls = new Layer[ml.n];
    for(int i=0;i<ml.n;i++) {
      ls[i] = new Layer(this.ml.e, m);
    }
    
    bg_img = new Layer(this.ml.e, c);
    bg_img.fill_paint(loadImage("./data/bg_img.png"));
    
    mask = new Layer(this.ml.e, m);
    mask.fill_color(color(255));
    
  }
  
  int px(int px) {return ml.px(px) - p.x;}
  int py(int py) {return ml.py(py) - p.y;}
  
  int cx(int cx) {return ml.cx(cx + p.x);}
  int cy(int cy) {return ml.cy(cy + p.y);}
  
  int mx(int px) {return (px(px)/ml.e.c)+a.x;}
  int my(int py) {return (py(py)/ml.e.c)+a.y;}
  
  void draw() {
   bg_img.draw((Box)this);
    if(ml.now==0) {
      mask.draw((Box)this, a);
    }else {
      for(int i=0;i<ml.now;i++){
        ls[i].draw((Box)this, a);
      }
    }
    
    if(inside(mouseX, mouseY)){
      fill(0, 204, 255, 100);
      rect((mx(mouseX)-a.x)*ml.e.c+cx(0), (my(mouseY)-a.y)*ml.e.c+cy(0), ml.e.c, ml.e.c);
      
      if(ml.e.d) {
        textAlign(RIGHT, TOP);textSize(12);fill(255);
        text("X: "+mx(mouseX)+" Y: "+my(mouseY), cx(s.x), cy(s.y));
      }
    }
    
    if(ml.e.d)area();
  }
  
  boolean update() {
    if(!inside(mouseX, mouseY))return false;
    if((ml.e.i.ka || ml.e.i.kleft) && a.x>0)a.x--;
    if((ml.e.i.kw || ml.e.i.kup) && a.y>0)a.y--;
    if((ml.e.i.kd || ml.e.i.kright) && a.x<m.x-c.x)a.x++;
    if((ml.e.i.ks || ml.e.i.kdown) && a.y<m.y-c.y)a.y++;
    
    if(ml.e.i.md) { // edit
      // &&(get_px(mouseX)<m.x && get_py(mouseY)<m.y)
      if(ml.now==0)mask.paint_color(ml.mt?color(0):color(255), mx(mouseX)*ml.e.c, my(mouseY)*ml.e.c, ml.e.c, ml.e.c);
      else ls[ml.now-1].paint(ml.chip.l, mx(mouseX)*ml.e.c, my(mouseY)*ml.e.c);
    }
    
    return true;
  }
  
  void imp() { // import
    ls[(ml.now==0?1:ml.now)-1].paint(loadImage("./data/o/layer.png"), 0, 0);
    mask.paint(loadImage("./data/o/mask.png"), 0, 0);
  }
  
  void fill_layer(int num) {
    if(num==0)mask.fill_color(ml.mt?color(0):color(255));
    else ls[num-1].fill_paint(ml.chip.l);
  }
  
  void save() {
    if(!ml.e.alert("Do you want to save?"))return ;
    PGraphics sl = createGraphics(m.x*ml.e.c, m.y*ml.e.c); //save_layer
    sl.beginDraw();
    //sl.background(0);
    for(int i=0;i<ml.now;i++) {
      sl.image(ls[i].l, 0, 0);
    }
    sl.endDraw();
    
    sl.get().save("./data/o/layer.png");
    mask.l.get().save("./data/o/mask.png");
    //exit();
  }
  
}

class Layer {
  Editer e;
  PImage l;
  
  Layer(Editer e, IVector s) {
    this.e = e;
    l = createImage(s.x*e.c, s.y*e.c, ARGB);
  }
  
  void draw(Box b) {
    image(l.get(0, 0, min(l.width, b.s.x), min(l.height, b.s.y)), b.cx(0), b.cy(0));
  }
  
  void draw(Box b, IVector a) {
    image(
    l.get(a.x*e.c, a.y*e.c, 
    min(l.width-a.x*e.c, b.s.x), 
    min(l.height-a.y*e.c, b.s.y)), 
    b.cx(0), b.cy(0));
  }
  
  void paint(PImage mat, int sx, int sy) {
    l.loadPixels();
    mat.loadPixels();
    for(int i=max(0, -sx);i<mat.width&&i+sx<l.width;i++) {
      for(int j=max(0, -sy);j<mat.height&&j+sy<l.height;j++) {
        l.pixels[(i+sx)+(j+sy)*l.width] = 
        mat.pixels[i+j*mat.width];
      }
    }
    l.updatePixels();
    mat.updatePixels();
  }
  
  void fill_paint(PImage mat) { //塗りつぶし
    l.loadPixels();
    mat.loadPixels();
    for(int i=0;i<l.width;i++) {
      for(int j=0;j<l.height;j++) {
        l.pixels[i+j*l.width] = 
        mat.pixels[i%mat.width+(j%mat.height)*mat.width];
      }
    }
    l.updatePixels();
    mat.updatePixels();
    
  }
  
  void fill_color(color col) {
    l.loadPixels();
    for(int i=0;i<l.pixels.length;i++) {
        l.pixels[i] = col;
    }
    l.updatePixels();
  }
  
  void paint_color(color col, int sx, int sy, int ex, int ey) {
    l.loadPixels();
    for(int i=max(0, sx);i<min(sx+ex, l.width);i++) {
      for(int j=max(0, sy);j<min(sy+ey, l.height);j++) {
        l.pixels[i+j*l.width] = col;
      }
    }
    l.updatePixels();
  }
  
}

class LButton extends Box { // MapLayer_Button
  MapLayer ml;
  
  int n; // number
  int cs;
  boolean pr; // pressed
  
  LButton(MapLayer ml, int n, int px, int py) {
    this.ml = ml;
    
    this.n = n;
    p = new IVector(px, py);
    s = new IVector(0, 0);
    set_cs(12);
    
    pr = false;
    
  }
  
  int px(int px) {return ml.px(px) - p.x;}
  int py(int py) {return ml.py(py) - p.y;}
  
  int cx(int cx) {return ml.cx(cx + p.x);}
  int cy(int cy) {return ml.cy(cy + p.y);}
  
  void draw() {
    if(pr) {
      tint(0, 255, 0);
      pr = false;
    }else if(this.selected())tint(255, 0, 0);
    image(ml.e.bt_img, cx(0), cy(0), s.x, s.y);
    noTint();
    
    textAlign(CENTER, CENTER);
    textSize(cs);
    fill(0);
    text("layer"+n, cx(0)+s.x*.5, cy(0)+s.y*.5);
    
    if(ml.e.d)area();
  }
  
  void set_cs(int cs) {
    this.cs = cs;
    s.x = (this.cs/3*2+2)*("layer".length()+1);
    s.y = this.cs+5;
  }
  
  boolean selected() {
    boolean r = false;
    return r;
  }
  
  boolean press_event(int mx, int my) {
    if(!this.inside(mx, my))return false;
    pr = true;
    return true;
  }
  
}


