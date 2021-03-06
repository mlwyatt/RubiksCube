import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import javax.swing.Timer;
import java.util.concurrent.FutureTask;

Cube cube;
PeasyCam cam;
boolean debug;
Button up, right, front, down, left, back;
Button upP, rightP, frontP, downP, leftP, backP;
int eight;
boolean pause;
float rotating;
int direction;
char currentTurn;

void setup() {
  pause = false;
  size(800, 800, P3D);
  eight = height;
  initButtons();
  debug = false;
  cam = new PeasyCam(this, eight/2, eight/2, 0, eight);
  cam.setSuppressRollRotationMode();
  cube = new Cube();
  cube.scramble();

  PeasyDragHandler oldHandle = cam.getRotateDragHandler();
  HandleDragCube rotateHandle = new HandleDragCube(oldHandle);
  cam.setLeftDragHandler(rotateHandle);
  cam.setWheelScale(0);
  //cam.setWheelHandler(null); // throws NullPointerException
  cam.setCenterDragHandler(null);
  cam.setRightDragHandler(null);
  rotating = 0;
  direction = 0;
  frameRate(30);
}
void showCube() {
  pushMatrix();
  translate(eight/2, eight/2, 0);
  rotateX(PI/3);
  rotateZ(-PI/3);
  rectMode(CENTER);
  stroke(255,0,0);
  line(0,0,0,100,0,0);
  stroke(0,255,0);
  line(0,0,0,0,100,0);
  stroke(0,0,255);
  line(0,0,0,0,0,100);
  stroke(128,128,128);
  if(!debug)
  cube.show();
  popMatrix();
}

void draw() {
  textSize(32);
  background(128, 128, 128);
  strokeWeight(10);
  pushMatrix();
  cam.beginHUD();
  showButtons();
  if (debug)
    cube.showC();
  cam.endHUD();
  popMatrix();
  showCube();
  if (cube.isTurning) {
    rotating += direction*PI/30;
    if (abs(rotating) > PI/2) {
      rotating = 0;
      cube.resetTurning();
    }
  }
}

void keyPressed() {
  if (!cube.isTurning) {
    if (key == 'u')
      cube.turn("u");
    if (key == 'd')
      cube.turn("d");
    if (key == 'r')
      cube.turn("r");
    if (key == 'l')
      cube.turn("l");
    if (key == 'f')
      cube.turn("f");
    if (key == 'b')
      cube.turn("b");
    if (key == 'U')
      cube.turn("u'");
    if (key == 'D')
      cube.turn("d'");
    if (key == 'R')
      cube.turn("r'");
    if (key == 'L')
      cube.turn("l'");
    if (key == 'F')
      cube.turn("f'");
    if (key == 'B')
      cube.turn("b'");
    if (key == 's')
      cube.scramble();
    if (keyCode == ENTER) {
      cube.reset();
    }
  }
  if (key == 32) {
    debug = !debug;
  }
}

void mousePressed() {
  pause = buttonClicked();
  if (up.mouseIsOver()) {
    cube.turn("u");
  } else if (upP.mouseIsOver()) {
    cube.turn("u'");
  } else if (down.mouseIsOver()) {
    cube.turn("d");
  } else if (downP.mouseIsOver()) {
    cube.turn("d'");
  } else if (right.mouseIsOver()) {
    cube.turn("r");
  } else if (rightP.mouseIsOver()) {
    cube.turn("r'");
  } else if (left.mouseIsOver()) {
    cube.turn("l");
  } else if (leftP.mouseIsOver()) {
    cube.turn("l'");
  } else if (front.mouseIsOver()) {
    cube.turn("f");
  } else if (frontP.mouseIsOver()) {
    cube.turn("f'");
  } else if (back.mouseIsOver()) {
    cube.turn("b");
  } else if (backP.mouseIsOver()) {
    cube.turn("b'");
  }
}

void mouseReleased() {
  pause = false;
}


boolean buttonClicked() {
  return 
    up.mouseIsOver() || upP.mouseIsOver() || down.mouseIsOver() || downP.mouseIsOver() || 
    right.mouseIsOver() || rightP.mouseIsOver() || left.mouseIsOver() || leftP.mouseIsOver() || 
    front.mouseIsOver() || frontP.mouseIsOver() || back.mouseIsOver() || backP.mouseIsOver();
}

void initButtons() {
  int btnW=200, btnH=50;
  int ux=50, rx=300, fx=550;
  up = new Button("White", ux, 20, btnW, btnH);
  right = new Button("Orange", rx, 20, btnW, btnH);
  front = new Button("Blue", fx, 20, btnW, btnH);
  down = new Button("Yellow", ux, 80, btnW, btnH);
  left = new Button("Red", rx, 80, btnW, btnH);
  back = new Button("Green", fx, 80, btnW, btnH);

  upP = new Button("White'", ux, eight-70, btnW, btnH);
  // 50,height-70,200,50 => 50,730:250,780
  rightP = new Button("Orange'", rx, eight-70, btnW, btnH);
  frontP = new Button("Blue'", fx, eight-70, btnW, btnH);
  downP = new Button("Yellow'", ux, eight-130, btnW, btnH);
  leftP = new Button("Red'", rx, eight-130, btnW, btnH);
  backP = new Button("Green'", fx, eight-130, btnW, btnH);
}

void showButtons() {
  up.show();
  right.show();
  front.show();
  down.show();
  left.show();
  back.show();
  upP.show();
  rightP.show();
  frontP.show();
  downP.show();
  leftP.show();
  backP.show();
}


int find(int[] a, int target) {
  return Arrays.stream(a).boxed().collect(Collectors.toList()).indexOf(target);
}

public static void setTimeout(Runnable runnable, int delay){
  new Thread(runnable).start();
}
