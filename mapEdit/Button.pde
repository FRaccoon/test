
class Button {
  Gui g;
  PVector p, s;
  String ct;
  int cs;
  
  Button(Gui g, String content, float px, float py) {
    this.g = g;
    
    this.ct = content;
    cs = 12;
    
    p = new PVector(px, py);
    s = new PVector((cs-2)*ct.length(), 20);
    
  }
  
  void draw() {
    textAlign(CENTER, CENTER);
    textSize(cs);
    fill(0);
    if(this.selected())tint(255, 0, 0);
    image(g.bt_img, p.x, p.y, s.x, 20);
    noTint();
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
            r = (g.e.mapLayer.now==i);
            break;
          }
        }
      break;
      case 'm': // mask
        r = (g.e.mapLayer.now==0);
      break;
      case 'p': // pen
        r = (g.e.mapLayer.maskTool==1);
      break;
      case'e': // eraser
        r = (g.e.mapLayer.maskTool==2);
      break;
      default: // import, save, all
      break;
    }
    return r;
  }
  
  boolean press(int mx, int my) {
    if( mx<p.x || mx>p.x+s.x || my<p.y || my>p.y+s.y )return false;
    
    switch(ct.charAt(0)) {
      case 'i': // import
      break;
      case 'l': // layer1~3
        for(int i=1;i<4;i++) {
          if(ct.charAt(5)==(i+'0')) {
            g.e.mapLayer.now=i;
            break;
          }
        }
      break;
      case 'm': // mask
        g.e.mapLayer.now = 0;
      break;
      case 's': // save
        g.e.mapLayer.save();
      break;
      case 'a': // all
        g.e.mapLayer.saveLayer = loadImage("layer.png");
        g.e.mapLayer.mask = loadImage("mask.png");
      break;
      case 'p': // pen
        g.e.mapLayer.maskTool = 1;
      break;
      case'e': // eraser
        g.e.mapLayer.maskTool = 2;
      break;
      default:
      break;
    }
    return true;
  }
  
}
