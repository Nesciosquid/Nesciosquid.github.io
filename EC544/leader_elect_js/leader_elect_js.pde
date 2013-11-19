import java.util.Date;

PFont f;
static Node origin;
static Node leaderEx;
static Node nonLeaderEx;
static Node lostEx;
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
  //smooth();
  frameRate(20);
  f = createFont("Arial", 32, true);
  origin = new Node(100000, 0, 0); // helper node, not displayed, could replace with static methods
  initiateExamples(); // for legend
  nodeIndex = 0; // used in naming new nodes
  randomNodes(50); // generates 50 random nodes to fill space, comment out to start with blank canvas
}

public void initiateExamples() {
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
}

public void randomNodes(int number) { 
  for (int i = 0; i < number; i ++) {
    allNodes = origin.storeNode(allNodes, new Node(nodeIndex, random(50, width-50), random(50, height-50)));
    nodeIndex++;
  }
  calcNeighbors();
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
    else if (keyCode == CONTROL) {
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

    else if (keyCode == CONTROL) {
      ctrl = false;
    }
  }
}

public void drawNodes() {
  if (allNodes != null) {
    for (int i = 0; i < allNodes.length; i++) {
      allNodes[i].drawRange();
    }
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

void drawLegend() {
  if (ctrl) {
    rectMode(NORMAL);
    stroke(0);
    strokeWeight(2);
    fill(100, 100, 100, 200);
    rect(0, 0, 350, 500, 30);
    strokeWeight(1);
    textFont(f, 20);
    fill(255);
    text("Leader Election", 100, 30);
    textFont(f, 15);

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
    fill(100, 100, 100, 100);
    rect(0, 0, 80, 25, 15);
    strokeWeight(1);
    textFont(f, 16);
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
}

//used to simulate sunSPOT Datagrams
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
  /*  Instance variables for bully leader election */
  boolean hasLeader = false;
  boolean isLeader = false;
  boolean infected = false;
  boolean awaitingVictory = false;
  boolean neighborChange = true;
  boolean isNominated = false;

  long nominationTimeout = 1000;
  long leaderTimeout = 1000;
  long leadershipTimeout = 1500;
  long timeToVictory = 0;
  long timeToPanic = 0;
  /* -------------------------- */

  /* Instance variables, used to spoof wireless networking */
  Node[] myNeighbors;
  /* ---------------------------- */

  /* Processing-only instance variables, for drawing and rangefinding */
  public float xpos = 0.0f;
  public float ypos = 0.0f; 
  public float mySize = 30.0f; // determines node size
  public float radius = 120.0f; // max communication distance in pixels 
  int myStroke = 0;
  int myStrokeWeight = 2;
  color red = color(200, 0, 0); // infected
  color blue = color(0, 0, 255); // left
  color green = color(0, 255, 0); // right
  color lightGray = color(200, 200, 200);
  color darkGray = color(100, 100, 100); 
  color white = color(255, 255, 255); // none
  color black = color(0, 0, 0); // unknown
  color myColor = white;
  color myTextColor = black;
  /*  --------------------------------- */

  /* instance variables for message transmission */
  Date d; // used to create 'unique-ish' message IDs
  public int myAddress;
  public Message[] availableMessages;
  public Message[] outgoingMessages;
  public Message lastInfection; // used for storing the infection message for re-transmission
  String myState = "right"; // oscillates randomly, should be set by accelerometer rotation
  boolean lock = false; // toggled by "Button 1"
  HashMap seenMessages = new HashMap();
  /* --------------------- */

  //X and Y values are Processing-only
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

  /*Called during Process Nodes loop in Processing, used in bully leader election. 
   Should be called at the beginning of the SunSPOT wake cycle.
   Checks state of leadership -- whether leader is present, whether awaiting election results, etc.*/
  public void checkLeaderStatus() {
    if (neighborChange == true) {
      nominateSelf();
      neighborChange = false;
    }

    // This node is the leader. 
    if (isLeader) {
      // Send another victory message to re-establish leadership over other nodes.
      if (millis() >= timeToPanic) { 
        announceVictory();
      }
    }

    // This node is not the leader.
    else { 

      //This node has a leader.
      if (hasLeader) {
        //Leader has not contacted this node in too long. Remove leader.
        if (millis() >= timeToPanic) {
          hasLeader = false; 
          timeToPanic = 0;
        }
      }

      //This node has no leader.
      else {

        //This node has nominated itself for election and is waiting for responses.
        if (isNominated) {
          //The election has timed out, and this node delcares itself the victor.
          if (millis() >= timeToVictory) {
            announceVictory();
          }
        }

        //This node has conceded, and is awaiting another node's victory.
        else if (awaitingVictory) {

          //No other node has claimed victory in too long, so this node nominates itself again.
          if (millis() >= timeToVictory) {
            nominateSelf();
          }
        }

        //No leaders or elections, so this node initiates an election, nominating itself.
        else
        {
          nominateSelf();
        }
      }
    }
  }

  //Iterate through outging message array, sending to all neighbor-nodes.
  //If infected, also send along the stored infection message.
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

  //Read through available (received) messages and take actions based on them.
  public void processMessages() {
    if (availableMessages != null) {
      for (int i =0 ; i < availableMessages.length; i ++) {
        readMessage(availableMessages[i]);
      }
      availableMessages = null;
      updateColor();
    }
  }

  // Read a message, and only take action if it hasn't been seen before.
  public void readMessage(Message incomingMessage) {
    if (incomingMessage != null) {
      String messageID = incomingMessage.getID();
      int issuerID = incomingMessage.getIssuer();
      if (seenMessages.containsKey(messageID) == false) {
        seenMessages.put(messageID, incomingMessage);
        executeCommand(incomingMessage);
      }
    }
  }

  // Determines whether this node 'wins' against another node for leader election
  public boolean doIWin(int challengerAddress) {
    if (myAddress < challengerAddress) {
      return true;
    }
    else {
      return false;
    }
  }

  //Process commands from a message and carry out appropriate tasks.
  public void executeCommand(Message newMessage) {
    String command = newMessage.getCommand();
    int issuerID = newMessage.getIssuer();
      if (myAddress != issuerID) {
    //Another node has called an election.
    if (command.equals("elect")) {

      //This is not a message from myself!
      

        // This node should win against the node that sent the current message.
        //This message is not forwarded.
        if (doIWin(issuerID)) {

          //If this node has already nominated itself, re-send another nomination message, but do not re-start election timeouts.
          if (isNominated) {
            writeMessage("elect");
          }

          //This node is not yet nominated for election, and should nominate itself.
          else {
            nominateSelf();
          }
        }
        
        //This node is lower-priority than the node that sent the current message. 
        //This node concedes and forwards the election message to its neighbors.
        else {
          concede();
          forwardMessage(newMessage);
        }
      }
    
    
    //Another node has claimed victory.
    if (command.equals("victory")) {
      //This node should win over the node that sent the current message.
      //This message is not forwarded.
      if (doIWin(issuerID)) {
        nominateSelf();
      }
      //Accept new leader and forward victory message to neighbors.
      else {
        allHailOurGloriousLeader();
        forwardMessage(newMessage);
      }
    }    
    
    //Leader has instructed this node to set its state to 'tilted left.'
    // Set and lock state.
    //Forward this message to neighbors.
    if (command.equals("left")) {
      myState = "left";
      lock = true;
      forwardMessage(newMessage);
    }
    
    //Leader has instructed this node to set its state to 'tilted right'
    // Set and lock state.
    //Forward this message to neighbors.
    if (command.equals("right")) {
      myState = "right";
      lock = true;
      forwardMessage(newMessage);
    }
    
    //This should not be used!
    if (command.equals("none")) {
      myState = "none";
      lock = true;
      forwardMessage(newMessage);
    }
    
    //This node has received an 'infection' message from another infected, non-leader node.
    //Change state to infected, lock state, and set lastInfection message for repeated broadcasts to neighbors.
    if (command.equals("infected")) {
      if (!isLeader) {
        myState = "infected";
        lock = true;
        lastInfection = newMessage;
      }
    }
    //Whatever state this node ended up in, update the color.
    updateColor();
  }
  }

  //Queue message for sending later, so that it will be forwarded to neighbors.
  //For SunSPOTs, this would just be a broadcast (with old message ID)
  public void forwardMessage(Message newMessage) {
    outgoingMessages = storeMessage(outgoingMessages, newMessage);
  }

  //Broadcast all messages queued for broadcasting to neighbors.
  public void broadcastMessage(Message newMessage) {
    if (myNeighbors != null) {
      for (int i = 0; i < myNeighbors.length; i ++) {
        sendMessage(myNeighbors[i], newMessage);
      }
    }
  }

  //Gives Message[] arrays resizeable functionality.
  //To resize an existing array, you want to call: existingArray = someNode.storeMessage(existingArray, someMessage);
  //Returns an array with the new message added to the end of the existing array.
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

  //Nominate this node for election by sending out election message and changing leadership state variables.
  public void nominateSelf() {
    writeMessage("elect");
    isNominated = true;
    awaitingVictory = false;
    timeToVictory = millis() + nominationTimeout;
  }

  //Make this node concede the election by changing leadership state variables, stopping victory timeout, starting victory timeout.
  public void concede() {
    isNominated = false;
    isLeader = false;
    timeToVictory = 0;
    awaitingVictory = true;
    timeToVictory = millis() + nominationTimeout;
  }

  //Make this node announce itself as leader by changing leadership state variables, stopping victory timeout, and starting leader timeout.
  //Send out victory message to other nodes.
  public void announceVictory() {
    isNominated = false;
    timeToVictory = 0;
    isLeader = true;
    
    //If this node was infected before it became leader, cure it.
    if (myState.equals("infected")) {
      randomState();
    }
    hasLeader = true;
    timeToPanic = millis() + leaderTimeout;
    writeMessage("victory");
  }

  //Accept another node as leader by changing leadership state variables, starting leadership timeout, and ending victory timeout.
  public void allHailOurGloriousLeader() {
    timeToVictory = 0;
    awaitingVictory = false;
    isNominated = false;
    timeToPanic = millis() + leadershipTimeout;
    hasLeader = true;
    isLeader = false;
  }

  //Used in processing to simulate transmitting a message to another Node.
  //Places a message into the availableMessages array of another node, for processing later.
  //Processing only
  public void sendMessage(Node target, Message newMessage) {
    target.availableMessages = target.storeMessage(target.availableMessages, newMessage);
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

  //Used to determine whether this node can communicate with other nodes based on distance.
  //Processing only
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

  //Returns an array with the node at the specified index removed
  //To remove a node from an existing array, call: existingArray = someNode.removeNode(existingArrray, someIndex);
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
  
  //Iterate through a list of nodes, find which ones are 'close' enough to transmit to, and store them.
  //Processing only
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

  //Write name tag on node.
  //Processing-only
  public void writeName() {
    fill(255);
    if (isLeader) {
      fill(0);
      strokeWeight(3);
    }
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

  //Display node, changes slightly if leader. 
  //Processing only.
  //Should be cleaned up!
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
      if (myState.equals("infected")) {
        fill(black);
      }
      textFont(f, 30);
      text("?", -8, 11);
    }
    popMatrix();
  }

  //Draw range as a transparent circle around the node.
  //Processing only.
  public void drawRange() {
    stroke(100,100,100,50);
    fill(200, 200, 200, 50);
    ellipse(xpos, ypos, radius*2, radius*2);
    stroke(1);
  }

  //Draw a line between this node and its neighbors.
  //Processing-only
  public void drawConnections() {
    strokeWeight(1);
    if (myNeighbors != null) {
      for (int i = 0; i < myNeighbors.length; i ++) {
        line(xpos, ypos, myNeighbors[i].xpos, myNeighbors[i].ypos);
      }
    }
  }

  //Update this nodes color based on state
  //Processing only
  public void updateColor() {
    myColor = processColor();
  }

  //Set the state of this node and update color.
  //Processing only.
  public void setState(String newState) {
    myState = newState;
    updateColor();
  }

  //Used to assign colors to states (tilted left/right, etc.)
  //Processing only.
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

  //Cycles through the two normal states.
  //Processing only
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
  
  //Chooses randomly from two normal states.
  //Processing only
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

  //Adds resizeable array functionality to arrays of Nodes
  //Returns a new array with the newNode added to the end.
  //To resize an existing array, call: existingArray = someNode.storeNodes(existingArray, someNode);
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

  //Simulate pressing Sunspot button 1.
  public void pressButton1() {
    if (isLeader) {
      lockToggle();
    }
    else if (myState != "infected") {
      lockToggle();
    }
  }

  //Simualte pressing SunSPOT button 2
  public void pressButton2() {
    if (!isLeader) {
      myState = "infected";
      updateColor();
    }
    writeMessage(myState);
  }

  //Create a new message with a given command.
  //Uses this Node's ID and date to generate a 'unique-ish' message ID
  public void writeMessage(String command) {
    d = new Date();
    String messageID = "" + myAddress + "-" + d.getTime();
    Message newCommand = new Message(messageID, command, myAddress);
    forwardMessage(newCommand);
  }
}

//Calculate distance between two (x,y) points, generic method.
public float calcDistance(float x1, float y1, float x2, float y2) {
  float xsum = x1-x2;
  float ysum = y1-y2;
  float xsq = xsum * xsum;
  float ysq = ysum * ysum;
  return (float)Math.sqrt(ysq+xsq);
}
