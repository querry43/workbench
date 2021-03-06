use <materials.scad>

bench();


module bench() {
    height = 704;
    depth = 465;

    top_overhang = 50;
    top_height = 44;

    pillar_height = height - top_height;
    pillar_depth = depth - top_overhang - top_overhang;
    pillar_bottom_support_height = 75;

    frame();

    bridge();

    color("FireBrick")
    hardware();



    module frame() {
        translate([top_overhang, top_overhang])
        left_pillar();

        translate([top_overhang + 441 + 605, top_overhang])
        right_pillar();
    }

    module bridge() {
        translate([439, 0, height - top_height])
        top(600, false);
    }

    module hardware() {
        for (y = [40, depth - 40 - 33]) {
            translate([510, y, height-top_height])
            rotate([0, 180, 0])
            toggle_latch();
        }


        translate([1036.5, 0, height - 50])
        rotate([90, 0, 90])
        piano_hinge(depth, false);

        for (y = [50, depth/2, depth - 50]) {
            translate([428, y, height - (top_height/2)])
            rotate([0, 90])
            3_8_metal_rod(40);
        }

        for (x = [top_overhang+50, top_overhang+290, top_overhang+1090, top_overhang+1320]) {
            translate([x, depth-top_overhang-12, height-top_height-30])
            bolt();

            translate([x-25/2, top_overhang+7, height-top_height-51])
            clamp();
        }

        module bolt() {
            echo("top bolt");
            cylinder(h = 34, d = 10);
        }

        module clamp() {
            echo("top blamp");
            translate([0,20,25])
            cube([25,25,25]);
            cube([25,45,25]);
        }
    }

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
        pillar_width = 321;
        num_bins = 9;

        pillar(pillar_width);

        sliders();
        %bins();

        module sliders() {
            bottom_height = 120;
            for (i = [0 : num_bins-1]) {
                translate([in_to_mm(1), 0, bottom_height + 55 * i])
				    rotate([180, 0, 90])
                1_2_angle_iron(pillar_depth);

                translate([pillar_width-in_to_mm(1), pillar_depth, bottom_height + 55 * i])
				    rotate([180, 0, -90])
                1_2_angle_iron(pillar_depth);
            }
        }

        module bins() {
            for (i = [0 : num_bins-1]) {
                translate([26, 0, 85 + 55 * i])
                parts_bin();
            }
        }
    }

    module left_pillar() {
        pillar_width = 334;
        num_bins = 5;

        pillar(pillar_width);

        sliders();
        %bins();

        module sliders() {
            bottom_height = 155;
            for (i = [0 : num_bins-1]) {
                translate([in_to_mm(1), 0, bottom_height + 95 * i])
				    rotate([180, 0, 90])
                1_2_angle_iron(pillar_depth);

                translate([pillar_width-in_to_mm(1), pillar_depth, bottom_height + 95 * i])
				    rotate([180, 0, -90])
                1_2_angle_iron(pillar_depth);
            }
        }

        module bins() {
            for (i = [0 : num_bins-1]) {
                translate([28, 0, 85 + 95 * i])
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
                1in_16ga_square_tube(pillar_height);
            }
    
				for (z = [pillar_bottom_support_height, pillar_height]) {
                translate([25, 0, z])
                rotate([0, 90])
                1in_16ga_square_tube(width-25-25);
            }
        }
    
        module side_supports() {
            for (z = [pillar_bottom_support_height, pillar_height]) {
                translate([0, 25, z])
                rotate([-90])
                1in_16ga_square_tube(pillar_depth-25-25);
            }
        }
    }
}
