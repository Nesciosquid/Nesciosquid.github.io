import java.util.Date;

PFont f;
static Node origin;
static Node leaderEx;
static node nonLeaderEx;
static node lostEx;
static Node infectedEx;
Node a;
Node b;
boolean shift = false;
boolean alt = false;
Node c;
int nodeIndex;
Node d;
Node e;
int nodeDelay;
boolean ctrl;

Node[] allNodes = null;
public void setup() {
  //size(700, 700);
  size(window.innerWidth-50, window.innerHeight-50);
  //size(displayWidth, displayHeight);
  //hint(ENABLE_STROKE_PURE);
  smooth();
  frameRate(20);
  f = createFont("Arial", 32, true);
  origin = new Node(100000, 0, 0); 
  leaderEx = new Node(0, 40, 320);
  leaderEx.hasLeader = true;
  leaderEx.isLeader = true;
  nonLeaderEx = new Node(11, 40, 390);
  nonLeaderEx.hasLeader = true;
  lostEx = new Node(12, 40, 430);
  lostEx.setState("left");
  infectedEx = new Node(13, 40, 470);
  infectedEx.hasLeader = true;
  infectedEx.setState("infected");
  
  nodeIndex = 0;
  nodeDelay = 50;
  randomNodes(50);
  calcNeighbors();
}

public void randomNodes(int number) {
  for (int i = 0; i < number; i ++) {
    allNodes = origin.storeNode(allNodes, new Node(nodeIndex, random(50, width-50), random(50, height-50)));
    nodeIndex++;
    //System.out.println("Storing new node at" + mouseX + ", " + mouseY);
  }
}

public void processNodes() {
  if (allNodes != null) {
    for (int i = 0; i < allNodes.length; i ++) {
      allNodes[i].checkLeaderStatus();
      allNodes[i].processMessages();
    }
  }
}



public void calcNeighbors() {
  if (allNodes != null) {
    for (int i = 0; i < allNodes.length; i++) {
      allNodes[i].findNeighbors(allNodes);
    }
  }
}


public void keyPressed() {
  if (key == ENTER || key == RETURN) {
    allNodes = null;
    nodeIndex = 0;
  }
  else if (key == CODED) {
    if (keyCode == SHIFT) {
      shift= true;
    }
    else if (keyCode == ALT) {
      alt = true;
    }
    else if (keyCode == CONTROL){
      ctrl = true;
    }
  }
}

public void keyReleased() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      shift= false;
    }
    else if (keyCode == ALT) {
      alt = false;
    }
  
  else if (keyCode == CONTROL){
    ctrl = false;
  }
}
}

public void drawNodes() {
  if (allNodes != null) {
    for (int i = 0; i < allNodes.length; i++) {
      allNodes[i].drawConnections();
    }
    for (int i = 0; i < allNodes.length; i++) {
      allNodes[i].display();
    }
  }
}

public void broadcastNodes() {
  if (allNodes != null) {
    for (int i = 0; i < allNodes.length; i++) {
      allNodes[i].broadcastMessages();
    }
  }
}

public void strobeNodes() {
  if (allNodes != null) {
    for (int i = 0; i < allNodes.length; i++) {
      allNodes[i].randomState();
    }
  }
}

public boolean overCircle(float x, float y, float diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } 
  else {
    return false;
  }
}

void mouseDragged() {

  if (mouseButton == LEFT) {
    boolean overNode = false;
    if (allNodes != null) {
      for (int i = 0; i < allNodes.length; i ++) {
        if (overCircle(allNodes[i].xpos, allNodes[i].ypos, allNodes[i].mySize*4))
          overNode = true;
      }
    }
    if (!overNode) {
      allNodes = origin.storeNode(allNodes, new Node(nodeIndex, mouseX, mouseY));
      nodeIndex++;
      //System.out.println("Storing new node at" + mouseX + ", " + mouseY);
    }
  }

  else {
    if (allNodes != null) {
      int index = 0;
      boolean deleteNode = false;
      for (int i = 0; i < allNodes.length; i ++) {
        if (overCircle(allNodes[i].xpos, allNodes[i].ypos, allNodes[i].mySize)) {
          index = i;
          deleteNode = true;
        }
      }
      if (deleteNode == true) {
        //System.out.println(allNodes.length);
        allNodes = origin.removeNode(allNodes, index);
        for (int i = 0; i < allNodes.length; i ++) {
        }
      }
    }
  }
  calcNeighbors();
}

void drawLegend(){
  if (ctrl){
  rectMode(NORMAL);
  stroke(0);
  strokeWeight(2);
  fill(100, 100, 100, 200);
  rect(0,0,350,500,30);
  strokeWeight(1);
  textFont(f, 20);
  fill(255);
  text("Leader Election", 100, 30);
  textFont(f,15);
  
  text("Left-click to place nodes.", 20, 60);
  text("Right-click to clear nodes. (Enter to clear all)", 20, 80);
  text("Click and drag for fast deployment.", 20, 100);
  
  text("HOLD SHIFT:", 20, 140);
  text("Left-click to toggle state lock.", 20, 160);
  text("Right-click to transmit or infect.", 20, 180);
  
  
  text("HOLD ALT:", 20, 220);
  text("Left-click to toggle all state locks.", 20, 240);
  text("Right-click to transmit/infect all nodes.", 20, 260);
  
  text("Leaders: ", 90, 300);
  text("Transmit state once.", 90, 320);
  text("Immune to infection.", 90, 340);
  
  text("Non-leaders: ", 90, 370);
  text("Elect lower-ID leaders.", 90, 390);
  text("Get confused when leaders are lost.", 90, 410);
  text("Can infect other nearby nodes.", 90, 430);
  text("Susceptible to infection.", 90, 450);
  text("Spread infection until cured.", 90, 470);
  text("Must be cured by leader transmission.", 90, 490);
  
  leaderEx.display();
  nonLeaderEx.display();
  lostEx.display();
  infectedEx.display();
  }
  else {
    rectMode(NORMAL);
    stroke(0);
    strokeWeight(2);
    fill(100,100,100,100);
    rect(0,0,80,25,15);
    strokeWeight(1);
    textFont(f,16);
    fill(255);
    text("CTRL", 20, 20);
  }
}



void mousePressed() {
  if (shift) {
    if (allNodes != null) {
      for (int i = 0; i < allNodes.length; i ++) {
        if (overCircle(allNodes[i].xpos, allNodes[i].ypos, allNodes[i].mySize)) {
          if (mouseButton == LEFT) {
            allNodes[i].pressButton1();
          }
          else {
            allNodes[i].pressButton2();
          }
        }
      }
    }
  }
  else if (alt) {
    if (allNodes != null) {
      for (int i = 0; i < allNodes.length; i++) {
        if (mouseButton == LEFT) {
          allNodes[i].pressButton1();
        }
        else {
          allNodes[i].pressButton2();
        }
      }
    }
  }
  else {
    if (mouseButton == LEFT) {
      boolean overNode = false;
      if (allNodes != null) {
        for (int i = 0; i < allNodes.length; i ++) {
          if (overCircle(allNodes[i].xpos, allNodes[i].ypos, allNodes[i].mySize*2))
            overNode = true;
        }
      }
      if (!overNode) {
        allNodes = origin.storeNode(allNodes, new Node(nodeIndex, mouseX, mouseY));
        nodeIndex++;
        //System.out.println("Storing new node at" + mouseX + ", " + mouseY);
      }
    }
    else if (mouseButton == RIGHT && allNodes != null) {
      if (allNodes != null) {
        int index = 0;
        boolean deleteNode = false;
        for (int i = 0; i < allNodes.length; i ++) {
          if (overCircle(allNodes[i].xpos, allNodes[i].ypos, allNodes[i].mySize)) {
            index = i;
            deleteNode = true;
          }
        }
        if (deleteNode == true) {
          //System.out.println(allNodes.length);
          allNodes = origin.removeNode(allNodes, index);
          for (int i = 0; i < allNodes.length; i ++) {
          }
        }
      }
    }
    calcNeighbors();
  }
}

public void draw() {
  background(255);
  processNodes();
  drawNodes();
  strobeNodes();
  broadcastNodes();
  drawLegend();
  if (allNodes != null && allNodes[0].availableMessages != null) {
  }
}

class Message {
  String content;
  String ID;
  int issuerID;

  Message(String newID, String newContent, int issuer) {
    content = newContent;
    ID = newID;
    issuerID = issuer;
  }

  public String getID() {
    return ID;
  }

  public int getIssuer() {
    return issuerID;
  }

  public String getCommand() {
    return content;
  }
}

class Node {
  boolean hasLeader = false;
  boolean isLeader = false;
  boolean infected = false;
  boolean awaitingVictory = false;
  int leaderAddress;
  boolean neighborChange = true;
  Date d;
  Node[] myNetwork; 
  Node[] myNeighbors;
  public float xpos = 0.0f;
  long nominationTimeout = 1000;
  long leaderTimeout = 1000;
  long leadershipTimeout = 1500;
  boolean isNominated = false;
  long timeToVictory = 0;
  long timeToPanic = 0;
  public float ypos = 0.0f; 
  public float radius = 120.0f;
  public Message[] availableMessages;
  public Message[] outgoingMessages;
  public Message lastInfection;
  float mySize = 30.0f;
  String myState = "right";
  boolean lock = false;
  public int myAddress;
  HashMap seenMessages = new HashMap();
  int myStroke = 0;
  int myStrokeWeight = 2;
  color red = color(200, 0, 0); // infected
  color blue = color(0, 0, 255); // left
  color green = color(0, 255, 0); // right
  color lightGray = color(200,200,200);
  color darkGray = color(100,100,100); 
  color white = color(255, 255, 255); // none
  color black = color(0, 0, 0); // unknown
  color myColor = white;
  color myTextColor = black;

  public void checkLeaderStatus() {
    if (neighborChange == true) {
      nominateSelf();
      neighborChange = false;
    }
    if (isLeader) {
      //System.out.println(myAddress + " is the leader");
      if (millis() >= timeToPanic) {
        announceVictory();
        //System.out.println(myAddress + " re-asserts his dominance!");
      }
    }
    else {
      if (hasLeader) {
        if (millis() >= timeToPanic) {
          hasLeader = false; // haven't heard from Leader in too long, he must be dead, oh noes!
          timeToPanic = 0;
          //System.out.println(myAddress + " can't find the leader!");
        }
      }
      else {
        if (isNominated) {
          if (millis() >= timeToVictory) {
            announceVictory();
            //System.out.println(myAddress + " is victorious!");
          }
        }
        else if (awaitingVictory) {
          if (millis() >= timeToVictory) {
            nominateSelf();
            //System.out.println(myAddress + " didn't see a winner!");
          }
        }

        else
        {
          nominateSelf();
        }
      }
    }
  }


  public Node(int newAddress, float newX, float newY) {
    myAddress = newAddress;
    xpos = newX;
    ypos = newY;
    updateColor();
    unlock();
  }

  public int getAddress() {
    return myAddress;
  }

  public void broadcastMessages() {
    if (myState.equals("infected")) {
      outgoingMessages = storeMessage(outgoingMessages, lastInfection);
    }
    if (outgoingMessages != null) {
      for (int i =0 ; i < outgoingMessages.length; i ++) {
        broadcastMessage(outgoingMessages[i]);
      }
      outgoingMessages = null;
    }
  }

  public void processMessages() {
    if (availableMessages != null) {
      for (int i =0 ; i < availableMessages.length; i ++) {
        readMessage(availableMessages[i]);
        //System.out.println("Reading message ID: " + availableMessages[i].getID() + ", command: " + availableMessages[i].getCommand());
      }
      availableMessages = null;
      updateColor();
      //System.out.println("No messages for node: " + myAddress);
    }
  }

  public void readMessage(Message incomingMessage) {
    if (incomingMessage != null){
    String messageID = incomingMessage.getID();
    int issuerID = incomingMessage.getIssuer();
    if (seenMessages.containsKey(messageID) == false) {
      seenMessages.put(messageID, incomingMessage);
      executeCommand(incomingMessage);
    }
  }
  }

  public boolean doIWin(int challengerAddress) {
    if (myAddress < challengerAddress) {
      //System.out.println(myAddress + " wins against " + challengerAddress);
      return true;
    }
    else {
      //System.out.println(myAddress + " loses against " + challengerAddress);
      return false;
    }
  }

  public void executeCommand(Message newMessage) {
    String command = newMessage.getCommand();
    int issuerID = newMessage.getIssuer();
    if (command.equals("elect")) {
      if (myAddress != issuerID) {
        if (doIWin(issuerID)) {
          if (isNominated) {
            writeMessage("elect");
          }
          else {
            nominateSelf();
          }
        }
        else {
          concede();
          forwardMessage(newMessage);
        }
      }
    }

    if (command.equals("victory")) {
      if (doIWin(issuerID)) {
        nominateSelf();
      }
      else {
        allHailOurGloriousLeader(issuerID);
        forwardMessage(newMessage);
      }
    }    
    if (command.equals("left")) {
      myState = "left";
      lock = true;
      forwardMessage(newMessage);
    }
    if (command.equals("right")) {
      myState = "right";
      lock = true;
      forwardMessage(newMessage);
    }
    if (command.equals("none")) {
      myState = "none";
      lock = true;
      forwardMessage(newMessage);
    }
    if (command.equals("infected")) {
      if (!isLeader) {
        myState = "infected";
        lock = true;
        lastInfection = newMessage;
      }
    }
    updateColor();
  }

  public void forwardMessage(Message newMessage) {
    outgoingMessages = storeMessage(outgoingMessages, newMessage);
  }

  public void broadcastMessage(Message newMessage) {
    if (myNeighbors != null) {
      for (int i = 0; i < myNeighbors.length; i ++) {
        sendMessage(myNeighbors[i], newMessage);
      }
    }
  }

  public Message[] storeMessage(Message[] existingMessages, Message newMessage) {
    Message[] temp;
    int size;
    if (existingMessages == null) {
      temp = new Message[1];
      temp[0] = newMessage;
      return temp;
    }
    else {
      size = existingMessages.length + 1;
      temp = new Message[size];
      for (int i = 0; i < temp.length; i++) {
        if (i < existingMessages.length) {
          temp[i] = existingMessages[i];
        }
        else 
          temp[i] = newMessage;
      }
      return temp;
    }
  }

  public void nominateSelf() {
    writeMessage("elect");
    isNominated = true;
    awaitingVictory = false;
    timeToVictory = millis() + nominationTimeout;
  }

  public void concede() {
    isNominated = false;
    isLeader = false;
    timeToVictory = 0;
    awaitingVictory = true;
    timeToVictory = millis() + nominationTimeout;
  }

  public void announceVictory() {
    isNominated = false;
    timeToVictory = 0;
    isLeader = true;
    if (myState.equals("infected")){
      myState = "right";
      //System.out.println(myAddress + ": I am cured!");
    }
    hasLeader = true;
    leaderAddress = myAddress;
    timeToPanic = millis() + leaderTimeout;
    writeMessage("victory");
  }

  public void allHailOurGloriousLeader(int leaderAddress) {
    if (leaderAddress != myAddress) {
      timeToVictory = 0;
      awaitingVictory = false;
      isNominated = false;
      timeToPanic = millis() + leadershipTimeout;
      hasLeader = true;
      isLeader = false;
      leaderAddress = leaderAddress;
    }
  }


  public void sendMessage(Node target, Message newMessage) {
    target.availableMessages = target.storeMessage(target.availableMessages, newMessage);
    //System.out.println("Message ID: " + newMessage.getID() + ", command: " + newMessage.getCommand() + " sent to node: " + target.getAddress());
  }

  public void lock() {
    lock = true;
  }

  public void unlock() {
    lock = false;
  }

  public void lockToggle() {
    if (lock == false) {
      lock = true;
    }
    else 
      lock = false;
  }

  public boolean canISee(Node target) {
    if (target != null) {
      float dist = calcDistance(target.xpos, target.ypos, xpos, ypos);
      if (radius >= dist) {
        return true;
      }
      else 
        return false;
    }
    else {
      return false;
    }
  }

  public Node[] removeNode(Node[] nodes, int index) {
    int size = nodes.length - 1;
    int j = 0;
    Node[] temp = new Node[size];
    for (int i = 0; i < nodes.length; i ++) {
      if (i != index) {
        temp[j] = nodes[i];
        //System.out.println("i = " + i + ", j = " + j);

        j++;
      }
    }
    return temp;
  }
  public void findNeighbors(Node[] allNodes) {
    Node[] temp = null;

    for (int i = 0; i < allNodes.length; i ++) {
      if (allNodes[i] != null) {
        if (canISee(allNodes[i])) {
          if (allNodes[i].getAddress() != myAddress) {
            temp = storeNode(temp, allNodes[i]);
          }
        }
      }
      myNeighbors = temp;
      neighborChange = true;
    }
  }



  public void writeName() {
    fill(255);
    if (isLeader) {
      fill(0);
      strokeWeight(3);
    }
    //ellipse(mySize/2, -mySize/2, mySize/2, mySize/2);
    rectMode(CENTER);
    rect(mySize/1.5, -mySize/2, mySize, mySize/2, mySize/6);
    strokeWeight(1);
    textFont(f, 12);

    fill(0);
    if (isLeader) {
      fill(255);
    }
    text(myAddress, mySize/2.5, -mySize/2.5+2);
  }

  public void display() {
    pushMatrix();
    translate(xpos, ypos);
    writeName();
    strokeWeight(myStrokeWeight);
    stroke(myStroke);
    fill(myColor);
    if (isLeader) {
      strokeWeight(5);
    }
    ellipse(0, 0, mySize, mySize);
    strokeWeight(1);
    if (isLeader) {
      fill(255);
      ellipse(0, 0, mySize/2, mySize/2);
    }
    else if (!hasLeader) {
      fill(darkGray);
      if (myState.equals("infected")){
        fill(black);
      }
      textFont(f, 30);
      text("?", -8, 11);
    }
    popMatrix();
  }


  public void drawConnections() {
    strokeWeight(1);
    if (myNeighbors != null) {
      for (int i = 0; i < myNeighbors.length; i ++) {
        line(xpos, ypos, myNeighbors[i].xpos, myNeighbors[i].ypos);
      }
    }
  }

  public void clearNodes() {
    myNetwork = new Node[0];
  }

  public void updateColor() {
    myColor = processColor();
  }

  public void setState(String newState) {
    myState = newState;
    updateColor();
  }

  public color processColor() {
    if (myState.equals("none")) {
      return black;
    }
    else if (myState.equals("infected")) {
      return red;
    }
    else if (myState.equals("left")) {
      return lightGray;
    }
    else if (myState.equals("right")) {
      return white;
    }
    else 
      return black;
  }

  public void cycleState() {
    if (lock == false) {
      if (myState.equals("left")) {
        setState("right");
      }
      else if (myState.equals("right")) {
        setState("left");
      }
  }
  }
  public void randomState() {
    if (lock == false) {
      float randomNum = random(2);
      if (randomNum <= 1) {
        setState("left");
      }
      else {
        setState("right");
      }
    }
  }

  public Node[] storeNodes(Node[] existingNodes, Node[] newNodes) {
    Node[] temp;
    int size;
    if (existingNodes == null) {
      temp = newNodes;
      return temp;
    }
    else
      size = newNodes.length + existingNodes.length;
    temp = new Node[size];
    for (int i = 0; i < temp.length; i++) {
      if (i < existingNodes.length) {
        temp[i] = existingNodes[i];
      }
      else 
        temp[i] = newNodes[i-existingNodes.length];
    }

    return temp;
  }

  public Node[] storeNode(Node[] existingNodes, Node newNode) {
    Node[] temp;
    int size;
    if (existingNodes == null) {
      temp = new Node[1];
      temp[0] = newNode;
      return temp;
    }
    else {
      size = existingNodes.length + 1;
      temp = new Node[size];
      for (int i = 0; i < temp.length; i++) {
        if (i < existingNodes.length) {
          temp[i] = existingNodes[i];
        }
        else 
          temp[i] = newNode;
      }
      return temp;
    }
  }

  public void updateNetwork(Node[] newNodes) {
    myNetwork = storeNodes(myNetwork, newNodes);
  }

  public void setNetwork(Node[] newNodes) {
    myNetwork = newNodes;
  }

  public void pressButton1() {
    if (isLeader) {
      lockToggle();
    }
    else if (myState != "infected"){
      lockToggle();
    }
  }

  public void pressButton2() {
    if (!isLeader) {
      myState = "infected";
      updateColor();
    }
    writeMessage(myState);
  }

  public void writeMessage(String command) {
    d = new Date();
    String messageID = "" + myAddress + "-" + d.getTime();
    Message newCommand = new Message(messageID, command, myAddress);
    forwardMessage(newCommand);
  }
}

public float calcDistance(float x1, float y1, float x2, float y2) {
  float xsum = x1-x2;
  float ysum = y1-y2;
  float xsq = xsum * xsum;
  float ysq = ysum * ysum;
  return (float)Math.sqrt(ysq+xsq);
}

public void nodeWait() {
  try {
    Thread.sleep(nodeDelay);
  }
  catch (Exception e) {
  }
}
