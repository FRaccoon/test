
class MEditor extends Box {
  int c; // chip_size
  boolean d; //debug
  
  Gui g;
  SideBar sb;
  MapLayer ml;
  Input i;
  
  PImage bt_img;
  
  boolean pr; // mouse_press
  
  MEditor() {
    c = 16;
    d = false;
    
    p = new IVector(0, 0);
    s = new IVector(width, height); // 720, 500
    
    bt_img = loadImage("btn_img.png");
    
    g = new Gui(this);
    sb = new SideBar(this);
    ml = new MapLayer(this);
    i = new Input(this);
    
  }
  
  void update() {
    ml.update();
    sb.update();
    g.update();
    
  }
  
  void draw() {
    ml.draw();
    sb.draw();
    g.draw();
    
    if(this.d)area();
  }
  
  void mousePressed(){
    if(!i.md) {
      if(sb.press_event(mouseX, mouseY)) {}
      else if(g.press_event(mouseX, mouseY)) {}
      else if(ml.press_event(mouseX, mouseY)) {}
      
    }
    i.mousePressed();
    
  }
  
  void mouseReleased(){
    if(i.md) {
      if(sb.release_event(mouseX, mouseY)) {}
      else if(g.release_event(mouseX, mouseY)) {}
      else if(ml.release_event(mouseX, mouseY)) {}
      
    }
    i.mouseReleased();
    
  }
  
  void mouseWheel(int delta){
    if(sb.wheel_event(delta)) {}
    //i.mouseWheel(delta);
    
  }
  
  void keyPressed(){
    i.keyPressed();
    
  }
  
  void keyReleased(){
    if(ml.key_release_event(mouseX, mouseY)) {}
    i.keyReleased();
    
  }
  
  boolean alert(String str) { //このクラスはjavaで作られてます
    int r = JOptionPane.showConfirmDialog( null, str, "alert", JOptionPane.OK_CANCEL_OPTION, JOptionPane.WARNING_MESSAGE );
    return (r==JOptionPane.OK_OPTION);
    
  }
  
}