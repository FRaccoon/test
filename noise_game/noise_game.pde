
Game game;

void setup() {
  size(600, 400);
  
  game = new Game();
  
}

void draw() {
  game.update();
  game.draw();
}

void keyPressed() {
  game.keyPressed();
}

void keyReleased() {
  game.keyReleased();
}

