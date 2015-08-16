
class MapLayer {
  Editer e;
  
  int X, Y;
  
  int now;
  PImage editmap;
  PImage copy;
  PImage[] layerImage;
  PImage saveLayer;
  PImage mask, oMask;
  int PmouseX, PmouseY;
  int paint;
  int edgeX, edgeY;
  int maskTool;
  
  /*変数紹介
  PmaouseX,PmouseY:最後にマウスが押された瞬間のマウスの座標が入っています
  */
  
  MapLayer(Editer e) {
    this.e = e;
    layer();
    
    now = 1;
    copy = createImage(16, 16, 255);
    PmouseX = 554;
    PmouseY = 0;
    paint = 0;
    edgeX = 0;
    edgeY = 0;
    
    editmap = loadImage("base.png");
    
    layerImage = new PImage[3];
    for(int i=0;i<layerImage.length;i++) {
      layerImage[i] = createImage(X*e.c, Y*e.c, ARGB);
    }
    saveLayer = createImage(X*e.c, Y*e.c, ARGB);
    
    mask= createImage(X*e.c, Y*e.c, ARGB);
    oMask= createImage(X, Y, RGB);
    
    mask.loadPixels();
    oMask.loadPixels();
    
    for(int i=0;i<mask.pixels.length;i++) {
      mask.pixels[i] = color(255, 255, 255, 0);
    }
    for(int i=0;i<oMask.pixels.length;i++) {
      oMask.pixels[i] = color(255, 255, 255, 0);
    }
    
    mask.updatePixels();
    oMask.updatePixels();
    
  }
  
  void edit(int layerNow) {
    if(layerNow==0) {
      maskEdit();
      return;
    }
    
    fill(255);
    rect(0,79,546,402);
    for(int i=0;i<layerNow;i++){
      image(layerImage[i].get(edgeX, edgeY, 544, 400), 0, 80);
    }
    
    fill(255);
    image(editmap, width-160, e.a*16);
    fill(0,204,255,100);
    rect(PmouseX-PmouseX%e.c, PmouseY-PmouseY%e.c+e.b*e.c, e.c, e.c);
    
    if(e.input.md) {
      for(int i=0;i<layerNow;i++) {
        layerImage[layerNow-1].loadPixels();
      }
      
      copy.loadPixels();
      if(mouseX<width-160) {
        int x = mouseX/e.c*e.c;
        int y = mouseY/e.c*e.c;
        
        for(int i=0;i<e.c;i++){
          for(int j=0;j<e.c;j++){
            if( (Y*16>x+i+edgeX) 
            && (X*16>y+j-80+edgeY) 
            && (0<x+i+edgeX)&&(0<y+j-80+edgeY) ) {
              paint(x+i+edgeX,y+j+edgeY-80,layerImage[layerNow-1],copy.pixels[j*copy.width+i]);
            }
          }
        }
        
        layerImage[layerNow-1].updatePixels();
      }
      
      //ALLが押されたときの処理をしています
      if((mouseX<350)&&(mouseX>320)&&(mouseY>30)&&(mouseY<50)) {
        layerImage[layerNow-1].loadPixels();
        copy.loadPixels();
        for(int i=0;i<X;i++) {
          for(int j=0;j<Y;j++) {
            for(int k=0;k<e.c;k++) {
              for(int l=0;l<e.c;l++) {
                paint(i*e.c+k, j*e.c+l, layerImage[layerNow-1], copy.pixels[l*copy.width+k]);
              }
            }
          }
        }
        
        layerImage[layerNow-1].updatePixels();
      }
      
    }
    
  }
  
  void maskEdit() {
    
    int selected=0;
    fill(255);
    rect(0, 79, 546, 402);
    for(int i=0;i<layerImage.length;i++) {
      image(layerImage[i].get(edgeX, edgeY, 544, 400), 0, 80);
    }
    image(mask.get(edgeX, edgeY, 544, 400), 0, 80);
    //ぺんと消しゴムのボタンを作り、
    
    if(!e.input.md)return;
    
    if(mouseX<width-160) { //16で割ったあまりを除いています
      mask.loadPixels();
      copy.loadPixels();
      int x=mouseX/16*16;
      int y=mouseY/16*16;
      for(int i=0;i<16;i++) {
        for(int j=0;j<16;j++) {
          if( (X*16>y+j-80+edgeY) 
          && (Y*16>x+i+edgeX) 
          && (0<x+i+edgeX)&&(0<y+j-80+edgeY) ) {
            if(maskTool==1) {
              paint(x+i+edgeX, y+j-80+edgeY, mask, color(255,100));
              paint((mouseX+edgeX)/e.c, (mouseY+edgeY)/e.c-5, oMask, color(0,0));
            }
            
            if(maskTool==2) {
              paint(x+i+edgeX, y+j-80+edgeY, mask, color(255,0));
              paint((mouseX+edgeX)/e.c, (mouseY+edgeY)/e.c-5, oMask, color(255,0));
            }
            
          }
          
        }
      }
      mask.updatePixels();
      copy.updatePixels();
      
    }
    
  }
  
  //関数終了
  //X,Yのピクセルを書き出す
  void paint(int X, int Y, PImage object, color iro) {
    object.pixels[Y*(object.width)+X] = iro;
  }
  
  void save() {
    color[] cl = new color[layerImage.length];
    
    saveLayer.loadPixels();
    for(int i=0;i<now;i++) {
      layerImage[i].loadPixels();
    }
    //mask.loadPixels();
    
    for(int i=0;i<X*e.c;i++) {
      for(int j=0;j<Y*e.c;j++) {
        //color clf = mask.pixels[j*mask.width+i];
        for(int k=0;k<layerImage.length;k++) {
          cl[k] = layerImage[k].pixels[j*layerImage[k].width+i];
          if(alpha(cl[k])==255)saveLayer.pixels[j*saveLayer.width+i] = layerImage[k].pixels[j*layerImage[k].width+i];
        }
      }
    }
    
    saveLayer.updatePixels();
    //mask.updatePixels();
    
    saveLayer.save("layer.png");
    oMask.save("mask.png");
    
  }
  
  void layer() { //このクラスはjavaで作られてます
    JPanel panel = new JPanel();
    panel.setLayout(null);
  
    JTextField text1 = new JTextField();
    panel.add(new JLabel("n1"));
    text1.setBounds(5, 10, 60, 30);
    panel.add(text1);
    
    JTextField text2 = new JTextField();
    panel.add(new JLabel("n2"));
    text2.setBounds(65, 10, 60, 30);
    panel.add(text2);
    
    JOptionPane.showConfirmDialog( null, panel, "layersize", JOptionPane.OK_CANCEL_OPTION, JOptionPane.QUESTION_MESSAGE );
    
    try{
      this.X = int(text1.getText());
      this.Y = int(text2.getText());
    }catch(NumberFormatException e){
      //this.X = 50;
      //this.Y = 50;
    }catch(NullPointerException e){
      //this.X = 50;
      //this.Y = 50;
    }
  }
  
}

