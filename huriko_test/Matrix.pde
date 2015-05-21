
class Mat {
  int n;
  double[][] a;
  
  Mat(int n) {
    this.n = n;
    a = new double[this.n][this.n];
    
    for(int i=0;i<this.n;i++) {for(int j=0;j<this.n;j++) {
      a[i][j] = 0;
    }}
    
  }
  
  double get(int i, int j) {
    return a[i][j];
  }
  
  void set(int i, int j, double v) {
    a[i][j] = v;
  }
  
  Mat mult_m(Mat m) {
    if(this.n!=m.n)return new Mat(1);
    
    Mat r = new Mat(n);
    double val;
    
    for(int i=0;i<n;i++) {for(int j=0;j<n;j++) {
      val = 0;
      for(int k=0;k<n;k++) {
        val += a[i][k]*m.get(k, j);
      }
      r.set(i, j, val);
    }}
    
    return r;
    
  }
  
  Mat trns_mat() {
    Mat r = new Mat(n);
    for(int i=0;i<n;i++) {
      for(int j=0;j<n;j++) {
        r.set(i, j, this.get(j, i));
      }
    }
    return r;
  }
  
  Vect mult_v(Vect v) {
    if(this.n!=v.n)return new Vect(1);
    
    Vect r = new Vect(n);
    double val;
    
    for(int i=0;i<n;i++) {
      val = 0;
      for(int j=0;j<n;j++) {
        val += a[i][j]*v.get(j);
      }
      r.set(i, val);
    }
    
    return r;
  }
  
  void print() {
    for(int i=0;i<n;i++) {
      println(a[i]);
    }
  }
  
}

