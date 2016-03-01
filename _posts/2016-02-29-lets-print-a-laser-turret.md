---
title: Let's Print a Laser Turret
layout: post
---

I'm building a laser turret. (No, it's not a weapon, stop asking!)

![Full assembly with laser actiated](http://i.imgur.com/BqcEdFCl.jpg)


A colleague developed a MEMS micro-mirror capable of rapidly changing its orientation in order to steer a beam of light. I want to use this mirror to create an indoor localization and targeting system, but to do this, we needed a way to package and mount the device inside a room.

Commercial solutions for aligning optical equipment are available, but they're prohibitively expensive, with mounts and pegboard surfaces easily costing hundreds of dollars. Since we eventually want to use many of these devices in tandem, we need to keep the cost down as much as possible.

The device has some straightforward requirements: it needs to hold a laser source, any necessary lenses, and the MEMS mirror. The relative positions of the mirror and the beam need to be manually adjusted due to variations inherent in how the mirrors are created. 

I set out to design a 3D-printable mount to hold [a cheap laser module](http://www.amazon.com/Quarton-Laser-Module-VLM-650-01-LPA-INDUSTRIAL/dp/B00ANY8KPK), [an inexpensive plano-convex lens](https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=112&pn=LA1289), and the mirror in such a way that their relative positions and orientations can be manually calibrated, then locked into place.

*Skip to a section*:

1. things
{:toc}

## Lenses and lasers

The first task was to find a way to fix the relative positions and orientations of the laser module and the lens. Because I'm using a pre-collimated laser, the distance from the source to the lens isn't important -- the only thing that matters is that the laser is pointed directly at the center of the lens. 

Since I already needed to buy a lens, I decided to use [an off-the-shelf lens tube](http://www.thorlabs.com/thorproduct.cfm?partnumber=SM05L03) from the same company. I then designed a 3D printable 'adapter' that would bridge the laser module and the lens tube together. As with all press-fits, making sure the sizes came out just right took some trial and error.

![Press-fit laser/lens-tube adapter](http://i.imgur.com/CUfp9oKl.jpg)

## Designing the Three-axis Alignment Assembly

The next problem to tackle was manual alignment. Since we wouldn't want to have to re-design and print a new device for every mirror, we needed a system that would let us fine-tune the alignment of the different components for each device.

My first prototype was a series of interlocking, square plates. Each plate was connected to the one beneath it using four screws, which slide along channels in the other plate, allowing movement along one axis and minimizing rotation. 

![Ugly, barely-functional early prototype](http://i.imgur.com/sMF80I0l.jpg)

The main problem with this design was that, to avoid rotation, the screws had to be far enough apart that they dramatically increased the overall size of the device without improving the range of motion. As you can see in the picture above, there was barely any room to move! 

The next iteration switched to using only two screws. This let me create a smaller device with a much larger range of motion, and it turns out that the ability for the plates to rotate slightly relative to one another is useful for fine-tuning. 

![One plate slides vertically along the other.](https://j.gifs.com/1wVw6m.gif)

This design had its own issues, though -- the heads of the screws from one layer would interfere with the motion of another, which I temporarily solved by printing washers to provide some extra spacing.

After a week of tinkering, printing prototypes, and hammering away at OpenSCAD, I settled on the following design.

{% gist Nesciosquid/65feb7440378f876cb7e threeAxis_exploded.stl %}

The two larger plates both have indentations where [steel nuts](http://www.mcmaster.com/#90480a007/=11can13) are inserted, which pressure-fit into the 3D printed pieces and provide the thread for the screws to attach to from the other side. 

I also swapped out the phillips machine screws for [nylon thumbscrews](http://www.mcmaster.com/#94323a585/=11caov7), which make manual adjustment a lot easier. 

![Pieces of three axis aligner and parts together](http://i.imgur.com/gXeIp1Kl.jpg)

### This device is parametric!

Like a lot of the 3D-printable objects I design these days, I designed this mount as a parametric model in OpenSCAD. This lets me define a bunch of parameters -- the thickness of the layers, the desired movement range of the device, the fixed sizes of my various hardware components, and so on -- which are then used to generate the final 3D model.

This lets me easily play around with different configurations, such as allowing me to reduce the size or thickness of prototypes to make them print faster for quicker turnaround times on each iteration.

## Bringing it all together

In order to move along the Z-axis (towards or away from the mirror), the largest plate of the alignment assembly needs to be mounted to a flat surface in the same way that the individual plates are connected to each other. 

To keep things modular, I designed a baseplate with multiple mounting locations which the assembly can be attached to, depending on how far away we want the lens from the mirror. (To keep the baseplate from just being a solid chunk of plastic, I also wrote up a function to create the hexagonal grid that's punched out of the center.)

{% gist Nesciosquid/65feb7440378f876cb7e threeAxis_baseplate.stl %}

We're still not sure how exactly we want to mount the mirror. I created a temporary solution in TinkerCAD, which holds a tiny breadboard at a 45 degree angle to the expected path of the beam.

{% gist Nesciosquid/65feb7440378f876cb7e threeAxis_target.stl %}

## Results

![Printable view](http://i.imgur.com/BSorOCCl.jpg)

My final version of the complete mount consists of five separate 3D-printed components, which together take about 4.5 hours (and 64 grams of PLA filament) to print, most of which goes into the thick baseplate. 

Including the hardware (a handful of thumbscrews and some nuts), the total cost of the mounting materials is less than $2. I'm not including the lens tube, lens, laser, or mirror into that number, since they're all necessary no matter what kind of mount we use, and they can be easily swapped out and re-used.

The precision of the device has been sufficient to allow me to direct the focused beam onto a stationary 300-micron wide mirror. Next, we need to run some tests with a moving mirror and figure out a way to calibrate each of these devices to make sure they're set up correctly!

### Extra Credit for FDM nerds

If you're paying very close attention, you may notice that [the largest alignment plate has small cylinders in the nut-holes.](http://i.imgur.com/o0U6fOj.jpg) These are support structures, which I explicitly programmed into the design to ensure that those indentations print correctly. This was necessary since FDM printers can't effectively print overhangs with holes in them. (The medium plate can be printed 'upside-down', so these structures aren't needed.)

While most slicing programs can auto-generate support structures for you, they tend to make a mess of small, enclosed spaces. By explicitly creating those cylinders, I can ensure that the structures are easy to remove after printing, making it much easier to insert the nuts.