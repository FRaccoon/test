
int[] n = {13, 11, 9, 7};
int[][] m;
int[] s;

boolean[] v;

void setup() {
  int i, j, k;
  
  v = new boolean[18];
  
  m = new int[n.length][v.length];
  s = new int[n.length];
  
  for(i=0;i<n.length;i++) {
    set_(n[i], 0, m[i]);
  }
  
  //ArrayList<String> str = new ArrayList<String>();
  
  for(k=1;k<(1<<(v.length+1));k++) {
    for(i=0;i<v.length;i++) {
      v[i] = ((k/(1<<i))%2==1);
    }
    
    for(i=0;i<s.length;i++) {s[i] = 0;}
    boolean t=true;
    for(i=0;i<s.length;i++) {
      for(j=0;j<v.length;j++) {
        if(v[j])s[i] += m[i][j];
      }
      if(s[i]%n[i]!=0){
        t=false;
        break;
      }
    }
    
    if(t) {
      String val = "";
      boolean t2=false;
      for(i=v.length-1;!(i<0);i--) {
        //val = val+(v[i]?"1":"0");
        if(v[i]) {
          val = val+"1";
          if(!t2)t2=true;
        }else if(t2)val = val+"0";
      }
      println("number : "+val);
      //str.add(val);
      break;
    }
  }
  
  /*
  String[] res = new String[str.size()];
  for(i=0;i<res.length;i++) {
    res[i] = str.get(i);
  }
  saveStrings("result.txt", res);
  */
  
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

