
/*
* 
* paku-respect
* http://www.slis.tsukuba.ac.jp/~fujisawa.makoto.fu/cgi-bin/wiki/index.php?
* %CF%A2%CE%A91%BC%A1%CA%FD%C4%F8%BC%B0%A1%A7%BB%B0%B3%D1%CA%AC%B2%F2
* 
*/

class World {
  float g = .5;
  int count;
  
  int n;
  PVector o;
  Ball[] b;
  
  float[] m;
  float[] c;
  float[] s;
  
  World(int n) {
    
    o = new PVector(width/2, height/2);
    
    this.n = n;
    b = new Ball[n];
    
    for(int i=0;i<n;i++) {
      b[i] = new Ball(10, 20, -PI/2);
    }
    
    m = new float[n];
    c = new float[(n-1)*n/2];
    s = new float[(n-1)*n/2];
    
    m[n-1] = (float)b[n-1].m;
    for(int i=n-2;!(i<0);i--) {
      m[i] = m[i+1]+(float)b[i].m;
    }
    
    count = 0;
    
  }
  
  void update() {
    
    int i, j, k;
    double val;
    
    Mat R = new Mat(n);
    Vect v = new Vect(n);
    
    this.set();
    
    for(i=0;i<n;i++) {
      for(j=0;j<n;j++) {
        R.set(i, j, m[max(i, j)]*b[i].l*b[j].l*c(i,j) );
      }
    }
    
    for(i=0;i<n;i++) {
      val = 0;
      for(j=0;j<i;j++) {
        if(j==i)continue;
        val -= m[j]*b[i].l*b[j].l*b[j].vt*b[j].vt*s(i,j);
      }
      val += m[i]*g*b[i].l*sin((float)b[i].t);
      v.set(i, val);
    }
    
    Mat L = new Mat(n), D = new Mat(n);
    L.set(0,0,R.get(0,0));
    D.set(0,0,1/L.get(0,0));
    
    for(i=1;i<n;i++) {
      val = 0;
      for(j=0;j<i+1;j++) {
        val = R.get(i, j);
        for(k=0;k<j;k++) {
          val -= L.get(i,k)*D.get(k,k)*L.get(j,k);
        }
        L.set(i, j, val);
      }
      
      D.set(i, i, 1/val);
    }
    
    D = L.mult_m(D); //LD
    Vect y = new Vect(n);
    for(i=0;i<n;i++) {
      val = v.get(i);
      for(j=0;j<i;j++) {
        val -= D.get(i,j)*y.get(j);
      }
      y.set(i, val/D.get(i,i));
    }
    
    L = L.trns_mat(); //L^T
    Vect at = new Vect(this.n);
    for(i=n-1;!(i<0);i--) {
      val = y.get(i);
      for(j=i+1;j<n;j++){
        val -= L.get(i,j)*at.get(j);
      }
      at.set(i, val/L.get(i,i));
    }
    
    for(i=0;i<n;i++) {
      b[i].update(at.get(i));
    }
    
    count++;
    
  }
  
  void draw() {
    PVector p = o.get();
    for(int i=0;i<n;i++) {
      p = b[i].draw(p);
    }
  }
  
  float c(int i,int j) {
    if(i==j)return 1;
    else if(i>j)return c[(i-1)*i/2+j];
    else return c[(j-1)*j/2+i]; 
  }
  
  float s(int i,int j) {
    if(i==j)return 0;
    else if(i>j)return s[(i-1)*i/2+j];
    else return -s[(j-1)*j/2+i]; 
  }
  
  void set() {
    int i, j, ct;
    
    ct=0;
    for(i=1;i<n;i++) {for(j=0;j<i;j++) {
      c[ct] = cos((float)(b[i].t-b[j].t));
      ct++;
    }}
    
    ct=0;
    for(i=1;i<n;i++) {for(j=0;j<i;j++) {
      s[ct] = sin((float)(b[i].t-b[j].t));
      ct++;
    }}
    
  }
  
  void save() {
    saveFrame("../../inport/mat_###.png");
  }
  
}

