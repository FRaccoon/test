
class Vect {
  int n;
  double[] a;
  
  Vect(int n) {
    this.n = n;
    a = new double[this.n];
    for(int i=0;i<this.n;i++) {
      a[i] = 0;
    }
  }
  
  double get(int i) {
    return a[i];
  }
  
  void set(int i, double v) {
    a[i] = v;
  }
  
  void print() {
    println(a);
  }
  
}

