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
		offset = sin(45)*radius;
		cube(dimensions);
		translate([0, 0, dimensions[2]/2]) {

			translate([offset, offset, 0]) cylinder(r = radius, h = dimensions[2], center = true);
			translate([dimensions[0]-offset, offset, 0]) cylinder(r = radius, h = dimensions[2], center = true);
			translate([dimensions[0]-offset, dimensions[1]-offset, 0]) cylinder(r = radius, h = dimensions[2], center = true);
			translate([offset, dimensions[1]-offset, 0]) cylinder(r = radius, h = dimensions[2], center = true);
		}
	}
}
