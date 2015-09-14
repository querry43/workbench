bench();

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

module square_tube(length, width = 25) {
    $fn = 10;
    wall_thickness = 1.59; // 16 gauge

    echo(str("square tube: ", length));

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

module bench() {
    height = 704;
    depth = 465;

    top_overhang = 50;
    top_height = 44;

    pillar_height = height - top_height;
    pillar_depth = depth - top_overhang - top_overhang;
    pillar_bottom_support_height = 75;

    translate([top_overhang, top_overhang])
    left_pillar();

    translate([445, 0, height - top_height])
    top(600, false);

    translate([top_overhang + 445 + 605, top_overhang])
    right_pillar();



    module top(length, add_overhang = true) {
        length = length + (add_overhang ? top_overhang*2 : 0);
        depth = pillar_depth + top_overhang*2;
        echo(str("wood: ", length, "x", depth));
        cube([
            length,
            depth,
            top_height
        ]);
    }

    module right_pillar() {
        pillar(321);

        bins();

        module bins() {
            for (i = [0 : 6]) {
                translate([26, 0, 85 + 55 * i])
                parts_bin();
            }
        }
    }

    module left_pillar() {
        pillar(340);

        bins();

        module bins() {
            for (i = [0 : 4]) {
                translate([30, 0, 85 + 95 * i])
                project_bin();
            }
        }
    }

    module pillar(pillar_width) {
        frame(pillar_width);

        translate([0, pillar_depth-25])
        frame(pillar_width);

        side_supports();

        translate([pillar_width-25, 0])
        side_supports();

        translate([
            -top_overhang,
            -top_overhang,
            height - top_height
        ])
        top(pillar_width);
        
        module frame(width) {
            for (x = [0, width-25]) {
                translate([x, 0])
                square_tube(pillar_height);
            }
    
            translate([25, 0, pillar_height])
            rotate([0, 90])
            square_tube(width-25-25);
    
            translate([25, 0, pillar_bottom_support_height])
            rotate([0, 90])
            square_tube(width-25-25);
        }
    
        module side_supports() {
            for (z = [pillar_bottom_support_height, pillar_height]) {
                translate([0, 25, z])
                rotate([-90])
                square_tube(pillar_depth-25-25);
            }
        }

    }
}
