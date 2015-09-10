
class MapLayer extends Box {
  MEditer e;
  
  Layers ls;
  ArrayList<LButton> lb;
  
  IVector bp; //button_pos
  int n;
  
  MapLayer(MEditer e) {
    this.e = e;
    
    p = new IVector(0, 33);
    s = new IVector(e.s.x-160, e.s.y-33);
    
    n = 0;
    ls = new Layers(this, layer_size()); // set m.x, m.y
    lb = new ArrayList<LButton>();
    bp = new IVector(8, 0);
    for(int i=0;i<3;i++) {
      add_layer();
    }
    
  }
  
  int px(int px) {return e.px(px)-p.x;}
  int py(int py) {return e.py(py)-p.y;}
  
  int cx(int cx) {return e.cx(cx+p.x);}
  int cy(int cy) {return e.cy(cy+p.y);}
  
  void add_layer() {
    Layer l = new Layer(ls);
    LButton b = new LButton(this, l, n, bp);
    
    ls.ls.add(l);
    lb.add(b);
    
    bp.x += b.s.x;
    n++;
  }
  
  void del_layer(LButton b) {
    if (nl()<1 && !e.alert("delete ' "+b.get_ct()+" ' ?"))return ;
    
    if(ls.now > b.get_n())ls.now--;
    for(int i=b.get_n()+1;i<nl();i++) {
      lb.get(i).p.x -= b.s.x;
    }
    bp.x -= b.s.x;
    
    Layer l = b.l;
    ls.ls.remove(l);
    lb.remove(b);
    
    //n--;
  }
  
  int nl() { // number_of_layer
    return lb.size();
  }
  
  void draw() {
    for(int i=0;i<nl();i++) {
      lb.get(i).draw();
    }
    ls.draw();
    
    if(e.d)area();
  }
  
  void update() {
    if(ls.update()) {}
  }
  
  boolean press_event(int mx, int my) {
    if(!this.inside(mx, my))return false;
    if(ls.inside(mx, my))return true;
    
    for(int i=0;i<nl();i++) {
      if(lb.get(i).press_event(mx, my))break;
    }
    return true;
  }
  
  boolean key_release_event(int mx, int my) {
    if(!this.inside(mx, my))return false;
    
    if(ls.key_release_event(mx, my)) {
    }else {
      for(int i=0;i<nl();i++) {
        if(lb.get(i).key_release_event(mx, my))break;
      }
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
  IVector pm; // p_mouse
  
  EImage bg_img;
  EImage mask;
  
  int ss; // scroll_speed
  IVector ms; // margin_size
  
  Layers(MapLayer ml, IVector cs) {
    this.ml = ml;
    
    p = new IVector(8, 25);
    this.cs = cs;
    s = new IVector(34*ml.e.c, 25*ml.e.c);
    
    a = new IVector(0, 0);
    
    et = true;
    tt = true;
    
    pm = new IVector(0, 0);
    
    ls = new ArrayList<Layer>();
    this.now=0;
    
    chip = new Layer(this, new IVector(1, 1));
    set_chip(new IVector(0, 0), new IVector(1, 1));
    
    bg_img = new EImage();
    bg_img.set_size(this.s);
    bg_img.fill_pimg(loadImage("./data/bg_img.png"));
    
    mask = new EImage();
    mask.set_size(this.cs.mult(ml.e.c));
    mask.fill_color(color(0));
    
    ss = 10;
    ms = new IVector(2*s.x/3, 2*s.y/3);
    
  }
  
  int px(int px) {return ml.px(px)-p.x;}
  int py(int py) {return ml.py(py)-p.y;}
  
  int cx(int cx) {return ml.cx(cx+p.x);}
  int cy(int cy) {return ml.cy(cy+p.y);}
  
  int mx(int px) {return (px(px+a.x)/ml.e.c)-(px(px+a.x)<0?1:0);}
  int my(int py) {return (py(py+a.y)/ml.e.c)-(py(py+a.y)<0?1:0);}
  
  int sx(int px) {return px-(chip.cs.x-1)*ml.e.c/2;}
  int sy(int py) {return py-(chip.cs.y-1)*ml.e.c/2;}
  
  IVector mp(int px, int py) {return new IVector(mx(sx(px)), my(sy(py)));}
  
  Layer get_layer(int i) {
    if(!(i<0) && i<ml.nl())return ls.get(i);
    else return null;
  }
  
  int nl() { // number_of_layer
    return ls.size();
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
    for(int i=0;i<nl();i++){
      if(get_layer(i).disp)get_layer(i).draw((Box)this, a);
    }
    noTint();
    
    noFill();stroke(0);
    rect(cx(-a.x), cy(-a.y), cs.x*ml.e.c, cs.y*ml.e.c);
    
    if(inside(mouseX, mouseY)){
      Box mc = new Box(); // mouse_cursor
      mc.p = cp(mp(mouseX, mouseY).mult(ml.e.c).sub(a));
      mc.s = chip.cs.mult(ml.e.c);
      
      if(et && tt) {
        tint(255, 156);
        chip.draw(mc);
        noTint();
      }
      
      stroke(tt?255:0);
      fill(0, 204, 255, 100);
      mc.box();
      
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
    
    IVector mp = mp(mouseX, mouseY);
    if(ml.e.i.md && !ml.e.sb.pr && !pm.equals(mp)) { // edit
      if(et) {
        if(tt)get_layer(now).paint(chip, mp);
        else get_layer(now).erase(mp, chip.cs);
      }else {
        mask.paint_color(tt?color(255):color(0), mp.mult(ml.e.c), chip.cs.mult(ml.e.c));
      }
      pm.set(mp);
    }
    
    return true;
  }
  
  boolean key_release_event(int mx, int my) {
    if(!this.inside(mx, my))return false;
    if(key=='f')auto_fill(new IVector(mx(mx), my(my)));
    return true;
  }
  
  void auto_fill(IVector sp) {
    int[] dx = { 1, 0,-1, 0}, dy = { 0, 1, 0,-1};
    boolean[][] t = new boolean[cs.x][cs.y];
    for(int i=0;i<cs.x;i++){for(int j=0;j<cs.y;j++){
      t[i][j] = false;
    }}
    ArrayList<IVector> que = new ArrayList<IVector>();
    que.add(sp.get());
    
    if(et) {
      Layer l = get_layer(now);
      IVector ip = sp.get(), xp = sp.get();
      int v = l.t[sp.x][sp.y];
      while(que.size()>0) {
        IVector q = que.get(0);
        if(!t[q.x][q.y] && l.t[q.x][q.y]==v) {
          t[q.x][q.y] = true;
          if(q.x<ip.x)ip.x=q.x;
          else if(q.x>xp.x)xp.x=q.x;
          if(q.y<ip.y)ip.y=q.y;
          else if(q.y>xp.y)xp.y=q.y;
          for(int i=0;i<dx.length;i++) {
            IVector dn = q.get().add(dx[i], dy[i]);
            if(dn.x<0 || dn.y<0 || dn.x>=cs.x || dn.y>=cs.y)continue;
            que.add(dn);
          }
        }
        que.remove(q);
      }
      
      for(int i=ip.x;i<=xp.x;i++) {for(int j=ip.y;j<=xp.y;j++) {
        if(t[i][j]) {
          IVector cp = new IVector(i, j);
          if(tt) {
            cp.sub(ip);
            cp.mod(chip.cs);
            l.t[i][j] = chip.t[cp.x][cp.y];
            cp.scalar(ml.e.c);
            l.paint_pimg(chip.l.get(cp.x, cp.y, ml.e.c, ml.e.c), (new IVector(i, j)).scalar(ml.e.c));
          }else {
            l.t[i][j] = -1;
            l.paint_color(color(0, 0), cp.mult(ml.e.c), new IVector(ml.e.c, ml.e.c));
          }
        }
      }}
      
    }else {
      IVector ip = sp.get(), xp = sp.get();
      color v = mask.get(sp.mult(ml.e.c));
      while(que.size()>0) {
        IVector q = que.get(0);
        if(!t[q.x][q.y] && mask.get(q.mult(ml.e.c))==v) {
          t[q.x][q.y] = true;
          if(q.x<ip.x)ip.x=q.x;
          else if(q.x>xp.x)xp.x=q.x;
          if(q.y<ip.y)ip.y=q.y;
          else if(q.y>xp.y)xp.y=q.y;
          for(int i=0;i<dx.length;i++) {
            IVector dn = q.get().add(dx[i], dy[i]);
            if(dn.x<0 || dn.y<0 || dn.x>=cs.x || dn.y>=cs.y)continue;
            que.add(dn);
          }
        }
        que.remove(q);
      }
      
      for(int i=ip.x;i<=xp.x;i++) {for(int j=ip.y;j<=xp.y;j++) {
          IVector cp = new IVector(i, j);
          if(t[i][j])mask.paint_color(tt?color(255):color(0), cp.mult(ml.e.c), new IVector(ml.e.c, ml.e.c));
      }}
      
    }
    
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
    for(int i=0;i<nl();i++) {
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
    disp = true;
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
    paint_pimg(mat.l, s.mult(ls.ml.e.c));
  }
  
  void erase(IVector s, IVector sz) {
    for(int i=max(0, -s.x);i<min(sz.x, cs.x-s.x);i++) {
      for(int j=max(0, -s.y);j<min(sz.y, cs.y-s.y);j++) {
        this.t[s.x+i][s.y+j] = -1;
      }
    }
    paint_color(color(0, 0), s.mult(ls.ml.e.c), sz.mult(ls.ml.e.c));
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
  
  color get(IVector p) {
    return l.get(p.x, p.y);
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
  
  int n; // number
  int cs; // content_size
  //boolean pr; // pressed
  
  LButton(MapLayer ml, Layer l, int n, IVector ps) {
    this.ml = ml;
    this.l = l;
    this.n = n;
    
    p = new IVector(ps.x, ps.y);
    s = new IVector(0, 0);
    set_cs(12);
    
  }
  
  int px(int px) {return ml.px(px)-p.x;}
  int py(int py) {return ml.py(py)-p.y;}
  
  int cx(int cx) {return ml.cx(cx+p.x);}
  int cy(int cy) {return ml.cy(cy+p.y);}
  
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
    text(get_ct(), cx(s.x/2), cy(s.y/2));
    
    if(ml.e.d)area();
  }
  
  void set_cs(int cs) {
    this.cs = cs;
    s.x = (this.cs/3*2+2)*(get_ct().length());
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
  
  boolean key_release_event(int mx, int my) {
    if(!this.inside(mx, my))return false;
    if(keyCode==BACKSPACE)ml.del_layer(this);
    return true;
  }
  
  String get_ct() {
    return "layer "+this.n;
  }
  
  int get_n() {
    return ml.ls.ls.indexOf(l);
  }
  
}