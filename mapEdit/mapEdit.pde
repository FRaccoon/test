import java.awt.event.*;
import java.awt.*;
import javax.swing.*;

Editer editer;

void setup(){
  size(720, 500);
  
  editer = new Editer();
  
}

void draw(){
  background(0);
  editer.draw();
}

void mousePressed(){
  editer.mousePressed();
}

void mouseReleased(){
  editer.mouseReleased();
}

void mouseWheel(int delta){
  editer.mouseWheel(delta);
}

void keyPressed(){
  editer.keyPressed();
}
void keyReleased(){
  editer.keyReleased();
}

