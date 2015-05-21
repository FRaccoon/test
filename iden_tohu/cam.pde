
class Cam {
  PVector pos, dir, up;
  float l;
  
  Cam() {
    pos = new PVector(width/2, 0, 1000);
    dir = new PVector(width/2, height/2, 0);dir.sub(pos);
    
    up = new PVector(0, 1, 0);
  }
  
  void cam() {
    camera(pos.x, pos.y, pos.z,
    pos.x+dir.x, pos.y+dir.y, pos.z+dir.z,
    up.x, up.y, up.z);
  }
  
  void keyPressed() {
    if(keyCode==CODED) {
      PVector r;
      switch(key) {
        case 'a':
        r = new PVector(dir.x, dir.z);
        r.rotate(-.03);
        dir.set(r.x, dir.y, r.y);
        break;
        case 'd':
        r = new PVector(dir.x, dir.z);
        r.rotate(.03);
        dir.set(r.x, dir.y, r.y);
        break;
        case 'w':
        r = new PVector(dir.y, dir.z);
        r.rotate(-.03);
        dir.set(dir.x, r.x, r.y);
        break;
        case 's':
        r = new PVector(dir.y, dir.z);
        r.rotate(.03);
        dir.set(dir.x, r.x, r.y);
        break;
        case 'z':
        loop();
        break;
        case 'x':
        noLoop();
        break;
        case 'q':
        pos.y -= 10.0;
        break;
        case 'e':
        pos.y += 10.0;
        break;
      }
    }else {
      PVector r = new PVector(dir.x, dir.z);
      r.setMag(50);
      switch(keyCode) {
        case UP:
        pos.x += r.x;
        pos.z += r.y;
        break;
        case DOWN:
        pos.x -= r.x;
        pos.z -= r.y;
        break;
        case RIGHT:
        r.rotate(PI/2);
        pos.x += r.x;
        pos.z += r.y;
        break;
        case LEFT:
        r.rotate(PI/2);
        pos.x -= r.x;
        pos.z -= r.y;
        break;
      }
    }
  }
  
}

