
Game game;

void setup() {
  size(800, 600, P2D);
  game = new Game(width, height);
  
}

void draw() {
  game.update();
  game.draw();
}

void keyPressed() {
  game.kp();
}

void keyReleased() {
  game.kr();
}

void mousePressed() {
  game.mp();
}

void mouseReleased() {
  game.mr();
}