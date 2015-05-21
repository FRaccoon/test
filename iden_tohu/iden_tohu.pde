
World world;

void setup() {
  size(800, 600, P3D);
  world = new World();
}

void draw() {
  background(0);
  world.update();
  world.draw();
}

void keyPressed() {
  world.keyPressed();
}

void keyReleased() {
  world.keyReleased();
}

