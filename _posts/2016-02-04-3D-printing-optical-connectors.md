---
published: true
title: 3D Printed Light Sensors
layout: post
tags: [3D_Printing] [Optics] [Electronics]
---

I'm working on a project right now that requires small, electronic light sensors. I need them to detect when a laser beam hits them and generate some kind of response -- an LED turning on, a wireless transmission, etc.

A few years back, I came across [some awesome automatic projector calibration work](http://johnnylee.net/projects/thesis/) by Johnny Chung Lee at Carnegie Mellon. He has a bunch of great projects on his website, but this one stood out to me because it solved a practical problem (aligning multiple projectors) with inexpensive components backed up by solid engineering and software.

While experimenting with ways to build my light sensors, I realized that my requirements were very similar to the ones from his project, and wondered if I could replicate his hardware setup. [The paper](http://johnnylee.net/academic/proj4.pdf) mostly focuses on the methodology used to process data from the sensors into calibration information, but it does contain two images of the target object. 

![](http://i.imgur.com/GdOKPZn.png){: .center-image}
![](http://i.imgur.com/onUZgdA.png){: .center-image}

It looks like a wooden board with holes drilled in the corners, through which optical fibers have been pushed. In the back, those fibers connect to what the paper desecribes as a "USB Sensor Board," which presumably contains a light sensor coupled to each fiber. 

I wasn't able to find the USB board used in the paper, so I decided to experiment with building my own version of the setup. 