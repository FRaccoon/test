
class Iden {
  World w;
  ArrayList<Mushi> ms;
  int n, l, g; //number, generation
  int count;
  
  Data[] d;
  
  Iden(World w,int n, int l) {
    this.w = w;
    
    this.n  = n;
    this.l = l;
    
    this.g = 0;
    
    d = new Data[3];
    for(int i=0;i<d.length;i++) {
      d[i] = new Data();
    }
    ms = new ArrayList<Mushi>();
    
    new_gene(true);
  }
  
  Iden(World w,int n, int l,String file_name) {
    this.w = w;
    
    this.n  = n;
    this.l = l;
    
    String[] str = loadStrings(file_name);
    
    this.g = int(str[0]);
    
    d = new Data[int(str.length/2)];
    for(int i=0;i<d.length;i++) {
      d[i] = new Data();
    }
    ms = new ArrayList<Mushi>();
    
    for(int i=0;i<d.length;i++) {
      d[i].input(str[2*i+1]);
    }
    
    new_gene(false);
  }
  
  void new_gene(boolean r) {
    if(g<1 || !r) {
      Data d_ = new Data();
      ms.clear();
      
      for(int i=0;i<this.n;i++) {
        d_.set(d[i%d.length]);
        if(!(i<d.length) && 0<g)d_.noise(.03);
        ms.add(new Mushi(this.w, this.l, d_));
      }
    }else {
      eval();
      Data d_ = new Data();
      ms.clear();
      
      for(int i=d.length;i<this.n;i++) {
        d_.set(d[i%d.length]);
        if(!(i<d.length))d_.noise(.03);
        ms.add(new Mushi(this.w, this.l, d_));
      }
    }
    count = 0;
    g++;
    println(g);
  }
  
  float eval_m(int i) {
    return ms.get(i).get_c().x;
  }
  
  void eval() {
    int[] t = new int[d.length];
    for(int i=0;i<d.length;i++) {
      int j;
      for(j=0;j<i;j++) {
        if(eval_m(t[j])<eval_m(i))break;
      }
      int v=t[j];
      t[j]=i;
      for(int k=j+1;k<i;k++) {
        int v_=t[k];
        t[k]=v;
        v=v_;
      }
    }
    
    for(int i=d.length;i<ms.size();i++) {
      if(eval_m(i)<eval_m(t[d.length-1]))continue;
      int j;
      for(j=0;j<d.length;j++) {
        if(eval_m(t[j])<eval_m(i))break;
      }
      int v=t[j];
      t[j]=i;
      for(int k=j+1;k<d.length;k++) {
        int v_=t[k];
        t[k]=v;
        v=v_;
      }
    }
    
    for(int i=0;i<d.length;i++) {
      d[i].set(ms.get(t[i]).d);
    }
    
  }
  
  void update() {
    
    if(count>9999)new_gene(true);
    
    for(Mushi m : ms) {
      m.update();
    }
    count++;
  }
  
  void draw() {
    int i=0;
    for(Mushi m : ms) {
      pushMatrix();
      translate(0, 0, -i*250);
      m.draw();
      popMatrix();
      i++;
    }
  }
  
}

