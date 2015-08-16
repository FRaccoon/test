
class Score {
  Game g;
  int life, bounus;
  
  Score(Game g) {
    this.g = g;
  }
  
  void reset() {
    life = 500;
    bounus = 0;
  }
  
  void update() {
    if(life<1)g.fin();
  }
  
  void draw() {
    textAlign(LEFT,TOP);
    textSize(12);
    stroke(255);
    text("life : "+life+"\nscore : "+score(), 3, 3);
  }
  
  int score() {
    return g.count+5*life+bounus;
  }
  
}

