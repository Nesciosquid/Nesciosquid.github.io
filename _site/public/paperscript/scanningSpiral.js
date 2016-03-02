var laserRadius = 10;
var sensorRadius = 5;

var sensorPosition1 = new Point(project.view.center);
sensorPosition1.x += 20;
sensorPosition1.y -= 60;

var sensorPosition2 = new Point(project.view.center);
sensorPosition2.x -= 10;

var sensorPosition3 = new Point(project.view.center);
sensorPosition3.x -=15;
sensorPosition3.y += 30; 

var laserColor = "#EF9A9A";

var spiralPathWidth = 20;
var spiralPathStart = project.view.center;

var radius = laserRadius * 10;
var awayStep = laserRadius;
var coils = Math.round(radius/awayStep);
var thetaMax = coils * 2 * Math.PI;
var chord = laserRadius/2;
var laserSpeed = 40 * laserRadius; // per second
var totalScanTime = 0;

var timePoints = [];
var frameCounter = 0;
var startTime = 0;
var spiralPath;

var laserCircle;

var finished = false;

var allSensors = [];

function Sensor(position){
	this.position = position;
	this.paperObject = new Path.Circle(position, sensorRadius);
	this.paperObject.insertAbove(laserCircle);
	this.paperObject.fillColor = 'black';
	this.detections = [];
	this.startDetectionTime = -1;

	this.getDetectionTimes = function(){
		var times = [];
		while (this.detections.length != 0){
			if (this.detections.length %2 != 0){
				return [];
			} 
			var diff = (this.detections[0] - this.detections[this.detections.length-1]);
			var time = totalScanTime - (diff/2);
			this.detections.splice(0,1);
			this.detections.splice(this.detections.length-1, 1);
			times.push(time);
		}

		return times;
	}

	this.checkSensor = function(laserObject){
		if (laserObject.contains(this.position)){
			this.startDetectionTime = getTime();
			this.paperObject.fillColor = 'white';
		} else {
			if (this.startDetectionTime != -1){
				var endTime = getTime();
				var avg = (this.startDetectionTime + endTime)/2;
				this.detections.push(avg);
				this.startDetectionTime = -1;
				this.paperObject.fillColor = 'black';
			}
		}
	}
}

function getSpiralPosition(angle, distance){
	var x = distance * angle * Math.cos(angle);
	var y = distance * angle * Math.sin(angle);
	return new Point(x,y);
}

function generateSpiralPoints(){
	var theta = chord/awayStep;
	while (theta < thetaMax){
		var distance = awayStep * (theta / (2 * Math.PI));
		var x = spiralPathStart.x + Math.cos(theta) * distance;
		var y = spiralPathStart.y + Math.sin(theta) * distance;
		theta += chord/distance;
		timePoints.push(new Point(x,y));
	}

	totalScanTime = chordsToTime(timePoints.length);
}

function chordsToTime(chordCount){
	var distance = chordCount * chord;
	var time = distance / laserSpeed;
	var timeMillis = time * 1000.0;
	return timeMillis;
}

function timeToChords(time){
	var timeSeconds = time / 1000.0;
	var traveled = timeSeconds * laserSpeed;
	var chords = traveled / chord;
	return chords;
}

function getLowerTimepointBound(chords){
	var floor = Math.floor(chords);
	if (floor > timePoints.length -1){
		floor = timePoints.length - 1 - (floor - timePoints.length);
	}
	if (floor < 0){
		floor = 0;
	} 
	return timePoints[floor];
}

function getUpperTimepointBound(chords){
	var ceil = Math.ceil(chords);
	if (ceil > timePoints.length -1){
		ceil = timePoints.length - 1 - (ceil - timePoints.length);
	}
	if (ceil < 0){
		ceil = 0;
		if (!finished){
			finish();
			finished = true;
		}
	} 
	return timePoints[ceil];
}

function getRatio(chords){
	var floor = Math.floor(chords);
	var remainder = chords - floor;
	return remainder;
}

function linearInterpolation(pointA, pointB, ratio){
	return (pointA * (1-ratio) + pointB * (ratio));
}

function getSpiralPosition(time){
	var chords = timeToChords(time);
	return linearInterpolation(getLowerTimepointBound(chords), getUpperTimepointBound(chords), getRatio(chords));
}

function drawSpiral(){
	var spiral = new Path();
	spiral.strokeWidth = 1;
	spiral.strokeColor = 'black';
	for (var i =0; i < 100; i++){
		spiral.add(getSpiralPosition(i));
	}
}

function drawTimeSpiral(){
	var spiral = new Path();
	for (var i = 0; i < timePoints.length; i++){
		spiral.add(timePoints[i]);
	}
	spiral.strokeColor = "black";
	spiral.strokeWidth = 1;
}

function getTime(){
	var date = new Date();
	return date.getTime();

}

function startFrameSpiral(){
	startTime = getTime();
	spiralPath = new Path();
	spiralPath.strokeColor = laserColor;
	spiralPath.strokeWidth = laserRadius*2;
	spiralPath.add(spiralPathStart);

	spiralStart = new Path.Circle(spiralPathStart, laserRadius);
	spiralStart.fillColor = laserColor;
	
	laserCircle = new Path.Circle(spiralPathStart, laserRadius);
	laserCircle.strokeWidth = 2;
	laserCircle.strokeColor = 'black';
	laserCircle.fillColor = laserColor; 
}

function onFrame(){
	var time = getTime() - startTime;
	var pos = getSpiralPosition(time);
	spiralPath.add(pos);
	laserCircle.position = pos;
	checkSensors(laserCircle);
}

function checkSensors(laserObject){
	for (var i in allSensors){
		var sensor = allSensors[i];
		sensor.checkSensor(laserObject);
	}
}

function resolveSensors(){
	for (var i in allSensors){
		var sensor = allSensors[i];
		plotGuesses(sensor.getDetectionTimes());
	}
}

function plotGuesses(times){
	for (var i in times){
		var time = times[i];
		var pos = getSpiralPosition(time);
		var circle = new Path.Circle(pos, laserRadius);
		circle.strokeColor = 'blue';
		circle.strokeWidth = 1;
	}
}

function finish(){
	resolveSensors();
	console.log(allSensors);
}

generateSpiralPoints();
startFrameSpiral();
allSensors.push(new Sensor(sensorPosition1));
allSensors.push(new Sensor(sensorPosition2));
allSensors.push(new Sensor(sensorPosition3));
console.log(allSensors);
