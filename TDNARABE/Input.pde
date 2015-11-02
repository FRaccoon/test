
class Input {
  Game g;
  
  boolean[] kp;
  boolean[] kcp;
  boolean mp;
  
  Input(Game g) {
    this.g = g;
    kp = new boolean[52];
    kcp = new boolean[6];
  }
  
  void kp() {
    if(key==CODED) {
    }else {
      if('a'<=key && key<='z')kp[key-'a']=true;
      else if('A'<=key && key<='Z')kp[key-'A'+26]=true;
    }
  }
  
  void kr() {
    if(key==CODED) {
    }else {
      if('a'<=key && key<='z')kp[key-'a']=false;
      else if('A'<=key && key<='Z')kp[key-'A'+26]=false;
    }
  }
  
  boolean ip(char k) {
      if('a'<=k && k<='z')return kp[k-'a'];
      else if('A'<=k && k<='Z')return kp[k-'A'+26];
      else return false;
  }
  
  void mp() {
    if(!mp)g.mpe();
    mp = true;
  }
  
  void mr() {
    if(mp)g.mre();
    mp = false;
  }
  
}