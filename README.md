standesk
========

Let's do ourselves a favour and make a simple standing desk designed to be back-friendly, robust, cheap and easy to make. A 115 by 80cm 110cm high desk can be made out of a single 250x125cm panel using only a saw or a cnc router.

The intended material is 13mm of this brown coated birch plywood (in german: Sieb-Film Platte), if no one comes up with a better idea ;)

## Status
**in design** – there is just the idea and the openscad model so far, prototype is on the way…

### known flaws :thumbsdown:
	1. Height not variable
	2. Right now, we only use about 84% (see the histogram screenshot) of a 2500x1250 panel when making a 1150x1100x800 desk – *how can we optimize?*
	3. Feet will look distinct: due to the close arrangement of the elements on the panel, the outer surface of the left foot will be the same as the inner surface of the right foot, vice versa. To solve this, one would have to mirror the first foot to create the second one. Right now, the second foot is created by rotating the first one by 180°. But how can we fit all parts on the panel then…?

### known yeahs :thumbsup:
	1. Only wood (or other material of choice), no screws or similar
	2. No tools needed, except for a saw or cnc mill
	3. Adaptable (fully parametrized scad format)
	4. Cheap (reasons: see above)
	5. Easy to source

### pics
![standesk screenshot](standesk-screenshot-assembled.png "standesk screenshot")
![standesk screenshot](140909.standesk-110x115x80-screenshot-histogram.png "standesk screenshot")


## How to build
*TBD: video*


## On the scad model
First, hacky version. Needs a rewrite soon. With
	**0. everything much nicer AND** ;)
	1. a library of elements so we can easily build other furniture and stuff
	2. an algorithm to automagically position the elements as close as possible
	3. detection, if elements fit onto the panel -> warning if not
	…

**Apart from that, you can:**
	- Set your desired dimensions in the top most variables
	- Choose material width, spacings, and all the other properties…
	- Switch to flat=true in order to see the individual parts arranged on the panel


## License
```
----------------------------------------------------------------------------
"PASS-IT-ON LICENSE" <3
As long as you retain this notice, you can do whatever you want with this
stuff. If you think it's worth it, pass it on and do someone else a favour.
----------------------------------------------------------------------------
```