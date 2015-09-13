
class ImgDisp extends Box {
  EImage img;
  
  int ss; // scroll_speed
  IVector a, ms; // (a.x, a.y) = (0, 0); ms: margin_size
  
  void scroll(Input i) {
    if(i.pk('w') || i.pkc(UP))a.y-=ss;
    if(i.pk('a') || i.pkc(LEFT))a.x-=ss;
    if(i.pk('s') || i.pkc(DOWN))a.y+=ss;
    if(i.pk('d') || i.pkc(RIGHT))a.x+=ss;
    
    this.limit();
    
  }
  
  void limit() {
    if(img.wid()+2*ms.x<s.x)a.x=(img.wid()-s.x)/2;
    else if(a.x<-ms.x)a.x=-ms.x;
    else if(a.x>img.wid()+ms.x-s.x)a.x=img.wid()+ms.x-s.x;
    
    if(img.hei()+2*ms.y<s.y)a.y=(img.hei()-s.y)/2;
    else if(a.y<-ms.y)a.y=-ms.y;
    else if(a.y>img.hei()+ms.y-s.y)a.y=img.hei()+ms.y-s.y;
    
  }
  
  boolean wheel_event(int delta) {
    if(!inside(mouseX, mouseY))return false;
    a.y += delta*ss;
    this.limit();
    return true;
    
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
  
  PImage get(IVector p, IVector s) {
    return l.get(p.x, p.y, s.x, s.y);
  }
  
  int wid() {
    return l.width;
  }
  
  int hei() {
    return l.height;
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