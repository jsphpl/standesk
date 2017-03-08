

module roundConvex(r, h, fn = 40) {
    h=h+2;
    translate([r / 2, r / 2, h/2 - 1])

        difference() {
            cube([r + 0.01, r + 0.01, h], center = true);

            translate([r/2, r/2, 0])
                cylinder(r = r, h = h + 1, center = true, $fn = fn);

        }
}

module roundConcave(r, h, fn = 40) {
    translate([r / 2, r / 2, h/2])

        difference() {
            cube([r + 0.01, r + 0.01, h], center = true);

            translate([r/2, r/2, 0])
                cylinder(r = r, h = h + 1, center = true, $fn = fn);

        }
}

module dogboneCube(dimensions, radius, fn = 40) {
	union() {
		offset = sin(45)*radius;
		cube(dimensions);
		translate([0, 0, dimensions[2]/2]) {

			translate([offset, offset, 0]) cylinder(r = radius, h = dimensions[2], center = true, $fn = fn);
			translate([dimensions[0]-offset, offset, 0]) cylinder(r = radius, h = dimensions[2], center = true, $fn = fn);
			translate([dimensions[0]-offset, dimensions[1]-offset, 0]) cylinder(r = radius, h = dimensions[2], center = true, $fn = fn);
			translate([offset, dimensions[1]-offset, 0]) cylinder(r = radius, h = dimensions[2], center = true, $fn = fn);
		}
	}
}
