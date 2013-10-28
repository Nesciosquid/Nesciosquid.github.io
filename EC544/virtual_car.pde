Car a;
float velocity;
float min_target; 
  float new_target;
PFont f;
float max_target; 
float hall_left;
float hall_right;
String[] readouts;

void setup(){
  size(1200, 800);
  readouts = new String[10];
  f = createFont("Arial",16,true);
  background(255);
  smooth();
  velocity = 10.0;
  a = new Car(400, 250);
  hall_left = 300.0;
  hall_right = 1100.0;
  new_target = (hall_left + hall_right / 2);
  min_target = hall_left + a.totalWidth;
  max_target = hall_right - a.totalWidth;
  frameRate(30);
}

void mouseWheel(MouseEvent event) {
  float e = event.getAmount();
  velocity += -e;
}

void draw(){
  fill(255, 255);
  rectMode(CORNERS);
  rect(0,0,width,height);
  float new_theta;
  float new_turn;
  stroke(255);
  stroke(#0821FA);
  line(new_target, 0, new_target, height);
  stroke(0);
  fill(50);
  
  rect(0, 0, hall_left, height);
  rect(hall_right, 0, width, height);
  if (mousePressed)
  {
    stroke(255);
    line(new_target, 0, new_target, height);
    
    new_target = mouseX;
    if (new_target < min_target){
      new_target = min_target;
      stroke(#FA1408);
      line(new_target, 0, new_target, height);
    }
    else if (new_target > max_target){
      new_target = max_target;
            stroke(#FA1408);
      line(new_target, 0, new_target, height);
    }
    stroke(0, 50);
    line(mouseX, 0, mouseX, height);
  }
    
      new_theta = a.calcTheta();
      new_turn = a.calcTurn(new_theta);
          a.setTarget(new_target);
    a.setTurn(new_turn);
    a.updateFrontWheels();
    a.updateTheta();
    a.updatePosition();
    a.setVelocity(velocity);
    a.display();
    
    readouts[0] = "Car Position: " + a.xpos;
    readouts[1] = "Target Position: " + new_target;
    readouts[2] = "Car theta: " + degrees(a.theta);
    readouts[3] = "Target theta: " + degrees(new_theta);
    readouts[4] = "Car Velocity: " + a.velocity;  
    readouts[5] = "Car Turn Value: " + a.myTurn;
    readouts[6] = "";
    readouts[7] = "";
    readouts[8] = "";
    readouts[9] = "";
    
      textFont(f,16);
      fill(255);
      
         for (int i = 0; i < readouts.length; i++){
                 text(readouts[i], 10, 100+20*i);
         }

}

class Wheel{
  float xpos;
  float ypos;
  float centerTurn = 1500;
  float turnAmount = 1500; // 1000 == full right
  float turnTheta;
  float wheelLength = 30.0;
  float wheelWidth = 20.0;
  float xsize;
  float maxTheta = radians(30.0);
  color wheelColor = color(255, 50);
  int wheelStroke = 0;
  
  Wheel(float newX, float newY){
    xpos = newX;
    ypos = newY;
    updateTheta();
  }
  
  float getTurn(){
    return turnAmount;
  }
  
  float getX(){
    return xpos;
  }
  
  float getY(){
    return ypos;
  }
  
  float getTheta(){
    return turnTheta;
  }
  
  void updateTheta(){
    float turnDiff = (turnAmount - centerTurn); //-500 for right, 500 left
    turnTheta = (float)(turnDiff / 500) * maxTheta;
  }
  
  void updateTurn(float turn){
    turnAmount = turn;
    updateTheta();
  }
  
  void display(){
    rectMode(CENTER);
    stroke(wheelStroke);
    fill(wheelColor);
    rect(0,0,wheelWidth, wheelLength);
  }
}
  
class Car{
  
  float velocity = 15.0;
  float targetX = 400.0;
  float leftWallDistance = -20.0;
  float rightWallDistance = 20.0;
  Wheel[] wheels = new Wheel[4];
  float theta = radians(0);
  float xpos;
  float ypos;
  float myTurn;
  float topLength = 100.0;
  float maxAngle = 35.0;
  float turnLength = 250.0;
  float topWidth = 50.0;
  float totalWidth = 75.0;
  float totalLength = 125.0;
  color topColor = color(200, 150);
  int topStroke = 0;
  color totalColor = color(86, 155, 105, 50);
  int totalStroke = 0;
  
    Car(float x, float y){
      xpos = x;
      ypos = y;
      wheels[0] = new Wheel(-totalWidth/2, -totalLength/2);
      wheels[1] = new Wheel(totalWidth/2, -totalLength/2);
      wheels[2] = new Wheel(-totalWidth/2, totalLength/2);
      wheels[3] = new Wheel(totalWidth/2, totalLength/2);
    }
    
    void setTarget(float x){
      targetX = x;
    }
    
    void setVelocity(float new_vel){
      velocity = new_vel;
    }
    
    float calcTheta(){
      float posdiff = targetX - xpos;
      float diff_ratio = posdiff / turnLength;
      if (diff_ratio > 1.0){
        diff_ratio = 1.0;
      }
      else if (diff_ratio < -1.0){
        diff_ratio = -1.0;
      }
      if (velocity > 0){
        
      return radians(maxAngle) * diff_ratio;
      }
      else 
      return radians(maxAngle) * diff_ratio;
       }
   
   
   float calcTurn(float theta_rad){
     float thetadiff;
     if (velocity > 0 ){
     thetadiff = theta_rad - theta;
     }
     else thetadiff = theta_rad + theta;
     float theta_ratio = thetadiff / radians(maxAngle);
     if (theta_ratio > 1.0){
       theta_ratio = 1.0;
     }
     else if (theta_ratio < -1.0){
       theta_ratio = -1.0;
     }
     return 1500 + (500 * theta_ratio);
   }
     
    
    void updatePosition(){
            if (xpos > width+totalWidth){
       xpos = 0+(xpos-(width+totalWidth));
    }
      if (ypos > height+totalLength){
        ypos = 0+(ypos-height-totalLength);}
      if (xpos < 0){
        xpos = width + xpos + totalWidth;
      }
      if (ypos < 0){
        ypos = height + ypos+totalLength;
      }
    
      xpos += sin(theta) * velocity;
      ypos -= cos(theta) * velocity;
    }
    
      void updateTheta(){
     float newt =  ((wheels[0].getTheta() / 45.0) * velocity) / 2;
      
    theta = (theta +newt) % TWO_PI;}
    
    void setXY(float x, float y){
      xpos = x;
      ypos = y;
    }
    
    void setY(float y){
      ypos = y;
    }
    
    void setTheta(float theta_rad){
      theta = theta_rad;
    }
    
    void setTurn(float newTurn){
      myTurn = newTurn;
    }
    
    void updateFrontWheels(){
      for (int i = 0; i < 2; i ++){
        wheels[i].updateTurn(myTurn);
             }
    }
      
    
    void drawWheels(){
      for (int i = 0; i < wheels.length; i++){
        Wheel currentWheel = wheels[i];
        pushMatrix();
        translate(currentWheel.getX(), currentWheel.getY());
        rotate(currentWheel.getTheta());
        currentWheel.display();
        popMatrix();
      }
    }
    
    void display(){
      pushMatrix();
      translate(xpos, ypos);
      rotate(theta);
      rectMode(CENTER);
      fill(totalColor);
      stroke(totalStroke);
      rect(0,0, totalWidth, totalLength);
      fill(topColor);
      stroke(topStroke);
      rect(0,0, topWidth, topLength);
      drawWheels();
      popMatrix();
      
    }
}


