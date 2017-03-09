/**
 * standesk - A customizable standing desk made out of just one plywood panel.
 *
 * Version: 0.1.4
 * Author: Joseph Paul <mail@jsph.pl>
 * License: Public Domain
 */

/*
|-------------------------------------------------------------------------------
| Parameters (user-settable)
|-------------------------------------------------------------------------------
*/
DESK_HEIGHT = 1100;                                                             // mm // Height of the desk surface above the floor
DESK_WIDTH = 1120;                                                              // mm // Width of the desk surface between feet
DESK_DEPTH = 800;                                                               // mm // Depth of the desk surface between front and rear edge

CORNER_RADIUS = 10;                                                             // mm // Radius for rounding the outer corners
FILLET_RADIUS = 5;                                                            	// mm // Radius for dogbone fillets
DRILL_DIAMETER = 6;                                                             // mm // Diameter of the drill bit used to cut the material
CLEARANCE = 10;                                                           		// mm // Extra space between individual Parts on the panel

STOCK_WIDTH = 1250;                                                          	// mm // Width of one panel of the desired raw material
STOCK_LENGTH = 2500;                                                         	// mm // Length of one panel of the desired raw material
STOCK_THICKNESS = 18;                                                        	// mm // Thickness of the desired raw material


/*
|-------------------------------------------------------------------------------
| Output Options
|-------------------------------------------------------------------------------
*/
FLAT = true;
PROJECTION = false;
SHOW_STOCK = false;
TEST_JOINT = false;
$fn = 24;


/*
|-------------------------------------------------------------------------------
| Details
|-------------------------------------------------------------------------------
*/
// Feet
BASE_HEIGHT = 200;
STAND_DEPTH = 180;
STAND_SPACE = 200;

// Foot rest
REST_DEPTH = 150;
REST_LEVEL = 240;
REST_ANGLE = 15; // degrees

// Top Support (another strut right below the table top as a
// support when using thinner material, recommended < 15mm)
TOPSUPPORT_ON = true;
TOPSUPPORT_DEPTH = 130;

// Crosses
CROSS_CUT = max(DESK_HEIGHT/7, 140); 	// 1/7th of DESK_HEIGHT if > 140mm
CROSS_CLEARANCE = 0;
CROSS_ANGLE = atan((DESK_HEIGHT - CROSS_CUT) / DESK_WIDTH);
CROSS_WIDTH = sin(90 - CROSS_ANGLE) * CROSS_CUT;
CROSS_SINGLE = true;  					// Use only one strut for the cross

// Joints
JOINT_WIDTH = 90;
JOINT_LENGTH = 55;
JOINT_TOLERANCE = 0;
JOINT_SLOT_WIDTH = STOCK_THICKNESS + JOINT_TOLERANCE;
JOINT_SLOT_LENGTH = STOCK_THICKNESS * 1.2;
JOINT_SLOT_OFFSET = STOCK_THICKNESS * 0.8;
JOINT_SLOT_TOLERANCE = 1;
JOINT_BUFFER = max(2.4*STOCK_THICKNESS, 6); // at least 6mm

// Keys
KEY_LENGTH = 50;
KEY_THICKNESS = STOCK_THICKNESS * 1.2;

// Flat Offsets
CROSSES_FLAT_OFFSET_X = DESK_DEPTH + JOINT_LENGTH/2 + CLEARANCE;
CROSSES_FLAT_OFFSET_Y = DESK_DEPTH + CLEARANCE;


/*
|-------------------------------------------------------------------------------
| Includes
|-------------------------------------------------------------------------------
*/
include <library.scad>;


/*
|-------------------------------------------------------------------------------
| Model
|-------------------------------------------------------------------------------
|
| The actual model
|
*/

/**
 * The table top surface.
 */
module top() {
	trans = FLAT ? [DESK_DEPTH, JOINT_LENGTH+1, 0] : [0, 0, DESK_HEIGHT];
	rot = FLAT ? [0, 0, 90] : [0, 0, 0];
	translate(trans)
	rotate(rot)
	difference() {
		union() {
			cube(size = [DESK_WIDTH, DESK_DEPTH, STOCK_THICKNESS]);

			// Joints
			// left
			translate([0, DESK_DEPTH - (STAND_DEPTH - JOINT_WIDTH) / 2, 0])
			rotate([90, 0, -90])
			joint();
			translate([0, STAND_SPACE + STAND_DEPTH - (STAND_DEPTH - JOINT_WIDTH) / 2, 0])
			rotate([90, 0, -90])
			joint();

			// right
			translate([DESK_WIDTH, DESK_DEPTH - (STAND_DEPTH + JOINT_WIDTH) / 2, 0])
			rotate([90, 0, 90])
			joint();
			translate([DESK_WIDTH, STAND_SPACE + (STAND_DEPTH - JOINT_WIDTH) / 2, 0])
			rotate([90, 0, 90])
			joint();
		}

		// Rounded corners
		roundCorner(CORNER_RADIUS, STOCK_THICKNESS);
		translate([DESK_WIDTH, 0, 0]) rotate([0, 0, 90]) roundCorner(CORNER_RADIUS, STOCK_THICKNESS);
		translate([DESK_WIDTH, DESK_DEPTH, 0]) rotate([0, 0, 180]) roundCorner(CORNER_RADIUS, STOCK_THICKNESS);
		translate([0, DESK_DEPTH, 0]) rotate([0, 0, 270]) roundCorner(CORNER_RADIUS, STOCK_THICKNESS);

		// Fillets
		// left
		translate([0, DESK_DEPTH - (STAND_DEPTH - JOINT_WIDTH) / 2, 0]) rotate([0, 0, 90]) fillet(FILLET_RADIUS, STOCK_THICKNESS);
		translate([0, DESK_DEPTH - (STAND_DEPTH - JOINT_WIDTH) / 2 - JOINT_WIDTH, 0]) rotate([0, 0, 180]) fillet(FILLET_RADIUS, STOCK_THICKNESS);
		translate([0, STAND_SPACE + STAND_DEPTH - (STAND_DEPTH - JOINT_WIDTH) / 2, 0])  rotate([0, 0, 90]) fillet(FILLET_RADIUS, STOCK_THICKNESS);
		translate([0, STAND_SPACE + STAND_DEPTH - (STAND_DEPTH - JOINT_WIDTH) / 2 - JOINT_WIDTH, 0])  rotate([0, 0, 180]) fillet(FILLET_RADIUS, STOCK_THICKNESS);
		// right
		translate([DESK_WIDTH, DESK_DEPTH - (STAND_DEPTH + JOINT_WIDTH) / 2, 0]) rotate([0, 0, 270]) fillet(FILLET_RADIUS, STOCK_THICKNESS);
		translate([DESK_WIDTH, DESK_DEPTH - (STAND_DEPTH + JOINT_WIDTH) / 2 + JOINT_WIDTH, 0]) rotate([0, 0, 0]) fillet(FILLET_RADIUS, STOCK_THICKNESS);
		translate([DESK_WIDTH, STAND_SPACE + (STAND_DEPTH - JOINT_WIDTH) / 2, 0])  rotate([0, 0, 270]) fillet(FILLET_RADIUS, STOCK_THICKNESS);
		translate([DESK_WIDTH, STAND_SPACE + (STAND_DEPTH - JOINT_WIDTH) / 2 + JOINT_WIDTH, 0])  rotate([0, 0, 0]) fillet(FILLET_RADIUS, STOCK_THICKNESS);
	}
}

/**
 * Both complete feet.
 */
module feet() {
	if (FLAT)
	{
		translate([DESK_DEPTH + CLEARANCE, -CLEARANCE, STOCK_THICKNESS])
		{
			rotate([0, 180, 0])
			{
				translate([0, CLEARANCE, 0])
				rotate([0, -90, 0])
				foot("left");

				translate([-DESK_HEIGHT -JOINT_BUFFER -CLEARANCE -BASE_HEIGHT, DESK_DEPTH+CLEARANCE, 0])
				rotate([0, -90, 180])
				foot("right");
			}
		}
	}
	else
	{
		translate([-STOCK_THICKNESS, 0, 0])
		{
			foot("left");

			translate([DESK_WIDTH + STOCK_THICKNESS, 0, 0])
			foot("right");
		}
	}
}

/**
 * A complete foot (left or right) with holes cut out.
 *
 * @param  {String} side Which side foot (left|right)
 */
module foot(side) {

	if (side == "left")
	{
		// left
		difference() {

			baseFoot();

			// holes
			union() {

				// top
				translate([0, STAND_SPACE + (STAND_DEPTH - JOINT_WIDTH)/2, DESK_HEIGHT])
				rotate([90, 0, 90])
				jointHole();
				translate([0, DESK_DEPTH - (STAND_DEPTH + JOINT_WIDTH)/2, DESK_HEIGHT])
				rotate([90, 0, 90])
				jointHole();

				// cross
				translate([0, DESK_DEPTH + CROSS_CLEARANCE - STAND_DEPTH/2, (CROSS_CUT + JOINT_WIDTH)/2])
				rotate([0, 90, 0])
				jointHole();
				translate([0, DESK_DEPTH - STAND_DEPTH/2 - (STOCK_THICKNESS + CROSS_CLEARANCE), DESK_HEIGHT - (CROSS_CUT - JOINT_WIDTH)/2])
				rotate([0, 90, 0])
				jointHole();

				// rest
				translate([STOCK_THICKNESS, STAND_SPACE + (STAND_DEPTH - REST_DEPTH)/2, REST_LEVEL])
				rotate([REST_ANGLE, 0, 0])
				translate([0, (REST_DEPTH + JOINT_WIDTH) / 2, 0])
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
				translate([0, STAND_SPACE + (STAND_DEPTH - JOINT_WIDTH)/2, DESK_HEIGHT])
				rotate([90, 0, 90])
				jointHole();
				translate([0, DESK_DEPTH - (STAND_DEPTH + JOINT_WIDTH)/2, DESK_HEIGHT])
				rotate([90, 0, 90])
				jointHole();

				// cross
				translate([0, DESK_DEPTH - STAND_DEPTH/2 - (STOCK_THICKNESS + CROSS_CLEARANCE), (CROSS_CUT + JOINT_WIDTH)/2])
				rotate([0, 90, 0])
				jointHole();
				translate([0, DESK_DEPTH - STAND_DEPTH/2 + CROSS_CLEARANCE, DESK_HEIGHT - (CROSS_CUT - JOINT_WIDTH)/2])
				rotate([0, 90, 0])
				jointHole();

				// rest
				translate([STOCK_THICKNESS, STAND_SPACE + (STAND_DEPTH - REST_DEPTH)/2, REST_LEVEL])
				rotate([REST_ANGLE, 0, 0])
				translate([STOCK_THICKNESS, (REST_DEPTH + JOINT_WIDTH) / 2, 0])
				rotate([90, 0, -90])
				jointHole();

			}
		}
	}
}

/**
 * A Single Table Foot without holes.
 */
module baseFoot() {
	union() {

		// base
		difference() {
			cube(size = [STOCK_THICKNESS, DESK_DEPTH, BASE_HEIGHT]);

			// Rounded corners
			rotate([90, 0, 90]) roundCorner(CORNER_RADIUS, STOCK_THICKNESS);
			translate([0, 0, BASE_HEIGHT]) rotate([0, 90, 0]) roundCorner(CORNER_RADIUS, STOCK_THICKNESS);
			translate([0, DESK_DEPTH, 0]) rotate([180, -90, 0]) roundCorner(CORNER_RADIUS, STOCK_THICKNESS);
		}

		// 2 stands
		translate([0, DESK_DEPTH - STAND_DEPTH, 0])
		footStand();

		translate([0, STAND_SPACE, 0])
		footStand();

		// Rounded corners
		translate([0, STAND_SPACE+ STAND_DEPTH, BASE_HEIGHT]) rotate([90, 0, 90]) roundCorner(CORNER_RADIUS, STOCK_THICKNESS);
		translate([0, STAND_SPACE, BASE_HEIGHT]) rotate([90, 270, 90]) roundCorner(CORNER_RADIUS, STOCK_THICKNESS);
		translate([0, DESK_DEPTH-STAND_DEPTH, BASE_HEIGHT]) rotate([90, 270, 90]) roundCorner(CORNER_RADIUS, STOCK_THICKNESS);
	}
}

/**
 * One vertical strut with holes cut out. Needed twice per foot.
 */
module footStand() {
	totalHeight = DESK_HEIGHT + JOINT_BUFFER;

	difference() {
		cube(size = [STOCK_THICKNESS, STAND_DEPTH, totalHeight]);

		// Rounded corners
		translate([0, 0, totalHeight]) rotate([0, 90, 0]) roundCorner(CORNER_RADIUS, STOCK_THICKNESS);
		translate([STOCK_THICKNESS, STAND_DEPTH, totalHeight]) rotate([0, 90, 180]) roundCorner(CORNER_RADIUS, STOCK_THICKNESS);
	}
}

/**
 * Both crosses.
 */
module crosses() {
	if(FLAT)
	{
		translate([CROSSES_FLAT_OFFSET_X, CROSSES_FLAT_OFFSET_Y, 0])
		{
			cross();

			if (! CROSS_SINGLE) {
				translate([0, CROSS_WIDTH + CLEARANCE, 0])
				cross();
			}
		}
	}
	else
	{
		translate([0, DESK_DEPTH - STAND_DEPTH/2, 0])
		union() {
			// cross 1
			translate([0, STOCK_THICKNESS + CROSS_CLEARANCE, 0])
			cross();

			if (! CROSS_SINGLE) {
				// cross 2
				translate([DESK_WIDTH, -CROSS_CLEARANCE, 0])
				mirror([1, 0, 0])
				cross();
			}
		}
	}
}

/**
 * A single diagonal strut.
 */
module cross() {
	rotX1 = FLAT ? 0 : 90;
	rotX2 = FLAT ? -90 : 0;
	rotZ = FLAT ? -CROSS_ANGLE : 0;
	rotate([0, 0, rotZ])
	difference() {
		union() {
			rotate([rotX1, 0, 0])
			linear_extrude(height = STOCK_THICKNESS)
			polygon(
				points = [
					[0, 0],
					[DESK_WIDTH, DESK_HEIGHT - CROSS_CUT],
					[DESK_WIDTH, DESK_HEIGHT],
					[0, CROSS_CUT]
				],
				paths = [
					[0, 1, 2, 3]
				]
			);

			// Joints
			rotate([rotX2, 0, 0]) {
				translate([0, -STOCK_THICKNESS, (CROSS_CUT - JOINT_WIDTH)/2])
				rotate([0, -90, 0])
				joint();
				translate([DESK_WIDTH, -STOCK_THICKNESS, DESK_HEIGHT- (CROSS_CUT - JOINT_WIDTH)/2])
				rotate([0, 90, 0])
				joint();
			}
		}

		// Fillets
		rotate([rotX2, 0, 0]) {
			translate([2, -STOCK_THICKNESS, (CROSS_CUT - JOINT_WIDTH)/2]) rotate([90, 90, 180]) fillet(FILLET_RADIUS, STOCK_THICKNESS);
			translate([2, -STOCK_THICKNESS, (CROSS_CUT - JOINT_WIDTH)/2 + JOINT_WIDTH]) rotate([90, 0, 180]) fillet(FILLET_RADIUS, STOCK_THICKNESS);

			translate([DESK_WIDTH, -STOCK_THICKNESS, DESK_HEIGHT- (CROSS_CUT - JOINT_WIDTH)/2]) rotate([90, 270, 180]) fillet(FILLET_RADIUS, STOCK_THICKNESS);
			translate([DESK_WIDTH, -STOCK_THICKNESS, DESK_HEIGHT- (CROSS_CUT - JOINT_WIDTH)/2 - JOINT_WIDTH]) rotate([90, 180, 180]) fillet(FILLET_RADIUS, STOCK_THICKNESS);
		}
	}
}

/**
 * The lower horizontal bar intened as a foot rest.
 */
module rest() {
	rot = FLAT ? [0, 0, 0] : [REST_ANGLE, 0, 0];
	trans = FLAT ? [DESK_DEPTH + JOINT_LENGTH + CLEARANCE + 1, CROSSES_FLAT_OFFSET_Y + 2*CROSS_WIDTH +3*CLEARANCE, 0] : [0, STAND_SPACE + (STAND_DEPTH - REST_DEPTH)/2, REST_LEVEL];

	translate(trans)
	rotate(rot)
	difference() {
		union() {
			cube([DESK_WIDTH, REST_DEPTH, STOCK_THICKNESS]);

			// joints
			translate([0, (REST_DEPTH + JOINT_WIDTH) / 2, 0])
			rotate([90, 0, -90])
			joint();
			translate([DESK_WIDTH, (REST_DEPTH - JOINT_WIDTH) / 2, 0])
			rotate([90, 0, 90])
			joint();
		}

		// Fillets
		translate([0, (REST_DEPTH + JOINT_WIDTH) / 2, 0]) rotate([0, 0, 90]) fillet(FILLET_RADIUS, STOCK_THICKNESS);
		translate([0, (REST_DEPTH + JOINT_WIDTH) / 2 - JOINT_WIDTH, 0]) rotate([0, 0, 180]) fillet(FILLET_RADIUS, STOCK_THICKNESS);

		translate([DESK_WIDTH, (REST_DEPTH - JOINT_WIDTH) / 2, 0]) rotate([0, 0, 270]) fillet(FILLET_RADIUS, STOCK_THICKNESS);
		translate([DESK_WIDTH, (REST_DEPTH - JOINT_WIDTH) / 2 + JOINT_WIDTH, 0]) rotate([0, 0, 0]) fillet(FILLET_RADIUS, STOCK_THICKNESS);
	}
}

/**
 * The top support strut. Intended to reinforce the
 * table top when using thin stock material.
 */
module topsupport() {
	if (TOPSUPPORT_ON) {
		rot = FLAT ? [0, 0, 0] : [90, 0, 0];
		trans = FLAT ? [CROSSES_FLAT_OFFSET_X + 3*CLEARANCE, CROSSES_FLAT_OFFSET_Y + CROSS_WIDTH + CLEARANCE, 0] : [0, STAND_SPACE + (STAND_DEPTH+STOCK_THICKNESS)/2, DESK_HEIGHT-TOPSUPPORT_DEPTH];

		translate(trans)
		rotate(rot)
		difference() {
			union() {
				cube([DESK_WIDTH, TOPSUPPORT_DEPTH, STOCK_THICKNESS]);

				// joints
				translate([0, (TOPSUPPORT_DEPTH + JOINT_WIDTH) / 2, 0])
				rotate([90, 0, -90])
				joint();
				translate([DESK_WIDTH, (TOPSUPPORT_DEPTH - JOINT_WIDTH) / 2, 0])
				rotate([90, 0, 90])
				joint();
			}

			// Fillets
			translate([0, (TOPSUPPORT_DEPTH + JOINT_WIDTH) / 2, 0]) rotate([0, 0, 90]) fillet(FILLET_RADIUS, STOCK_THICKNESS);
			translate([0, (TOPSUPPORT_DEPTH + JOINT_WIDTH) / 2 - JOINT_WIDTH, 0]) rotate([0, 0, 180]) fillet(FILLET_RADIUS, STOCK_THICKNESS);

			translate([DESK_WIDTH, (TOPSUPPORT_DEPTH - JOINT_WIDTH) / 2, 0]) rotate([0, 0, 270]) fillet(FILLET_RADIUS, STOCK_THICKNESS);
			translate([DESK_WIDTH, (TOPSUPPORT_DEPTH - JOINT_WIDTH) / 2 + JOINT_WIDTH, 0]) rotate([0, 0, 0]) fillet(FILLET_RADIUS, STOCK_THICKNESS);
		}
	}
}

/**
 * The male part of a joint, with a hole for the key.
 */
module joint() {
	translate([0, 0, -0.5])
	difference() {
		cube([JOINT_WIDTH, STOCK_THICKNESS, JOINT_LENGTH + 1]);

		// Rounded corners
		translate([0, STOCK_THICKNESS, JOINT_LENGTH + 1]) rotate([90, 90, 0]) roundCorner(CORNER_RADIUS, STOCK_THICKNESS);
		translate([JOINT_WIDTH, STOCK_THICKNESS, JOINT_LENGTH + 1]) rotate([90, 180, 0]) roundCorner(CORNER_RADIUS, STOCK_THICKNESS);

		translate([
			(JOINT_WIDTH - JOINT_SLOT_WIDTH) / 2,
			0,
			0
		])
		translate([0, STOCK_THICKNESS+1, JOINT_SLOT_OFFSET])
		rotate([90, 0, 0])
			dogboneCube([JOINT_SLOT_WIDTH, JOINT_SLOT_LENGTH, STOCK_THICKNESS + 2], FILLET_RADIUS);
	}
}

/**
 * The female part of a joint. This one is positive
 * and intended to be subtractad from other objects.
 */
module jointHole() {
	translate([-JOINT_SLOT_TOLERANCE/2, -JOINT_SLOT_TOLERANCE/2, -JOINT_SLOT_TOLERANCE/2])
	dogboneCube([JOINT_WIDTH + JOINT_SLOT_TOLERANCE, STOCK_THICKNESS + JOINT_SLOT_TOLERANCE, STOCK_THICKNESS + JOINT_SLOT_TOLERANCE], FILLET_RADIUS);
}

/**
 * All keys next to each other.
 */
module keys() {
	if (FLAT) {
		translate([DESK_DEPTH + DESK_HEIGHT + BASE_HEIGHT + 8*CLEARANCE, CLEARANCE, 0])
		for(n = [0 : 9]) {
			translate([0, (KEY_THICKNESS + CLEARANCE) * n, 0])
			key();
		}
	}
}

/**
 * A single key.
 */
module key() {
	linear_extrude(height = STOCK_THICKNESS)
	polygon([[0, 0], [KEY_LENGTH, 0], [0, KEY_THICKNESS]]);
}

/**
 * Male and female part of a joint plus key for test cutting.
 */
module jointTest() {
	if (FLAT) {
		FEMALE_X = STOCK_THICKNESS*3;
		FEMALE_Y = JOINT_WIDTH+2*STOCK_THICKNESS;

		translate([STOCK_LENGTH - FEMALE_X - CLEARANCE, CLEARANCE, 0]) {
			// Female
			difference() {
				cube([FEMALE_X, FEMALE_Y, STOCK_THICKNESS]);
				translate([2*STOCK_THICKNESS, STOCK_THICKNESS, 0]) rotate([0, 0, 90]) jointHole();
			}

			// Male
			translate([-(FEMALE_X + CLEARANCE), CLEARANCE + STOCK_THICKNESS, 0])
			rotate([0, 0, 90])
			difference() {
				union() {
					translate([-STOCK_THICKNESS, 0, 0]) cube([JOINT_WIDTH+2*STOCK_THICKNESS, 2*STOCK_THICKNESS, STOCK_THICKNESS]);
					rotate([90, 0, 0]) joint();
				}
				// Fillets
				rotate([0, 0, 180]) fillet(FILLET_RADIUS, STOCK_THICKNESS);
				translate([JOINT_WIDTH, 0, 0]) rotate([0, 0, 270]) fillet(FILLET_RADIUS, STOCK_THICKNESS);
			}

			// Key
			translate([0, FEMALE_Y + CLEARANCE, 0]) key();
		}
	}
}


/**
 * The full desk.
 */
module desk() {
	feet();
	top();
	crosses();
	rest();
	topsupport();
	keys();
}

/**
 * The stock panel as a reference.
 */
module stock(){
	cube([STOCK_LENGTH, STOCK_WIDTH, STOCK_THICKNESS]);
}

/**
 * Render either the desk or the joint tests.
 */
module show() {
	if (TEST_JOINT) {
		jointTest();
	}
	else {
		desk();
	}
}


/*
|-------------------------------------------------------------------------------
| Rendering logic
|-------------------------------------------------------------------------------
*/
if (FLAT && PROJECTION) {
	projection(cut = true)
	translate([0, 0, -STOCK_THICKNESS/2])
	show();
}
else {
	show();
}

if (FLAT && SHOW_STOCK)
{
	%stock();
}
