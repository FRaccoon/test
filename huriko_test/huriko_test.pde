
/*
* 
* paku-respect
* http://www.aihara.co.jp/~taiji/pendula-equations/present-node5.html
* 
*/

World w;

void setup() {
  size(200, 200);
  
  w = new World(5);
}

void draw() {
  background(0);
  
  w.update();
  w.draw();
  w.save();
  if(w.count>127)exit();
}

void keyPressed() {
}

