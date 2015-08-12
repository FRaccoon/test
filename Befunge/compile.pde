
final int nx=40,ny=25;
final int s=20;
final int[] dx = { 0, 1, 0, 0,-1};
final int[] dy = { 0, 0, 1,-1, 0};

char[][] a;

int px,py;
int n;

ArrayList<Integer> stack;
int pop(){
  int s=0;
  if(stack.size()>0){
    s=stack.get(stack.size()-1);
    stack.remove(stack.size()-1);
  }
  return s;
}
void push(int v){
  stack.add(v);
}

String output;

boolean jump;
boolean ascii;

boolean fin;
boolean ing;

int speed;

void compile(){
  char k = a[px][py];
  
  if(ascii){
    if(k=='"')ascii=false;
    else push(int(k));
  }else {
  if(jump){
    jump = !jump;
  }else {
  int x=0,y=0,v=0;
  switch(k){
    case '>':n=1;break;
    case '<':n=4;break;
    case 'v':n=2;break;
    case '^':n=3;break;
    case '_':
    if(pop()==0)n=1;
    else n=4;
    break;
    case '|':
    if(pop()==0)n=2;
    else n=3;
    break;
    case '?':
    n = 1+(int)random(0,4);
    break;
    case '#':jump=true;break;
    case '@':ing=false;n=0;break;//actually exit();
    case ' ':break;
    case '"':ascii=true;break;
    
    case '+':y=pop();x=pop();push(x+y);break;
    case '-':y=pop();x=pop();push(x-y);break;
    case '*':y=pop();x=pop();push(x*y);break;
    case '/':y=pop();x=pop();push(x/y);break;
    case '%':y=pop();x=pop();push(x%y);break;
    case '`':y=pop();x=pop();push((x>y?1:0));break;//shift+@
    case '!':push((pop()==0?1:0));break;
    
    case ':':x=pop();push(x);push(x);break;
    case 92:y=pop();x=pop();push(y);push(x);break;//back-slash
    case '$':x=pop();break;
    
    case 'g':y=pop();x=pop();
    push(int(a[ad(x,0,nx)][ad(y,0,ny)]));break;
    case 'p':y=pop();x=pop();v=pop();
    a[ad(x,0,nx)][ad(y,0,ny)]=char(v);break;
    
    case '.':output+=pop()+" ";break;
    case ',':output+=char(pop());break;
    
    case '&':fin=false;break;
    case '~':fin=false;break;
    
  }
  for(int i=0;i<10;i++){
    if(k==i+int('0')){
      push(i);
      break;
    }
  }
  }
  }
  
  if(ing && fin){
  px=ad(px,dx[n],nx);
  py=ad(py,dy[n],ny);
  }
  
}

