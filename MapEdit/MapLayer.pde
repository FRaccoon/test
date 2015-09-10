
class MapLayer extends Box {
  MEditer e;
  IVector bp;
  int n;
  
  Layers ls;
  ArrayList<LButton> lb;
  
  MapLayer(MEditer e) {
    this.e = e;
    
    p = new IVector(0, 29);
    s = new IVector(width-160, height-52);
    
    n = 0;
    ls = new Layers(this, layer_size()); // set m.x, m.y
    lb = new ArrayList<LButton>();
    bp = new IVector(6, 0);
    for(int i=0;i<3;i++) {
      add_layer();
    }
    
  }
  
  void add_layer() {
    Layer l = new Layer(ls);
    LButton b = new LButton(this, l, bp);
    
    ls.ls.add(l);
    lb.add(b);
    
    bp.x += b.s.x;
    n++;
  }
  
  void remove_layer(int i) {
    if(i<0 || !(i<n))return ;
    LButton b = lb.get(i);
    Layer l = b.l;
    
    ls.ls.remove(l);
    lb.remove(b);
    
    n--;
    
  }
  
  void draw() {
    for(int i=0;i<n;i++) {
      lb.get(i).draw();
    }
    ls.draw();
    
    if(e.d)area();
  }
  
  void update() {
    if(ls.update())return ;
  }
  
  boolean press_event(int mx, int my) {
    if(!this.inside(mx, my))return false;
    if(ls.inside(mx, my))return true;
    
    for(int i=0;i<n;i++) {
      if(lb.get(i).press_event(mx, my))break;
    }
    return true;
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
    
    return new IVector(gX==0?50:gX, gY==0?50:gY);
    
  }
  
}

class Layers extends Box {
  MapLayer ml;
  
  IVector cs; // canvas_size (chip)
  IVector a; // (a.x, a.y) = (0, 0)
  
  ArrayList<Layer> ls;
  
  int now;
  
  Layer chip;
  PImage mat;
  
  boolean et, tt; //  eidt_type: true: layer, false: mask; tool_type true: pen(white), false: eraser(black)
  
  EImage bg_img;
  EImage mask;
  
  int ss; // scroll_speed
  IVector ms; // margin_size
  
  Layers(MapLayer ml, IVector cs) {
    this.ml = ml;
    
    p = new IVector(6, 23);
    this.cs = cs;
    s = new IVector(34*ml.e.c, 25*ml.e.c);
    
    a = new IVector(0, 0);
    
    et = true;
    tt = true;
    
    ls = new ArrayList<Layer>();
    this.now=0;
    
    chip = new Layer(this, new IVector(1, 1));
    set_chip(new IVector(0, 0), new IVector(1, 1));
    
    bg_img = new EImage();
    bg_img.set_size(this.s);
    bg_img.fill_pimg(loadImage("./data/bg_img.png"));
    
    mask = new EImage();
    mask.set_size(this.cs.get().mult(ml.e.c));
    mask.fill_color(color(0));
    
    ss = 10;
    ms = new IVector(2*s.x/3, 2*s.y/3);
    
  }
  
  int px(int px) {return ml.px(px) - p.x;}
  int py(int py) {return ml.py(py) - p.y;}
  
  int cx(int cx) {return ml.cx(cx + p.x);}
  int cy(int cy) {return ml.cy(cy + p.y);}
  
  int mx(int px) {return (px(px-(chip.cs.x-1)*ml.e.c/2+a.x)/ml.e.c);}
  int my(int py) {return (py(py-(chip.cs.y-1)*ml.e.c/2+a.y)/ml.e.c);}
  
  IVector mp(int px, int py) {return new IVector(mx(px), my(py));}
  
  Layer get_layer(int i) {
    if(!(i<0) && i<ls.size())return ls.get(i);
    else return null;
  }
  
  void set_chip(IVector ps, IVector s) {
    chip.cs = s;
    chip.reset();
    for(int i=0;i<s.x;i++) {
      for(int j=0;j<s.y;j++) {
        chip.t[i][j] = ps.x+i+ml.e.sb.w*(ps.y+j);
      }
    }
    chip.paint_pimg(ml.e.sb.ec.l.get(ps.x*ml.e.c, ps.y*ml.e.c, s.x*ml.e.c, s.y*ml.e.c), new IVector(0, 0));
  }
  
  void draw() {
   bg_img.draw((Box)this);
    if(!et) {
      mask.draw((Box)this, a);
      tint(255, 100);
    }
    for(int i=0;i<ml.n;i++){
      if(get_layer(i).disp)get_layer(i).draw((Box)this, a);
    }
    noTint();
    
    noFill();stroke(0);
    rect(cx(-a.x), cy(-a.y), cs.x*ml.e.c, cs.y*ml.e.c);
    
    if(inside(mouseX, mouseY)){
      Box mc = new Box(); // mouse_cursor
      mc.p = new IVector(cx(mx(mouseX)*ml.e.c-a.x), cy(my(mouseY)*ml.e.c-a.y));
      mc.s = new IVector(chip.cs.x*ml.e.c, chip.cs.y*ml.e.c);
      
      if(et && tt) {
        tint(255, 156);
        chip.draw(mc);
        noTint();
      }
      
      stroke(tt?255:0);
      fill(0, 204, 255, 100);
      rect(mc.p.x, mc.p.y, mc.s.x, mc.s.y);
      
      if(ml.e.d) {
        textAlign(RIGHT, TOP);textSize(12);fill(255);
        text("X: "+mx(mouseX)+" Y: "+my(mouseY), cx(s.x), cy(s.y));
      }
    }
    
    if(ml.e.d)area();
  }
  
  boolean update() {
    if(!inside(mouseX, mouseY))return false;
    
    if(ml.e.i.ka || ml.e.i.kleft)a.x-=ss;
    if(ml.e.i.kw || ml.e.i.kup)a.y-=ss;
    if(ml.e.i.kd || ml.e.i.kright)a.x+=ss;
    if(ml.e.i.ks || ml.e.i.kdown)a.y+=ss;
    
    if(a.x<-ms.x)a.x=-ms.x;
    if(a.y<-ms.y)a.y=-ms.y;
    if(a.x>cs.x*ml.e.c+ms.x-s.x)a.x=cs.x*ml.e.c+ms.x-s.x;
    if(a.y>cs.y*ml.e.c+ms.y-s.y)a.y=cs.y*ml.e.c+ms.y-s.y;
    
    if(ml.e.i.md && !ml.e.sb.pr) { // edit
      if(et) {
        if(tt)get_layer(now).paint(chip, mp(mouseX, mouseY));
        else get_layer(now).erase(mp(mouseX, mouseY), chip.cs);
      }else {
        mask.paint_color(tt?color(255):color(0), mp(mouseX, mouseY).mult(ml.e.c), chip.cs.get().mult(ml.e.c));
      }
    }
    
    return true;
  }
  
  void imp() { // import
    get_layer(0).paint_pimg(loadImage("./data/o/layer.png"), new IVector(0, 0));
    mask.paint_pimg(loadImage("./data/o/mask.png"), new IVector(0, 0));
  }
  
  void fill_layer() {
    if(et) {
      if(tt)ls.get(now).paint_all(chip);
      else ls.get(now).erase_all();
    }else {
      mask.fill_color(tt?color(255):color(0));
    }
  }
  
  void save() {
    if(!ml.e.alert("Do you want to save?"))return ;
    PGraphics sl = createGraphics(cs.x*ml.e.c, cs.y*ml.e.c); //save_layer
    sl.beginDraw();
    //sl.background(0);
    for(int i=0;i<ml.n;i++) {
      if(get_layer(i).disp)sl.image(get_layer(i).l, 0, 0);
    }
    sl.endDraw();
    
    sl.get().save("./data/o/layer.png");
    mask.l.get().save("./data/o/mask.png");
    //exit();
  }
  
}

class Layer extends EImage {
  Layers ls;
  IVector cs; // chip_size
  int[][] t; // chip_type
  boolean disp;
  
  Layer(Layers ls) {
    this.ls = ls;
    this.cs = ls.cs;
    reset();
    disp=true;
  }
  
  Layer(Layers ls, IVector cs) {
    this.ls = ls;
    this.cs = cs;
    reset();
    disp=true;
  }
  
  void reset() {
    l = createImage(cs.x*ls.ml.e.c, cs.y*ls.ml.e.c, ARGB);
    this.t = new int[cs.x][cs.y];
    for(int i=0;i<cs.x;i++) {
      for(int j=0;j<cs.y;j++) {
        t[i][j] = -1;
      }
    }
  }
  
  void paint(Layer mat, IVector s) {
    for(int i=max(0, -s.x);i<min(mat.cs.x, cs.x-s.x);i++) {
      for(int j=max(0, -s.y);j<min(mat.cs.y, cs.y-s.y);j++) {
        this.t[s.x+i][s.y+j] = mat.t[i][j];
      }
    }
    paint_pimg(mat.l, s.get().mult(ls.ml.e.c));
  }
  
  void erase(IVector s, IVector sz) {
    for(int i=max(0, -s.x);i<min(sz.x, cs.x-s.x);i++) {
      for(int j=max(0, -s.y);j<min(sz.y, cs.y-s.y);j++) {
        this.t[s.x+i][s.y+j] = -1;
      }
    }
    paint_color(color(0, 0), s.get().mult(ls.ml.e.c), sz.get().mult(ls.ml.e.c));
  }
  
  void paint_all(Layer mat) {
    for(int i=0;i<cs.x;i++) {
      for(int j=0;j<cs.y;j++) {
        this.t[i][j] = mat.t[i%mat.cs.x][j%mat.cs.y];
      }
    }
    fill_pimg(mat.l);
  }
  
  void erase_all() {
    for(int i=0;i<cs.x;i++) {
      for(int j=0;j<cs.y;j++) {
        this.t[i][j] = -1;
      }
    }
    fill_color(color(0, 0));
  }
  
}

class EImage {
  PImage l;
  
  EImage() {}
  
  void set_size(IVector s) {
    l = createImage(s.x, s.y, ARGB);
  }
  
  void set_img(PImage l) {
    this.l = l;
  }
  
  void draw(Box b) {
    image(l.get(0, 0, min(l.width, b.s.x), min(l.height, b.s.y)), b.cx(0), b.cy(0));
  }
  
  void draw(Box b, IVector a) {
    image(
    l.get(a.x, a.y, 
    min(l.width-a.x, b.s.x), 
    min(l.height-a.y, b.s.y)), 
    b.cx(0), b.cy(0));
  }
  
  void paint_pimg(PImage mat, IVector s) {
    l.loadPixels();
    mat.loadPixels();
    for(int i=max(0, -s.x);i<min(mat.width, l.width-s.x);i++) {
      for(int j=max(0, -s.y);j<min(mat.height, l.height-s.y);j++) {
        l.pixels[(i+s.x)+(j+s.y)*l.width] = 
        mat.pixels[i+j*mat.width];
      }
    }
    l.updatePixels();
    mat.updatePixels();
  }
  
  void fill_pimg(PImage mat) {
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
  
  //void paint_img(EImage mat, IVector s) {paint_pimg(mat.l, s);}
  //void fill_img(EImage mat) {fill_pimg(mat.l);}
  
  void fill_color(color col) {
    l.loadPixels();
    for(int i=0;i<l.pixels.length;i++) {
        l.pixels[i] = col;
    }
    l.updatePixels();
  }
  
  void paint_color(color col, IVector st, IVector sz) {
    l.loadPixels();
    for(int i=max(0, st.x);i<min(st.x+sz.x, l.width);i++) {
      for(int j=max(0, st.y);j<min(st.y+sz.y, l.height);j++) {
        l.pixels[i+j*l.width] = col;
      }
    }
    l.updatePixels();
  }
  
}

class LButton extends Box { // MapLayer_Button
  MapLayer ml;
  Layer l;
  
  //int n; // number
  int cs; // content_size
  //boolean pr; // pressed
  
  LButton(MapLayer ml, Layer l, IVector ps) {
    this.ml = ml;
    this.l = l;
    
    p = new IVector(ps.x, ps.y);
    s = new IVector(0, 0);
    set_cs(12);
    
  }
  
  int px(int px) {return ml.px(px) - p.x;}
  int py(int py) {return ml.py(py) - p.y;}
  
  int cx(int cx) {return ml.cx(cx + p.x);}
  int cy(int cy) {return ml.cy(cy + p.y);}
  
  void draw() {
    if(this.selected()) {
      if(!l.disp)tint(156, 0, 0);
      else tint(255, 0, 0);
    }else if(!l.disp) {
      tint(156);
    }
    image(ml.e.bt_img, cx(0), cy(0), s.x, s.y);
    noTint();
    
    textAlign(CENTER, CENTER);
    textSize(cs);
    fill(0);
    text("layer "+get_n(), cx(0)+s.x*.5, cy(0)+s.y*.5);
    
    if(ml.e.d)area();
  }
  
  void set_cs(int cs) {
    this.cs = cs;
    s.x = (this.cs/3*2+2)*("layer".length()+2);
    s.y = this.cs+5;
  }
  
  boolean selected() {
    return (ml.ls.now==get_n());
  }
  
  boolean press_event(int mx, int my) {
    if(!this.inside(mx, my))return false;
    
    if(mouseButton == RIGHT)l.disp = !l.disp;
    else if(mouseButton ==LEFT)ml.ls.now = get_n();
    
    return true;
  }
  
  int get_n() {
    return ml.ls.ls.indexOf(l);
  }
  
}