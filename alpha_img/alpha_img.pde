
PImage img0, img1;
boolean b;

void setup() {
  size(600, 400);
  
  b = true;
  
  img1 = loadImage("./data/i.jpg");
  
  img0 = createImage(img1.width, img1.height, ARGB);
  
  img1.loadPixels();
  
  img0.loadPixels();
  
  for(int i=0;i<img1.width*img1.height;i++){
    color a = img1.pixels[i];
    img0.pixels[i] = color( 255, (.3*red(a)+.59*green(a)+.11*blue(a)) );
  }
  
  img1.updatePixels();
  
  img0.updatePixels();
  
  img0.save("./data/o.png");
  //exit();
  
}

void draw() {
  background(b?255:0);
  image(img0, (width-img0.width)/2, (height-img0.height)/2);
}

void keyReleased() {
  if(key=='1')b=true;
  else if(key=='2')b=false;
}