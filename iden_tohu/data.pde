
class Data {
  ArrayList<Boolean> d;
  int t;
  
  Data() {
    d = new ArrayList<Boolean>();
    t = 0;
  }
  
  void input(String s) {
    d.clear();
    for(int i=0;i<s.length();i++) {
      d.add(s.charAt(i)=='1');
    }
  }
  
  String output() {
    String r ="";
    for(Boolean b : d) {
      r += b?"1":"0";
    }
    return r;
  }
  
  void set(Data d) {
    this.d = (ArrayList<Boolean>)d.d.clone();
  }
  
  void noise(float t) {
    for (int i=0; i<d.size(); i++) {
      if(random(1)<t)d.set(i, !d.get(i));
    }
  }
  
  float pop() {
    float v = ((t<d.size()?d.get(t):this.add())?1:0);
    t++;
    return v;
  }
  
  boolean add() {
    boolean t = random(1)<.5;
    d.add(t);
    return t;
  }
  
}

