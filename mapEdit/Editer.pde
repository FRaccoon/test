
class Editer {
  int a, b;
  int c; // c:chip_size
  
  Gui gui;
  MapLayer mapLayer;
  Input input;
  
  Editer() {
    a = 0;
    b = 0;
    
    c = 16;
    
    gui = new Gui(this);
    mapLayer = new MapLayer(this);
    input = new Input(this);
    
    //PFont font = loadFont("HGPMinchoB-20.vlw");
    
    addMouseWheelListener( new MouseWheelListener() {
      public void mouseWheelMoved(MouseWheelEvent mwe) {
        mouseWheel( mwe.getWheelRotation() );
      }
    });
    
  }
  
  void draw() {
    if( input.ka && mapLayer.edgeX>-160 )mapLayer.edgeX -= c;
    if( input.kw && mapLayer.edgeY>-160 )mapLayer.edgeY -= c;
    if( input.kd && mapLayer.edgeX<407 )mapLayer.edgeX += c;
    if( input.ks && mapLayer.edgeY<560 )mapLayer.edgeY += c;
    mapLayer.edit(mapLayer.now);
    
    gui.draw();
    
    fill(255);
    /*if( (mouseX<554)&&(mouseX>0)&&(mouseY>80)&&(mouseY<480) ) {
       text(((mouseX/c*c+mapLayer.edgeX)/c+1)+"X"+((mouseY/c*c-80+mapLayer.edgeY)/c+1), 350, 50);
    }*/
    
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
