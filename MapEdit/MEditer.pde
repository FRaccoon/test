
class MEditer {
  int c; // chip_size
  boolean d; //debug
  
  Gui g;
  MapLayer ml;
  SideBar sb;
  Input i;
  
  PImage bt_img;
  
  MEditer() {
    c = 16;
    d = false;
    
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
  }
  
  void mousePressed(){
    if(!i.md) {
      if(sb.press_event(mouseX, mouseY)) {
      }else if(g.press_event(mouseX, mouseY)) {
      }else if(ml.press_event(mouseX, mouseY)) {}
      
    }
    i.mousePressed();
  }
  
  void mouseReleased(){
    if(i.md) {
      if(sb.release_event(mouseX, mouseY)) {}
    }
    i.mouseReleased();
  }
  
  void mouseWheel(int delta){
    if(sb.inside(mouseX, mouseY))sb.wheel_event(delta);
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