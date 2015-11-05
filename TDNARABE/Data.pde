
class Data {
  Game g;
  int n=4;
  
  int[][][] d; // data(x, y, z); 0:none, 1:white, 2:black;
  int[][] h; // high
  
  Data(Game g) {
    this.g = g;
    d = new int[n][n][n];
    h = new int[n][n];
  }
  
  void reset() {
    for(int i=0;i<n;i++) {
      for(int j=0;j<n;j++) {
        for(int k=0;k<n;k++) {
          d[i][j][k]=0;
        }
        h[i][j]=0;
      }
    }
  }
  
  int get_h(int x, int y) {
    return h[x][y];
  }
  
  int get(int x, int y, int z) {
    return d[x][y][z];
  }
  
  boolean add(int x, int y, int c) {
    if(x<0 || n<=x)return false;
    if(y<0 || n<=y)return false;
    
    if(h[x][y]>=n)return false;
    
    d[x][y][h[x][y]] = c;
    h[x][y]++;
    
    return true;
  }
  
  boolean check(int x, int y) {
    if(h[x][y]<=0)return false;
    else return this.check(x, y, h[x][y]-1);
  }
  
  boolean check(int x, int y, int z) {
    if(d[x][y][z]==0)return false;
    
    if(cl(x, y, z, 1, 0, 0))return true;
    if(cl(x, y, z, 0, 1, 0))return true;
    if(cl(x, y, z, 0, 0, 1))return true;
    
    if(x == y && cl(x, y, z, 1, 1, 0))return true;
    if(x==3-y && cl(x, y, z, 1,-1, 0))return true;
    if(y == z && cl(x, y, z, 0, 1, 1))return true;
    if(y==3-z && cl(x, y, z, 0, 1,-1))return true;
    if(z == x && cl(x, y, z, 1, 0, 1))return true;
    if(z==3-x && cl(x, y, z,-1, 0, 1))return true;
    
    if((x == y && x == z) && cl(x, y, z, 1, 1, 1))return true;
    if((x == y && x==3-z) && cl(x, y, z, 1, 1,-1))return true;
    if((x==3-y && x == z) && cl(x, y, z, 1,-1, 1))return true;
    if((x==3-y && x==3-z) && cl(x, y, z,-1, 1, 1))return true;
    
    return false;
  }
  
  boolean cl(int x, int y, int z, int dx, int dy, int dz) {
    for(int j=1;j<this.n;j++) {
      if(d[(x+j*dx+this.n)%this.n][(y+j*dy+this.n)%this.n][(z+j*dz+this.n)%this.n]!=d[x][y][z])return false;
    }
    return true;
  }
}