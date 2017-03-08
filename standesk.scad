/**
 * standesk - A customizable standing desk made out of just one plywood panel.
 *
 * Version: 0.0.1
 * Author: Joseph Paul <mail@jsph.pl>
 * License: Public Domain
 */


/***********************************
 * Parameters that are user-settable
 ***********************************/
DESK_HEIGHT = 1100;                                                             // mm // Height of the desk surface above the floor
DESK_WIDTH = 1120;                                                              // mm // Width of the desk surface between feet
DESK_DEPTH = 800;                                                               // mm // Depth of the desk surface between front and rear edge

CORNER_RADIUS = 10;                                                             // mm // Radius for rounding the outer corners

MATERIAL_WIDTH = 1250;                                                          // mm // Width of one panel of the desired raw material
MATERIAL_LENGTH = 1250;                                                         // mm // Length of one panel of the desired raw material
MATERIAL_THICKNESS = 21;                                                        // mm // Thickness of the desired raw material

DRILL_DIAMETER = 6;                                                             // mm // Diameter of the drill bit used to cut the material
PARTS_CLEARANCE = 10;                                                           // mm // Extra space between individual Parts on the panel

/****************
 * Output options
 ****************/
flat = true;
project = true;
panel = true;


// Base Measures (all values in cm)
width = 112;
height = 110;
depth = 80;

// Minimum space between parts on panel
partsSpace = 2;

// Material Properties
thickness = 2.1;
panelX = 250; // just for the reference panel
panelY = 125; // displayed in grey when flat=true

// Foot
baseHeight = 20;
standDepth = 18;
standSpace = 20;

// Rest
restDepth = 15;
restLevel = 24;
restAngle = 15; // degrees

// Crosses
crossCut = max(height/7, 14); // 1/7th of height if > 140mm
crossSpace = 0;
crossAngle = atan((height - crossCut) / width);
crossWidth = sin(90 - crossAngle) * crossCut;

// Joints
jointWidth = 9;
jointLength = 5.5;
jointTolerance = 0;
jointHoleWidth = thickness + jointTolerance;
jointHoleLength = thickness * 1.2;
jointHoleOffset = thickness * 0.8;
jointHoleTolerance = 0.1;
jointBuffer = max(2.4*thickness, 0.6); // at least 6mm

// Keys
keyLength = 5;
keyThickness = thickness * 1.2;

// Flat Offsets
crossesFlatXOff = depth + jointLength/2 + partsSpace;
crossesFlatYOff = depth + partsSpace;


/*
	Table Top
*/
module top(flat = false) {
	trans = flat ? [depth, jointLength+1, 0] : [0, 0, height];
	rot = flat ? [0, 0, 90] : [0, 0, 0];
	translate(trans)
	rotate(rot)
	union() {
		cube(size = [width, depth, thickness]);

		// joints
		// left
		translate([0, depth - (standDepth - jointWidth) / 2, 0])
		rotate([90, 0, -90])
		joint();
		translate([0, standSpace + standDepth - (standDepth - jointWidth) / 2, 0])
		rotate([90, 0, -90])
		joint();

		// right
		translate([width, depth - (standDepth + jointWidth) / 2, 0])
		rotate([90, 0, 90])
		joint();
		translate([width, standSpace + (standDepth - jointWidth) / 2, 0])
		rotate([90, 0, 90])
		joint();
	}
}

/*
	Both feet with holes cut out
*/
module feet(flat = false) {
	if (flat)
	{
		translate([depth + partsSpace, -partsSpace, thickness])
		{
			rotate([0, 180, 0])
			{
				translate([0, partsSpace, 0])
				rotate([0, -90, 0])
				foot("left", flat = true);

				translate([-height -jointBuffer -partsSpace -baseHeight, depth+2, 0])
				rotate([0, -90, 180])
				foot("right", flat = true);
			}
		}
	}
	else
	{
		translate([-thickness, 0, 0])
		{
			foot("left", flat = false);

			translate([width + thickness, 0, 0])
			foot("right", flat = false);
		}
	}
}


/*
	A foot with holes cut out

	@side ["left"|"right"]
*/
module foot(side, flat = false) {

	if (side == "left")
	{
		// left
		difference() {

			baseFoot();

			// holes
			union() {

				// top
				translate([0, standSpace + (standDepth - jointWidth)/2, height])
				rotate([90, 0, 90])
				jointHole();
				translate([0, depth - (standDepth + jointWidth)/2, height])
				rotate([90, 0, 90])
				jointHole();

				// cross
				translate([0, depth + crossSpace - standDepth/2, (crossCut + jointWidth)/2])
				rotate([0, 90, 0])
				jointHole();
				translate([0, depth - standDepth/2 - (thickness + crossSpace), height - (crossCut - jointWidth)/2])
				rotate([0, 90, 0])
				jointHole();

				// rest
				translate([thickness, standSpace + (standDepth - restDepth)/2, restLevel])
				rotate([restAngle, 0, 0])
				translate([0, (restDepth + jointWidth) / 2, 0])
				rotate([90, 0, -90])
				jointHole();

			}
		}
	}

	if (side == "right")
	{
		//right
		difference() {

			baseFoot();

			// holes
			union() {

				// top
				translate([0, standSpace + (standDepth - jointWidth)/2, height])
				rotate([90, 0, 90])
				jointHole();
				translate([0, depth - (standDepth + jointWidth)/2, height])
				rotate([90, 0, 90])
				jointHole();

				// cross
				translate([0, depth - standDepth/2 - (thickness + crossSpace), (crossCut + jointWidth)/2])
				rotate([0, 90, 0])
				jointHole();
				translate([0, depth - standDepth/2 + crossSpace, height - (crossCut - jointWidth)/2])
				rotate([0, 90, 0])
				jointHole();

				// rest
				translate([thickness, standSpace + (standDepth - restDepth)/2, restLevel])
				rotate([restAngle, 0, 0])
				translate([thickness, (restDepth + jointWidth) / 2, 0])
				rotate([90, 0, -90])
				jointHole();

			}
		}
	}
}


/*
	A Single Table Foot without holes
*/
module baseFoot() {
	union() {

		// base
		cube(size = [thickness, depth, baseHeight]);

		// 2 stands
		translate([0, depth - standDepth, 0])
		cube(size = [thickness, standDepth, height + jointBuffer]);

		translate([0, standSpace, 0])
		cube(size = [thickness, standDepth, height + jointBuffer]);

	}
}


/*
	Both crosses
*/
module crosses(flat = true) {
	if(flat)
	{
		translate([crossesFlatXOff, crossesFlatYOff, 0])
		{
			cross(flat = true);
			translate([0, crossWidth + partsSpace, 0])
			cross(flat = true);
		}
	}
	else
	{
		translate([0, depth - standDepth/2, 0])
		union() {
			// cross 1
			translate([0, thickness + crossSpace, 0])
			cross();

			// cross 2
			translate([width, -crossSpace, 0])
			mirror([1, 0, 0])
			cross();
		}
	}
}

module cross(flat = false) {
	rotX1 = flat ? 0 : 90;
	rotX2 = flat ? -90 : 0;
	rotZ = flat ? -crossAngle : 0;
	rotate([0, 0, rotZ])
	union() {
		rotate([rotX1, 0, 0])
		linear_extrude(height = thickness)
		polygon(
			points = [
				[0, 0],
				[width, height - crossCut],
				[width, height],
				[0, crossCut]
			],
			paths = [
				[0, 1, 2, 3]
			]
		);

		// joints
		rotate([rotX2, 0, 0]) {
			translate([0, -thickness, (crossCut - jointWidth)/2])
			rotate([0, -90, 0])
			joint();
			translate([width, -thickness, height- (crossCut - jointWidth)/2])
			rotate([0, 90, 0])
			joint();
		}
	}
}

/*
	The foot rest
*/
module rest(flat = false) {
	rot = flat ? [0, 0, 0] : [restAngle, 0, 0];
	trans = flat ? [depth + jointLength + partsSpace + 1, crossesFlatYOff + 2*(crossWidth + partsSpace), 0] : [0, standSpace + (standDepth - restDepth)/2, restLevel];

	translate(trans)
	rotate(rot)
	union() {
		cube([width, restDepth, thickness]);

		// joints
		translate([0, (restDepth + jointWidth) / 2, 0])
		rotate([90, 0, -90])
		joint();
		translate([width, (restDepth - jointWidth) / 2, 0])
		rotate([90, 0, 90])
		joint();
	}
}

/*
	Joints
*/
module joint() {
	translate([0, 0, -0.5])
	difference() {
		jointF();
		translate([
			(jointWidth - jointHoleWidth) / 2,
			0,
			0
		])
		translate([0, -1, jointHoleOffset])
		cube([jointHoleWidth, thickness + 2, jointHoleLength]);
	}
}

module jointF() {
	cube([jointWidth, thickness, jointLength + 1]);
}
module jointHole() {
	translate([-jointHoleTolerance/2, -jointHoleTolerance/2, -jointHoleTolerance/2])
	cube([jointWidth + jointHoleTolerance, thickness + jointHoleTolerance, jointLength + jointHoleTolerance]);
}

module keys() {
    if (flat) {
        translate([panelX - partsSpace - keyLength, partsSpace, 0])
        for(n = [0 : 9]) {
            translate([0, (keyThickness + partsSpace) * n, 0])
            key();
        }
    }
}

module key() {
    linear_extrude(height = thickness)
    polygon([[0, 0], [keyLength, 0], [0, keyThickness]]);
}


/*
    The entire desk
*/
module desk(flat) {
    feet(flat = flat);
    top(flat = flat);
    crosses(flat = flat);
    rest(flat = flat);
    keys(flat = flat);
}

/*
	The Panel as a reference
*/
module panel(){
	cube([panelX, panelY, thickness]);
}


if (flat && project) {
    projection(cut = false)
    desk(flat = flat);
}
else {
    desk(flat = flat);
}

if (flat && panel)
{
	%panel();
}
