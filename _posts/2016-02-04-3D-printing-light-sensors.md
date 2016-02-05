---
title: 3D Printed Light Sensors
layout: post
---

I'm working on a project right now that requires small, electronic light sensors. I need them to detect when a laser beam hits them and generate some kind of response -- an LED turning on, a wireless transmission, etc.

A few years back, I came across [some awesome automatic projector calibration work](http://johnnylee.net/projects/thesis/) by Johnny Chung Lee at Carnegie Mellon. He has a bunch of great projects on his website, but this one stood out to me because it solved a practical problem (aligning multiple projectors) with inexpensive components backed up by solid engineering and software.

While experimenting with ways to build my light sensors, I realized that my requirements were very similar to the ones from his project, and wondered if I could replicate his hardware setup. [The paper](http://johnnylee.net/academic/proj4.pdf) mostly focuses on the methodology used to process data from the sensors into calibration information, but it does contain a few of the target object. 

![](http://i.imgur.com/GdOKPZn.png){: .center-image}
![](http://i.imgur.com/onUZgdA.png){: .center-image}

It looks like a wooden board with holes drilled in the corners, through which optical fibers have been pushed. In the back, those fibers connect to what the paper desecribes as a "USB Sensor Board," which presumably contains a light sensor coupled to each fiber. 

I wasn't able to find the USB board used in the paper, so I decided to experiment with building my own version of the setup. 

I ordered a bunch of light sensors, varying in quality and price from [cheapo photoresistors](http://www.amazon.com/Sensitive-Resistor-Photoresistor-Optoresistor-GM5539/dp/B00AQVYWA2/ref=pd_sim_sbs_328_1?ie=UTF8&dpID=41KHtHCjzUL&dpSrc=sims&preST=_AC_UL160_SR160%2C160_&refRID=05CNNDN4JF1YT7WR48Z5) to [log-scale Analog sensors](https://www.adafruit.com/products/1384) to [I2C digital sensors](https://www.adafruit.com/products/1980:). 

I tried the photoresistors first, and lucked out -- 