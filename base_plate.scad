include <post.scad>;
include <support.scad>;
include <arc.scad>;
include <jbox_post.scad>;

// cd OpenSCAD
// tar -czvf reolink.tar.gz JMD_ReoLink/

base_plate_thick = 2;
base_plate_radius = 105.4/2;
total_thick = 5;
surface_mount_thick = 5;
camera_hole_dist = 74.0;

// M4 x 0.70
// defaults
postD = 8;                              // post outside diameter
postH = total_thick - base_plate_thick; // post height
postPD = 3.3;                             // post - pilot diameter

pass_thru_radius = 10;
pass_thru_offset = 4;

jbox_depth = 50;
jbox_thick = 2;

$fn = 50;

difference () {
    union() {
        // base plate
        cylinder(h=base_plate_thick, r = base_plate_radius);
        // base plate rim
        difference() {
            {
            translate([0,0,base_plate_thick])
            cylinder(h=(total_thick - base_plate_thick), r = base_plate_radius);
            }
            {
            translate([0,0, base_plate_thick])
            cylinder(h=(total_thick - base_plate_thick), r = (base_plate_radius - surface_mount_thick));
            }
        }
        // posts
        for (post_coord = [
                [0, (camera_hole_dist / 2), base_plate_thick],
                [(camera_hole_dist / 2), 0, base_plate_thick],
                [0, -(camera_hole_dist / 2), base_plate_thick],
                [-(camera_hole_dist / 2), 0, base_plate_thick]
                ])
            {
            translate(post_coord)
            post (postD, postH, postPD);
            }
        // support rib
        for (rotate = [0,90,180,270])
            {
            rotate ([0,0,rotate])
            translate([0,0,base_plate_thick])
            support_rib(3,3,base_plate_radius);
            }   
        // pass thru hole
        translate([pass_thru_offset, pass_thru_offset,0])
        cylinder(h=total_thick, r = (pass_thru_radius + surface_mount_thick));
        
            
        // j-box walls
        // arc (m2_projected_angle, m3_projected_angle)
        // !! radius on arc is the INSIDE radius
        // !! something wierd can't get (base_plate_radius - jbox_thick) to work
        arc_radius = base_plate_radius - 4;
        linear_extrude(jbox_depth)
        arc(arc_radius, [m2_projected_angle, m3_projected_angle], jbox_thick, 50);    
            
        // j-box screw holes
        // - mounting hole 1 - near center
        m1_centerline_radius = pass_thru_radius + surface_mount_thick;
        m1_x = sqrt(pow(m1_centerline_radius,2)/2) - pass_thru_offset;
        m1_y = m1_x;
        echo ("j-box - mount #1, offset x/y = ", m1_x);
        translate([- m1_x, - m1_x,0])
        cylinder(r=postD/2, h = jbox_depth);
            
        // - mounting hole 2 - 45 deg from m1
        m2_opposite = sqrt((pow(m1_x,2) * 2));
        echo("j-box - mount #2 - opposite = ", m2_opposite); 
        m2_hypotenuse = base_plate_radius - postD/2;
        echo("j-box - mount #2 - hypotenuse = ", m2_hypotenuse);
        m2_adjacent = sqrt(pow(m2_hypotenuse,2) - pow(m2_opposite,2));
        echo("j-box - mount #2 - adjacent = ", m2_adjacent);    
        m2_angle = asin(m2_opposite/m2_hypotenuse);
        echo("j-box - mount #2 - angle = ", m2_angle);
        m2_projected_angle = m2_angle + 90 + 45;
        echo("j-box - mount #2 - projected angle = ", m2_projected_angle);
        m2_x = sin(m2_projected_angle) * m2_hypotenuse;
        m2_y = cos(m2_projected_angle) * m2_hypotenuse;
        echo("j-box - mount #2 - coordinates = ", m2_x, m2_y);
        translate([m2_x, m2_y, 0])
        cylinder(r=postD/2, h = jbox_depth);
        // mirrored post m3
        // m2 hypot = m3 hypot
        m3_projected_angle = -45 - m2_angle;
        echo("j-box - mount #3 - projected angle = ", m3_projected_angle);
        m3_x = sin(m3_projected_angle) * m2_hypotenuse;
        m3_y = cos(m3_projected_angle) * m2_hypotenuse;
        echo("j-box - mount #3 - coordinates = ", m3_x, m3_y);
        translate([m3_x, m3_y, 0])
        cylinder(r=postD/2, h = jbox_depth);
        // post #4
        m4_x = 0;
        m4_y = m2_hypotenuse;
        echo("j-box - mount #4 - coordinates = ", m4_x, m4_y);
        translate([m4_x, m4_y, 0])
        cylinder(r=postD/2, h = jbox_depth);
        // post #5
        m5_x = m2_hypotenuse;
        m5_y = 0;
        echo("j-box - mount #5 - coordinates = ", m5_x, m5_y);
        translate([m5_x, m5_y, 0])
        cylinder(r=postD/2, h = jbox_depth);
        
        // flat wall - 
        wall_length = sqrt(pow(m3_x - m2_x,2) + pow(m3_y - m2_y,2));
        echo("jbox flat wall length = ", wall_length);
        translate([-m1_x, -m1_y, 0])
        rotate([0,0,-45])
        linear_extrude(jbox_depth)
        square([wall_length, jbox_thick], center = true); 
    }
    {
    // drill holes here
    for (center = [
                    [0, (camera_hole_dist / 2), 0],
                    [0, -(camera_hole_dist / 2), 0],
                    [(camera_hole_dist / 2), 0, 0],
                    [-(camera_hole_dist / 2), 0, 0]
                  ])
        {
        translate(center)
        cylinder(h=total_thick, r = postPD/2);
        }
    // j-box mounting holes
    // -- I give up figuring how to pass them
    //    get them from echo output
        
    //  sloppy!  -1 x m1 coordinates
    for (center = [
                    [-6.6066, -6.6066, 0],
                    [27.1898, -40.403, 0],
                    [ -40.403, 27.1898, 0],
                    [0, 48.7, 0],
                    [48.7, 0,0]
                  ])
        {
        translate(center)
        cylinder(h=jbox_depth, r = postPD/2);
        }
    // pass thru hole
    translate([pass_thru_offset, pass_thru_offset,0])
    cylinder(h = total_thick, r = pass_thru_radius);

    }
}