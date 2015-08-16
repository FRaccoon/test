
class Game {
  PVector o;
  int count;
  
  Keys keys;
  Score score;
  
  Player player;
  Wave wave;
  Item item;
  
  Game() {
    o = new PVector(.05*width, height/2);
    
    keys = new Keys(this);
    score = new Score(this);
    score.reset();
    
    wave = new Wave(this, 500);
    item = new Item(this);
    player = new Player(this);
    
    count = 0;
    
  }
  
  void update() {
    wave.update();
    item.update();
    player.update();
    score.update();
    
    count++;
  }
  
  void fin() {
      println("score : "+score.score());
      exit();
  }
  
  void draw() {
    background(0);
    wave.draw();
    item.draw();
    player.draw();
    score.draw();
  }
  
  void keyPressed(){
    keys.keyPressed();
  }
  
  void keyReleased(){
    keys.keyReleased();
  }
  
}

