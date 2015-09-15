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

    translate([top_overhang, top_overhang])
    left_pillar();

    translate([445, 0, height - top_height])
    top(600, false);

    translate([top_overhang + 445 + 605, top_overhang])
    right_pillar();

    translate([510, 40, height-top_height])
    rotate([0, 180, 0])
    toggle_latch();

    translate([510, depth - 40 - 33, height-top_height])
    rotate([0, 180, 0])
    toggle_latch();

    translate([1042.5, 0, height - 50])
    rotate([90, 0, 90])
    piano_hinge(depth, false);



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

        %bins();

        module bins() {
            for (i = [0 : 6]) {
                translate([26, 0, 85 + 55 * i])
                parts_bin();
            }
        }
    }

    module left_pillar() {
        pillar(340);

        %bins();

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
