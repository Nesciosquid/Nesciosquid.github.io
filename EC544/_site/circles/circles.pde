Circle a;
Circle b;
Circle c;
float c1x;
float c1r;
float c1y;
float c2x;
float c2r;
float c2y;
float c3x;
float c3r;
float c3y;

void setup(){
  c1x = 100;
  c1y = 100;
  c1r = 100;
  c2x = 300;
  c2y = 200;
  c2r = 100;
  c3x = 200;
  c3y = 350;
  c3r = 100;
  int c1c = color(255,0,0,150);
  int c2c = color(255,255,0,150);
  int c3c = color (0,0,255,150);
  
  size(400,400);
  background(255);
  stroke(0);
  noFill();
  a = new Circle(c1x, c1y, c1r, c1c);
  b = new Circle(c2x, c2y, c2r, c2c);
  c = new Circle(c3x, c3y, c3r, c3c);
  a.display();
}

void draw(){
  background(255);
  a.setRadius(a.calcDistance(mouseX, mouseY));
  b.setRadius(b.calcDistance(mouseX, mouseY));
c.setRadius(c.calcDistance(mouseX, mouseY));
  a.display();
  b.display();
c.display();
}

class Circle{
  float xpos;
  float ypos;
  float radius;
  int myColor = color(255);
  
  public Circle(float newX, float newY, float newR, color c){
    xpos = newX;
    ypos = newY;
    radius = newR;
    myColor = c;
  }

public float calcDistance(float x, float y){
  float xsum = xpos-x;
  float ysum = ypos-y;
  float xsq = xsum * xsum;
  float ysq = ysum * ysum;
  return (float)Math.sqrt(ysq+xsq);
}

public void setRadius(float r){
  radius = r;
}

public void display(){
  stroke(0);
  fill(myColor);
  ellipse(xpos, ypos, radius*2, radius*2);
}
}


