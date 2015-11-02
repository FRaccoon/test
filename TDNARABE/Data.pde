
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
  
  int get(int x, int y, int z) {
    return d[x][y][z];
  }
  
  boolean add(int x, int y, int c) {
    if(x<0 || n<=x)return false;
    if(y<0 || n<=y)return false;
    
    if(h[x][y]>n)return false;
    
    d[x][y][h[x][y]] = c;
    h[x][y]++;
    
    return true;
  }
  
}