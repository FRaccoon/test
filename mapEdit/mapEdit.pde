import java.awt.*;
import javax.swing.*;

MEditer mediter;

void setup(){
  size(720, 500);
  
  mediter = new MEditer();
  
}

void draw(){
  background(0);
  mediter.update();
  mediter.draw();
}

void mousePressed(){
  mediter.mousePressed();
}

void mouseReleased(){
  mediter.mouseReleased();
}

void mouseWheel(MouseEvent event) {
  mediter.mouseWheel(event.getCount());
}

void keyPressed(){
  mediter.keyPressed();
}

void keyReleased(){
  mediter.keyReleased();
}