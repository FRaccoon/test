

void setup() {
  int v, a, b, c;
  
  v=0;
  
  a=11;
  b=13;
  c=15;
  
  for(int j=1;j<=(a*b-a-b);j++) {
    boolean t = false;
    for(int i=int(j/c);0<=i;i--) {
      if(f(a, b, j-c*i)) {
        t=true;
        break;
      }
    }
    if(!t)v=j;
  }
  
  println(v);
  
  exit();
}

boolean f(int a, int b, int v) {
  for(int i=int(v/b);0<=i;i--) {
    if((v-b*i)%a==0)return true;
  }
  return false;
}

void draw() {}
