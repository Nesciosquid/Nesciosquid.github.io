 var laserRadius = 60;
    var sensorRadius = 5;
    var scanningTime = 2; //seconds

    var scanningSpeed = project.view.bounds.width / scanningTime;
    var laserCircle = new Path.Circle(project.view.bounds.leftCenter, laserRadius);

    var sensorCircle = new Path.Circle(project.view.center, sensorRadius);
    sensorCircle.fillColor = 'black';

    laserCircle.fillColor = 'red';

    var sensorTime = 0;

    console.log("updated");

    var timeText = new PointText(project.view.center);
    timeText.position.y += project.view.bounds.height/4;
    timeText.content = "" + sensorTime;
    timeText.style = {
        fontFamily: 'Courier New',
        fontSize: 20,
        justification: 'center',
        fillColor: 'black',
        strokeColor: 'black'
    };

    function onFrame(event){
        var offset = scanningSpeed * event.delta;
        laserCircle.position.x += offset;

        if (laserCircle.position.x > project.view.bounds.width){
            laserCircle.position.x = 0;
            sensorTime = 0;
        }

        var hit = hitTest(laserCircle, sensorCircle);

        if (hit){
            sensorTime += event.delta;
        }

        timeText.content = sensorTime.toFixed(4);
    }

    function hitTest(laser, sensor){
        if (laser.contains(sensor.position)){
            sensor.fillColor = 'green';
            return true;
        } else {
            sensor.fillColor = 'black';
            return false;
        }
    }