
int[] n = {19, 17, 13, 11, 7};
int[][] m;
int[] s;

boolean[] v;

void setup() {
  int i, j;
  
  v = new boolean[17];
  
  m = new int[n.length][v.length];
  s = new int[n.length];
  
  for(i=0;i<n.length;i++) {
    set_(n[i], 0, m[i]);
  }
  
  for(i=0;i<v.length;i++) {
    v[i] = (i<9);
  }
  
  for(i=0;i<s.length;i++) {
    s[i] = 0;
  }
  for(i=0;i<s.length;i++) {
    for(j=0;j<v.length;j++) {
      if(v[j])s[i] += m[i][j];
    }
    s[i] %= n[i];
  }
  
  String val = "";
  boolean t = false;
  for(i=v.length-1;!(i<0);i--) {
    if(v[i]) {
      val = val+"1";
      if(!t)t=true;
    }else if(t)val = val+"0";
  }
  
  println("number : "+val);
  
  for(i=0;i<n.length;i++) {
    println(s[i]+" : mod "+n[i]);
  }
  
  exit();
}

void draw() {
  
}

void set_(int a,int e,int[] i) {
  if(!(e<i.length))return ;
  if(e<1)i[e]=1;
  else i[e] = (i[e-1]*10)%a;
  set_(a, e+1,i);
}

