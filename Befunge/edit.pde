
int ex,ey;
int m;

int ad(int pn,int an,int qn){
  return (((pn+an)%qn)+qn)%qn;
}

void mouseReleased(){
  ex=mouseX/s;
  ey=mouseY/s;
}

void keyPressed(){
  if(key==CODED){
    if(keyCode==UP)m=3;
    else if(keyCode==DOWN)m=2;
    else if(keyCode==RIGHT)m=1;
    else if(keyCode==LEFT)m=4;
    else if(keyCode==CONTROL){
      if(speed>5)speed=1;
      else speed=6;
    }
  }else {
    if(keyCode==BACKSPACE){
      a[ex][ey]=' ';
      m=4;
    }else if(keyCode==ENTER){
      m=2;
    }else if(keyCode==TAB){
      ing = !ing;
      println(stack);
    }else {
      if(fin) {
      a[ex][ey]=key;
      if(key=='>')m=1;
      else if(key=='v')m=2;
      else if(key=='^')m=3;
      else if(key=='<')m=4;
      }else {
        if(a[px][py]=='&'){
          for(int i=0;i<10;i++){
            if(key==i+int('0')){
              push(i);
              fin=true;
              px=ad(px,dx[n],nx);
              py=ad(py,dy[n],ny);
              break;
            }
          }
        }else if(a[px][py]=='~'){
          push(int(key));
          fin=true;
          px=ad(px,dx[n],nx);
          py=ad(py,dy[n],ny);
        }else {
          println("error");
          fin=true;
        }
      }
    }
  }
  if(keyCode!=TAB&&keyCode!=SHIFT&&
  keyCode!=CONTROL&&keyCode!=ALT){
  ex=ad(ex,dx[m],nx);
  ey=ad(ey,dy[m],ny);
  }
  if(keyCode==LEFT||keyCode==RIGHT||
  keyCode==UP||keyCode==DOWN||
  keyCode==BACKSPACE||keyCode==ENTER)m=1;
}

