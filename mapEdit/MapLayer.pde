
class MapLayer extends Box {
  Editer e;
  
  IVector m; // map_size
  IVector c; // canvas_size
  IVector a; // (a.x, a.y) = (0, 0)
  int now;
  PImage[] layers;
  PImage chip;
  
  PImage bg_img;
  
  PImage mask;
  boolean mt; // mask_tool true: pen(black), false: eraser(white)
  
  MapLayer(Editer e) {
    this.e = e;
    
    p = new IVector(0, 80);
    s = new IVector(e.c*34, e.c*25);
    
    layer_size(); // set mX, mY
    
    c = new IVector(34, 25);
    
    a = new IVector(0, 0);
    
    now = 1;
    
    mt = false;
    
    bg_img = createImage(c.x*e.c, c.y*e.c, RGB);
    fill_paint(bg_img, loadImage("./data/bg_img.png"));
    
    layers = new PImage[3];
    for(int i=0;i<layers.length;i++) {
      layers[i] = createImage(m.x*e.c, m.y*e.c, ARGB);
    }
    
    chip = createImage(e.c, e.c, ARGB);
    paint(chip, e.sb.ec.get(0,0,e.c,e.c), 0, 0);
    
    mask = createImage(m.x*e.c, m.y*e.c, RGB);
    fill_color(mask, color(255));
    
  }
  
  int get_px(int vx) {
    return ((vx-p.x)/e.c)+a.x;
  }
  
  int get_py(int vy) {
    return ((vy-p.y)/e.c)+a.y;
  }
  
  void paint(PImage canvas, PImage mat, int sx, int sy) {
    canvas.loadPixels();
    mat.loadPixels();
    for(int i=0;i<mat.width&&i+sx<canvas.width;i++) {
      for(int j=0;j<mat.height&&j+sy<canvas.height;j++) {
        canvas.pixels[(i+sx)+(j+sy)*canvas.width] = 
        mat.pixels[i+j*mat.width];
      }
    }
    canvas.updatePixels();
    mat.updatePixels();
  }
  
  void fill_paint(PImage canvas, PImage mat) { //塗りつぶし
    canvas.loadPixels();
    mat.loadPixels();
    for(int i=0;i<canvas.width;i++) {
      for(int j=0;j<canvas.height;j++) {
        canvas.pixels[i+j*canvas.width] = 
        mat.pixels[i%mat.width+(j%mat.height)*mat.width];
      }
    }
    canvas.updatePixels();
    mat.updatePixels();
    
  }
  
  void fill_color(PImage canvas, color col) {
    canvas.loadPixels();
    for(int i=0;i<canvas.pixels.length;i++) {
        canvas.pixels[i] = col;
    }
    canvas.updatePixels();
  }
  
  void paint_color(PImage canvas, color col, int sx, int sy, int ex, int ey) {
    canvas.loadPixels();
    for(int i=sx;i<min(sx+ex, canvas.width);i++) {
      for(int j=sy;j<min(sy+ey, canvas.height);j++) {
        canvas.pixels[i+j*canvas.width] = col;
      }
    }
    canvas.updatePixels();
  }
  
  void draw() {
    image(bg_img, p.x, p.y);
    if(this.now==0) {
      image(mask.get(a.x*e.c, a.y*e.c, min((m.x-a.x)*e.c, c.x*e.c), min((m.y-a.y)*e.c, c.y*e.c)), p.x, p.y);
    }else {
      for(int i=0;i<this.now;i++){
        image(layers[i].get(a.x*e.c, a.y*e.c, min((m.x-a.x)*e.c, c.x*e.c), min((m.y-a.y)*e.c, c.y*e.c)), p.x, p.y);
      }
    }
    
    if(inside(mouseX, mouseY)){
      textAlign(RIGHT, TOP);textSize(12);fill(255);
      text("X: "+get_px(mouseX)+" Y: "+get_py(mouseY), p.x+s.x, p.y+s.y);
      fill(0,204,255,100);
      rect(int((mouseX-p.x)/e.c)*e.c+p.x, int((mouseY-p.y)/e.c)*e.c+p.y, e.c, e.c);
    }
    
  }
  
  void update() {
    if(inside(mouseX, mouseY)) {
      if((e.input.ka || e.input.kleft) && a.x>0)a.x--;
      if((e.input.kw || e.input.kup) && a.y>0)a.y--;
      if((e.input.kd || e.input.kright) && a.x<m.x-c.x)a.x++;
      if((e.input.ks || e.input.kdown) && a.y<m.y-c.y)a.y++;
      
      if(e.input.md) { // edit
        // &&(get_px(mouseX)<m.x && get_py(mouseY)<m.y)
        if(this.now!=0)paint(layers[this.now-1], chip, get_px(mouseX)*e.c, get_py(mouseY)*e.c);
        paint_color(mask, (mt?color(0):color(255)), get_px(mouseX)*e.c, get_py(mouseY)*e.c, e.c, e.c);
      }
      
    }
    
  }
  
  void save() {
    PGraphics sl = createGraphics(m.x*e.c, m.y*e.c); //save_layer
    sl.beginDraw();
    //sl.background(0);
    for(int i=0;i<this.now;i++) {
      sl.image(layers[i], 0, 0);
    }
    sl.endDraw();
    
    sl.get().save("./data/o/layer.png");
    mask.get().save("./data/o/mask.png");
    //exit();
  }
  
  void layer_size() { //このクラスはjavaで作られてます?
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
    
    JOptionPane.showConfirmDialog( null, panel, "layersize", JOptionPane.OK_CANCEL_OPTION, JOptionPane.QUESTION_MESSAGE );
    
    int gX = 0, gY = 0;
    try{
      gX = int(text1.getText());
      gY = int(text2.getText());
    }catch(NumberFormatException e){
    }catch(NullPointerException e){
    }
    
    m = new IVector((gX==0?50:gX), (gY==0?50:gY));
    
  }
  
}

