var RED = "#F44336";
var INDIGO = "#3F51B5";
var LIGHT_RED = "#FFCDD2";
var LIGHT_INDIGO = "#C5CAE9";

var timeDigits = 3;
var smallLaserRadius = project.view.bounds.height / 8;
var largeLaserRadius = smallLaserRadius *2;
var sensorRadius = 5;
var scanningTime = 2; //seconds
var scanningSpeed = project.view.bounds.width / scanningTime;


var sensor, largeLaser, smallLaser, smallTimeText, largeTimeText;

var largeSensorTime, smallSensorTime, minPosition, maxPosition, currentPosition;

function laserCircle(radius, color1, color2){
    var circle = new Path.Circle(project.view.center, radius);
    circle.strokeColor = color1;
    circle.strokeWidth = 0;
    circle.fillColor = color1;
    return circle;
}

function timingText(color){
    var timeText = new PointText(project.view.center);
    var initialTime = 0.0;
    timeText.content = initialTime.toFixed(timeDigits);
    timeText.style = {
        fontFamily: 'Courier New',
        fontSize: 30,
        justification: 'center',
        fillColor: color
    };
    return timeText;
}

function setup(){
    largeLaser = laserCircle(largeLaserRadius, INDIGO, LIGHT_INDIGO);
    smallLaser = laserCircle(smallLaserRadius, RED, LIGHT_RED);

    sensor = new Path.Circle(project.view.center, sensorRadius);
    sensor.fillColor = 'black';
    sensor.strokeColor = 'black';


    largeSensorTime = 0;
    smallSensorTime = 0;
    minPosition = project.view.bounds.leftCenter.x - largeLaserRadius;
    maxPosition = project.view.bounds.rightCenter.x + largeLaserRadius;
    currentPosition = minPosition;

    updateLasers();

    smallTimeText = new timingText(RED);

    smallTimeText.position = project.view.bounds.center;
    smallTimeText.position.y = project.view.bounds.height/8;
    smallTimeText.position.x += project.view.bounds.width/4;

    largeTimeText = new timingText(INDIGO);

    largeTimeText.position.y = smallTimeText.position.y;
    largeTimeText.position.x = smallTimeText.position.x - project.view.bounds.width/2;
}

function updatePosition(event){
    var offset = scanningSpeed * event.delta;
    currentPosition += offset;

    if (currentPosition > maxPosition){
        reset();
    }
}

function reset(){
    resetPosition();
    resetTimers();
}

function resetPosition(){
    currentPosition = minPosition;
}

function resetTimers(){
    largeSensorTime = 0;
    smallSensorTime = 0;
}

function updateLasers(){
    largeLaser.position.x = currentPosition;
    smallLaser.position.x = currentPosition;
}

function checkLasers(event){
    var largeHit = doesLaserHitSensor(largeLaser, sensor);
    var smallHit = doesLaserHitSensor(smallLaser, sensor);

    if (largeHit){
        largeSensorTime += event.delta; 
    } 

    if (smallHit){
        smallSensorTime += event.delta;
    }

    if (largeHit || smallHit){
        sensor.fillColor = 'white';
    } else {
        sensor.fillColor = 'black';
    }
}

function doesLaserHitSensor(laserObject, sensorObject){
    if (laserObject.contains(sensorObject.position)){
        return true;
    } else {
        return false;
    }
}

function updateTimeText(){
    largeTimeText.content = largeSensorTime.toFixed(timeDigits);
    smallTimeText.content = smallSensorTime.toFixed(timeDigits);
}

project.view.onFrame = function(event){
    updatePosition(event);
    updateLasers();
    checkLasers(event);
    updateTimeText();
}

setup();