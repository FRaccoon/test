
class Editer {
  int c; // chip_size
  boolean d; //debug
  
  Gui g;
  MapLayer ml;
  SideBar sb;
  Input i;
  
  PImage bt_img;
  
  Editer() {
    c = 16;
    d = false;
    
    bt_img = loadImage("btn_img.png");
    
    g = new Gui(this);
    sb = new SideBar(this);
    ml = new MapLayer(this);
    i = new Input(this);
    
    //PFont font = loadFont("HGPMinchoB-20.vlw");
    
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
    i.mousePressed();
  }
  
  void mouseReleased(){
    i.mouseReleased();
  }
  
  void mouseWheel(int delta){
    i.mouseWheel(delta);
  }
  
  void keyPressed(){
    i.keyPressed();
  }
  
  void keyReleased(){
    i.keyReleased();
  }
  
  boolean alert(String str) { //このクラスはjavaで作られてます
    int r = JOptionPane.showConfirmDialog( null, str, "alert", JOptionPane.OK_CANCEL_OPTION, JOptionPane.WARNING_MESSAGE );
    return (r==JOptionPane.OK_OPTION);
    
  }
  
}

