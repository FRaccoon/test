
class Editer {
  int c; // c:chip_size
  
  Gui gui;
  MapLayer ml;
  SideBar sb;
  Input input;
  
  Editer() {
    c = 16;
    
    gui = new Gui(this);
    sb = new SideBar(this);
    ml = new MapLayer(this);
    input = new Input(this);
    
    //PFont font = loadFont("HGPMinchoB-20.vlw");
    
  }
  
  void update() {
    ml.update();
  }
  
  void draw() {
    ml.draw();
    sb.draw();
    gui.draw();
  }
  
  void mousePressed(){
    input.mousePressed();
  }
  
  void mouseReleased(){
    input.mouseReleased();
  }
  
  void mouseWheel(int delta){
    input.mouseWheel(delta);
  }
  
  void keyPressed(){
    input.keyPressed();
  }
  
  void keyReleased(){
    input.keyReleased();
  }
  
}
