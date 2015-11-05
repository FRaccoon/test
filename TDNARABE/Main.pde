
class Game {
  State st;
  Data dt;
  Disp dp;
  Input in;
  
  Game(int w, int h) {
    st = new State(this);
    dt = new Data(this);
    dp = new Disp(this, w, h);
    in = new Input(this);
  }
  
  void update() {
    st.update();
  }
  
  void draw() {
    background(0);
    dp.draw();
  }
  
  int n() {return dt.n;}
  
  void mpe() {}
  void mre() {st.mre();}
  
  void kp() {in.kp();}
  void kr() {in.kr();}
  void mp() {in.mp();}
  void mr() {in.mr();}
  
}