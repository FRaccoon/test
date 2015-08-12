
void setup() {
  size(nx*s,(ny+1)*s);
  
  textSize(s);
  textAlign(LEFT,TOP);
  
  a = new char[nx][ny];
  
  px=0;
  py=0;
  n=1;
  
  stack = new ArrayList<Integer>();
  output = "";
  
  jump = false;
  ascii = false;
  
  ex=0;
  ey=0;
  m=1;
  
  speed=6;
  
  ing=false;
  fin=true;
  
  for(int i=0;i<nx;i++){
    for(int j=0;j<ny;j++){
      a[i][j] = ' ';
    }
  }
  
}

void draw() {
  background(0);
  
  for(int i=0;i<nx;i++){
    for(int j=0;j<ny;j++){
      if(px==i && py==j){
        stroke(255,0,0);noFill();
        rect(i*s,j*s,s,s);
        noStroke();fill(255,0,0);
        text(a[i][j],i*s,j*s);
      }else if(ex==i && ey==j){
        stroke(0,255,0);noFill();
        rect(i*s,j*s,s,s);
        noStroke();fill(255);
        text(a[i][j],i*s,j*s);
      }else {
        stroke(255);noFill();
        rect(i*s,j*s,s,s);
        noStroke();fill(255);
        text(a[i][j],i*s,j*s);
      }
    }
  }
  
  if(frameCount%speed==0 && ing && fin)compile();
  
  text(">>"+output,0,ny*s);
  
}

