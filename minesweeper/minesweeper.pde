
Game game;

void setup() {
  size(620, 420);
  
  game = new Game(30, 20, 100, 20);
  
}

void draw() {
  background(192);
  
  //game.update();
  game.draw();
  
}

void mouseReleased() {
  game.mouseReleased();
}

void keyReleased() {
  game.keyReleased();
}