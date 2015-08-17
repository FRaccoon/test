
class Button extends Box {
  Gui g;
  String ct;
  int cs;
  boolean pr; // pressed
  
  Button(Gui g, String content, int px, int py) {
    this.g = g;
    
    this.ct = content;
    cs = 12;
    
    p = new IVector(px, py);
    s = new IVector((cs-2)*ct.length(), 20);
    
    pr = false;
    
  }
  
  void draw() {
    
    if(pr) {
      tint(0, 255, 0);
      pr = false;
    }else if(this.selected())tint(255, 0, 0);
    image(g.bt_img, p.x, p.y, s.x, s.y);
    noTint();
    
    textAlign(CENTER, CENTER);
    textSize(cs);
    fill(0);
    text(ct, p.x+s.x*.5, p.y+s.y*.5);
    
  }
  
  void set_ct(String ct) {
    this.ct = ct;
    s.x = 10*this.ct.length();
  }
  
  boolean selected() {
    boolean r = false;
    switch(ct.charAt(0)) {
      case 'l': // layer1~3
        for(int i=1;i<4;i++) {
          if(ct.charAt(5)==(i+'0')) {
            r = (g.e.ml.now==i);
            break;
          }
        }
      break;
      case 'm': // mask
        r = (g.e.ml.now==0);
      break;
      case 'p': // pen
        r = g.e.ml.mt;
      break;
      case 'e': // eraser
        r = !g.e.ml.mt;
      break;
      default: // import, save, fill
        //r = inside(mouseX, mouseY);
      break;
    }
    return r;
  }
  
  boolean press_event(int mx, int my) {
    if(!this.inside(mx, my))return false;
    pr = true;
    
    switch(ct.charAt(0)) {
      case 'i': // import
        g.e.ml.imp();
      break;
      case 'l': // layer1~3
        for(int i=1;i<4;i++) {
          if(ct.charAt(5)==(i+'0')) {
            g.e.ml.now=i;
            break;
          }
        }
      break;
      case 'm': // mask
        g.e.ml.now = 0;
      break;
      case 's': // save
        g.e.ml.save();
      break;
      case 'f': // fill
        if(g.e.ml.now==0)g.e.ml.fill_color(g.e.ml.mask, (g.e.ml.mt?color(0):color(255)));
        else g.e.ml.fill_paint(g.e.ml.layers[g.e.ml.now-1], g.e.ml.chip);
        
      break;
      case 'p': // pen
        g.e.ml.mt = true;
      break;
      case'e': // eraser
        g.e.ml.mt = false;
      break;
      default:
      break;
    }
    return true;
  }
  
}

