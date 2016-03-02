---
title: 3D-printed light sensors
layout: post
category: Research
tags: [3D Printing, Hardware, Electronics, Lasers, Code]
---

I'm working on a project right now that requires small, electronic light sensors. I need them to detect when a laser hits them and generate a wireless transmission as a response.

I set out to see what kind of sensors I could build cheaply with [my 3D printer](http://printrbot.com/shop/assembled-metal-printrbot-plus/) and an Arduino.

*Skip to a section*:

1. things
{:toc}

## Inspiration

A few years back, I came across [some awesome automatic projector calibration work](http://johnnylee.net/projects/thesis/) by Johnny Chung Lee at Carnegie Mellon. He has a bunch of great projects on his website, but this one stood out to me because it solved a practical problem (aligning multiple projectors) with inexpensive components.

While experimenting with ways to build my light sensors, I realized that my requirements were very similar to the ones from his project, and wondered if I could replicate his hardware setup. [The paper](http://johnnylee.net/academic/proj4.pdf) mostly focuses on the methodology used to process data from the sensors into calibration information, but it does contain a few pictures of the target object. 

![](http://i.imgur.com/GdOKPZn.png)
![](http://i.imgur.com/onUZgdA.png)

It looks like a wooden board with holes drilled in the corners, through which optical fibers have been pushed. In the back, those fibers connect to what the paper desecribes as a "USB Sensor Board," which presumably contains a light sensor coupled to each fiber. I wasn't able to find the USB board used in the paper, so I decided to experiment with building my own version of the setup. 

## Rolling my own sensors

I ordered a bunch of light sensors, varying in quality and price from [cheapo photoresistors](http://www.amazon.com/Sensitive-Resistor-Photoresistor-Optoresistor-GM5539/dp/B00AQVYWA2/ref=pd_sim_sbs_328_1?ie=UTF8&dpID=41KHtHCjzUL&dpSrc=sims&preST=_AC_UL160_SR160%2C160_&refRID=05CNNDN4JF1YT7WR48Z5) to [log-scale Analog sensors](https://www.adafruit.com/products/1384) to [I2C digital sensors](https://www.adafruit.com/products/1980:). 

![](http://i.imgur.com/nrnjbCG.jpg)

Since they shipped fastest, I tried the photoresistors first, [following Adafruit's Arduino instructions](https://learn.adafruit.com/photocells/using-a-photocell) using a 10K pull-down resistor. Even in relatively bright ambient light, I was able to see a significant change in the sensor when struck by the laser beam. 

Encouraged by this, I started looking for ways to couple these photoresistors to optical fibers, as was done in the paper. Since I'm new to optics, I asked around to see if anyone knew of a cheap, easy way to do that, and most people seemed to think that simply shoving the fibers up against the optical resistors would be super inefficient. Turns out, they were right, but that doesn't seem to matter! 

Further research yielded [this StackExchange post](http://electronics.stackexchange.com/questions/113536/how-would-one-attach-an-optical-fibre-to-a-pcb-for-a-display) which provides several alternate methods for low-efficiency fiber coupling.

## Designing and printing optical connectors

I grabbed some spare fiber parts that were laying around, and found [some cheap plastic snaps](http://i-fiberoptics.com/light-pipe-connector-detail.php?id=2040) which were originally intended to attach them to LEDs mounted to a circuit board. 

![](http://i.imgur.com/p2Lqfaa.jpg)

Luckily, these snap connectors fit perfectly over the photoresistors, holding the fiber in place above them. I fired up OpenSCAD, and designed a 3D printable structure (basically just a flat plane with a bunch of holes in it) that would hold a photoresistor, an optical fiber connector, and a 10K resistor. 

{% gist Nesciosquid/d9c08b1a1a42c65fb8c2 fiberConnector_single.stl %}

Despite knowing or being able to measure the sizes of all the components, my experience with FDM printers told me that I would have to print the holes larger than expected, since they tend to come out smaller than intended after printing. To get the sizes just right, I printed a test block [like this one](http://www.thingiverse.com/thing:242437) and shoved things through until I found a post-printing hole size that was a perfect fit for every part. From there, making sure all three components fit relative to one another was just a matter of printing tests and tweaking the settings in OpenSCAD until everything was snug.

To make it easier to wire up multiple sensors to my Arduino, I printed a block with three of these sets of holes in a row, which would allow me to attach three photoresistors to three separate analog inputs while combining their power and ground lines. This is one of the great things about designing with OpenSCAD -- as soon as you have the base geometry programmed in and parameterized, modifying it is super easy!

{% gist Nesciosquid/d9c08b1a1a42c65fb8c2 fiberConnector_triple.stl %}

![](http://i.imgur.com/lg1W5VMl.jpg)

To simulate the wooden board used in the paper, I also designed a small block with holes -- large on one side and small on the other -- where fibers could be inserted from the back and have only the small tip poke through on the other side. I added a hole next to each of these to pressure-fit an LED. I shoved an LED into each hole, and wired up each one to a separate digital pin on the Arduino.

{% gist Nesciosquid/d9c08b1a1a42c65fb8c2 fiberTestPlate.stl %}

![](http://i.imgur.com/ch4cR75l.jpg)
![](http://i.imgur.com/QHDitZal.jpg)

## Testing

I wrote up a quick Arduino sketch, which measured the analog inputs associated with each photoresistor and turned on its corresponding LED if the reading passed a certain value, while also passing these readings to a serial console for analysis. Since the snap connectors and optical fibers occluded the photoresistors beneath them, this new setup had even better behavior than the photoresistors did by themselves. With a little tweaking, I was able to see a nearly hundred-fold increase in light intensity when a fiber tip was struck by a laser than when it was exposed only to ambient light. More than good enough for a trigger!

![](https://j.gifs.com/rk92n6.gif)

Even better, it works from nearly a 90 degree angle!

![](https://j.gifs.com/VOQvK1.gif)

## Problems / Future Fun

One annoying part of this setup is that, as you might expect, optical fibers are fairly resistant to bending. That meant that with a lightweight target object (my 3D printed block), it was fairly difficult to keep it held in position without the fibers pulling it one way or another. To get around this, one could avoid the fibers altogether by mounting each photoresistor on or below the surface of a target object, then run electrical wires instead of optical fibers back to a sensing board. 

I still have some more experimenting to do, but it's satisfying to know that I can now attach cheap laser-sensors to 3D printed objects without much hassle.

## Code

Arduino code for testing the three-photocell setup:

{% gist Nesciosquid/d9c08b1a1a42c65fb8c2 photocellMeasure.ino %}

OpenSCAD code for generating the models:

{% gist Nesciosquid/d9c08b1a1a42c65fb8c2 fiberMount.scad %}