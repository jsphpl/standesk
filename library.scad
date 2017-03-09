/**
 * A small concave wedge to add to or subtract
 * from corners in order to make them round.
 *
 * @param  {Number} radius  Radius of the rounding
 * @param  {Number} height  Height of the wedge
 */
module roundCorner(radius, height) {
    translate([radius / 2, radius / 2, height/2])

        difference() {
            cube([radius + 0.01, radius + 0.01, height + 0.01], center = true);

            translate([radius/2, radius/2, 0])
                cylinder(r = radius, h = height + 0.01, center = true);

        }
}

/**
 * A cube with dogbone fillets in the XY-plane.
 *
 * @param  {Vector} dimensions A regular vector specifying the cube's dimensions
 * @param  {Number} radius     Radius of the fillets
 */
module dogboneCube(dimensions, radius) {
	union() {
		cube(dimensions);
		translate([0, 0, 0]) rotate([0, 0, 0])  fillet(radius, dimensions[2]);
		translate([dimensions[0], 0, 0]) rotate([0, 0, 90])  fillet(radius, dimensions[2]);
		translate([dimensions[0], dimensions[1], 0]) rotate([0, 0, 180])  fillet(radius, dimensions[2]);
		translate([0, dimensions[1], 0]) rotate([0, 0, 270])  fillet(radius, dimensions[2]);
	}
}

/**
 * A single cylinder to be used as negative for subtracting fillets.
 *
 * @param  {Number} radius Radius of the fillet
 * @param  {Number} height Stock thickness
 */
module fillet(radius, height) {
	offset = sin(45)*radius;
	translate([offset, offset, STOCK_THICKNESS/2])
	cylinder(r = radius, h = height + 0.01, center = true);
}
