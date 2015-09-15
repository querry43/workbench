parts_bin();

translate([300, 0])
project_bin();

translate([600, 0])
tall_project_bin();

translate([0, 500, 25])
rotate([0, 90])
1in_16ga_square_tube(800);

translate([0, 600])
toggle_latch();

translate([0, 750])
piano_hinge(500);

translate([0, 800])
piano_hinge(500, false);

module parts_bin() {
    depth = 343;
    width = 267;
    height = 42;

    //%bounding_box();

    lid();
    container();
    clasps();

    module bounding_box() {
        cube([width, depth, height]);
    }

    module lid() {
        corner_radius = 7;
        lid_height = 7;

        hull() {
            for (x = [corner_radius, width-corner_radius], y = [corner_radius, depth-corner_radius]) {
                translate([x, y, height-lid_height])
                rounded_corner();
            }
        }

        module rounded_corner() {
            difference() {
                sphere(r = corner_radius);
                translate([-corner_radius, -corner_radius, -corner_radius])
                cube([corner_radius*2, corner_radius*2, corner_radius]);
            }
        }
    }

    module container() {
        corner_radius = 7;

        hull() {
            for (x = [corner_radius+16, width-corner_radius-16], y = [corner_radius+16, depth-corner_radius-16]) {
                translate([x, y])
                rounded_corner();
            }

            for (x = [corner_radius+13, width-corner_radius-13], y = [corner_radius+13, depth-corner_radius-13]) {
                translate([x, y, height-1])
                rounded_corner();
            }
        }

        module rounded_corner() {
            cylinder(h = 1, r = corner_radius);
        }
    }

    module clasps() {
        clasp_length = 79;
        clasp_height = 20;

        translate([width/2 - clasp_length/2, 0, height - clasp_height])
        clasp();

        translate([width/2 + clasp_length/2, depth, height - clasp_height])
        rotate([0, 0, 180])
        clasp();

        module clasp() {
            cube([clasp_length, 11, clasp_height]);
            translate([0, 10, clasp_height])
            cube([clasp_length, 1, 4]);
        }
    }
}

module project_bin(height = 81) {
    depth = 358;
    width = 277;

    //%bounding_box();

    lid();
    container();

    module bounding_box() {
        cube([width, depth, height]);
    }

    module lid() {
        corner_radius = 7;
        lid_height = 13;

        translate([0, 0, height - lid_height])
        hull() {
            for (x = [corner_radius, width-corner_radius], y = [corner_radius, depth-corner_radius]) {
                translate([x, y])
                rounded_corner();
            }
        }

        module rounded_corner() {
            cylinder(h = lid_height, r = corner_radius);
        }
    }

    module container() {
        corner_radius = 5;

        hull() {
            for (x = [corner_radius+16, width-corner_radius-16], y = [corner_radius+29, depth-corner_radius-29]) {
                translate([x, y])
                rounded_corner();
            }

            for (x = [corner_radius+11, width-corner_radius-11], y = [corner_radius+22, depth-corner_radius-22]) {
                translate([x, y, height-1])
                rounded_corner();
            }
        }

        hull() {
            for (x = [corner_radius+12.7, width-corner_radius-12.7], y = [corner_radius+12.5, depth-corner_radius-12.5]) {
                translate([x, y, height-28])
                rounded_corner();
            }

            for (x = [corner_radius+11, width-corner_radius-11], y = [corner_radius+10, depth-corner_radius-10]) {
                translate([x, y, height-1])
                rounded_corner();
            }
        }

        module rounded_corner() {
            cylinder(h = 1, r = corner_radius);
        }
    }
}

module tall_project_bin() { project_bin(height = 154); }

module square_tube(length, width = 25, wall_thickness) {
    $fn = 10;
    wall_thickness = 1.59; // 16 gauge

    pos = [
        [wall_thickness/2, wall_thickness/2],
        [wall_thickness/2, width-wall_thickness/2],
        [width-wall_thickness/2, width-wall_thickness/2],
        [width-wall_thickness/2, wall_thickness/2],
    ];

    for (i = [0 : 3]) {
        hull() {
            translate(pos[i])
            rounded_corner();
            translate(pos[(i+1)%4])
            rounded_corner();
        }
    }

    module rounded_corner() {
        cylinder(h = length, d = wall_thickness);
    }
}

module 1in_16ga_square_tube(length) {
    echo(str("1in 16ga square tube: ", length));
    square_tube(
        length = length,
        width = 25,
        wall_thickness = 1.59
    );
}

module toggle_latch() {
    echo("toggle latch");
    difference() {
        cube([60, 33, 17]);

        translate([5, 5, -1])
        cube([35, 23, 20]);
    }

    hull() {
        translate([99, 6, 5])
        cylinder(d = 6, h = 6);

        translate([99, 27, 5])
        cylinder(d = 6, h = 6);

        translate([80, 21/2+6, 5])
        cylinder(d = 6, h = 6);
    }

    translate([90, 6.5])
    cube([20, 20, 3]);

    translate([20, 33/2, 8])
    rotate([0, 90])
    cylinder(d = 4, h = 60);
}

module piano_hinge(length, open = true) {
    hinge_dia = 10;
    hinge_size = 33;
    hinge_thickness = hinge_dia/2-1;

    echo(str("piano hinge: ", length));

    translate([0, 0, 5])
    rotate([0, 90])
    cylinder(d = hinge_dia, h = length);

    cube([length, hinge_size, hinge_dia/2-1]);

    if (open) {
        translate([0, -hinge_size])
        cube([length, hinge_size, hinge_thickness]);
    } else {
        translate([0, 0, hinge_dia-hinge_thickness])
        cube([length, hinge_size, hinge_thickness]);
    }
}