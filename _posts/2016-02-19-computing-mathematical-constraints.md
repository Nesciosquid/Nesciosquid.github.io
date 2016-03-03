---
title: Analyzing mathematical constraints for beam steering
layout: post
category: Research
tags: [Math, Lasers, Simulations, Javascript]
---


I want to do this: 

![](https://j.gifs.com/G694LQ.gif)

In that simulation, a device scans a beam across a 3D space, where it hits sensors which calibrate the beam's position and orientation so that it can be pointed at specific objects. As I move towards implementing a real-life version, I wanted to nail down some of the constraints which will determine how well the system can perform, in terms of scanning speed and resolution.

*Skip to a section*:

1. things
{:toc}

## Field of View

Our beam-steering device has the ability to redirect an incident beam up to some half-angle $$ \theta_D $$. In the case of the device I'll be working with, I've been told that this is around **30 degrees** in any direction -- up, down, left, or right.

We can model the field of view of the device as a cone with a half-angle of $$ \theta_D $$. At a given distance $$ D $$, we can use trig to compute the width $$ W $$ of this field of view as $$ 2\tan(\theta_D)*D $$

![](http://i.imgur.com/VeGngf4.jpg)

For example, if our device has a half-angle of 30 degrees and is positioned **10 feet** away from a surface, we can estimate that the field of view will be approximately $$ 2\tan(30)*10 = 11.5 $$ feet wide.

## Scanning Speed

The next factor to consider is the speed at which the device can scan. For our device, the time it takes to travel from one end of its range to the other, $$t_D$$, is about **12 milliseconds**. In order for a sensor to detect the presence of a beam pointed at it, the microcontroller must sample the output of the sensor while the beam is still shining upon the sensor's surface. This means that the sampling rate of the microcontroller determines how long the beam must shine on a sensor in order to successfully register a hit.

Let's assume we want the beam to sweep as fast as possible. That means that, in order to ensure that any sensor within the field of view will be illuminated long enough to see the beam as it scans across, the radius of the beam must be equal to or larger than the distance traveled by the beam over the course of one sample. (This makes the assumption that the center of the beam passes directly over the sensor, but it's just an estimate!)

This concept is shown in the animation below. The blue circle is twice as wide as the red circle. The red and blue numbers represent how long each circle overlaps the black spot in the center as they travel across it. You can see that the blue circle overlaps the dot roughly twice as long as the red one does. [You can find the code for this demonstration here.](https://gist.github.com/Nesciosquid/bb388d4db6eb56525d0a)

<canvas class="canvas-example" id="myCanvas"></canvas>
<script type="text/paperscript" canvas="myCanvas" src="https://cdn.rawgit.com/Nesciosquid/bb388d4db6eb56525d0a/raw/scanRadiusTiming.js">
</script>

## Beam Width

Instead of computing the ideal beam radius at a particular distance, we can determine what proportion of the field of view must be occupied by the beam at any time to ensure that sensors will be tripped. We know that the beam travels the full width of the field of view $$W$$ in **12 milliseconds**. Assuming a sampling time $$t_S$$ of **100 microseconds** (standard for Arduino analog reads), this means that the sample time is 120x smaller than our sweep time. That means that, independent of the distance $$D$$, the beam width $$B$$ must be greater than or equal to one 120th of the field of view width.

$$
    B\geq\frac{W}{\frac{t_D}{t_S}}
$$

From earlier, $$D$$ was 10 feet and $$W$$ was 11.5 feet. That means $$B$$ must be at least $$\frac{11.5}{120}$$ = **.096 feet, or 1.15 inches.**

In general, this tells us that we can compute the minimum beam half-angle $$\theta_B$$ based only on $$\theta_D$$, $$t_D$$ and $$t_S$$.

$$
    \arctan(\frac{\tan(\theta_D)}{\frac{t_D}{t_S}})
$$

This gives us a $$\theta_B$$ of $$\arctan(\frac{\tan(30)}{\frac{1200}{100}})$$ = **.276 degrees.**

This also tells us that we can further reduce the minimum beam width by decreasing $$t_S$$. It looks like [there are some tricks](http://forum.arduino.cc/index.php?topic=6549.0) to reduce analog Arduino reads down to about 16 microseconds. Plugging that in for $$t_S$$, we get a minimum $$\theta_B$$ of **.0441 degrees**, and a minimum $$B$$ of **.184 inches**.

## Resolution and Scanning Time

Since our beam width determines the resolution of our scan, this means that by increasing the sampling frequency of our sensors, we can perform higher-resolution scans at faster speeds. 

There's a catch, though -- the smaller we make the beam, the longer the scan will take. The smaller $$B$$ is, the more rows we have to scan to cover the entire space. Assuming that the FOV is square (which it isn't) and that the beam is 750x smaller than its width, this could take $$750 * 12 = 9000$$ milliseconds. That's way too long!

Thankfully, our device gives us dynamic control over the beam width, and we're not required to scan the laser over the entire field of view for every scan. The trick will be to tune the beam width for faster or slower scans, and to develop a scanning algorithm that maximizes resolution while minimizing overall scan time. We'll also have to account for the fact that, since the cross-sections of the FOV and beam are both approximately circular, we'll need to adjust these calculations to account for partial overlap between the beam and the sensor and the reduced space of the FOV which lies within a square projection if we want to take a row-scanning approach.

## Light Intensity

Pairing the power of our laser to the sensitivity of our sensors is going to be tricky. As $$B$$ gets larger, the same amount of light intensity is spread over a larger area upon impacting a surface. This means that the intensity of the light hitting our sensors decreases dramatically with the distance to the target, $$D$$, since the area of the cross-section of the beam increases with the square of its radius, and we're treating light intensity as energy per unit area.

To overcome this, we'll either have to make sure our sensors are sensitive enough to pick up small changes in light intensity, or we'll have to use a stronger laser. I'm going to have to consult with experts to ensure that our solution works at functional ranges without posing a danger to users, since any laser being scanned across an indoor space needs to be eye-safe. 