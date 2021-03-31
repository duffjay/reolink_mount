
include <arc.scad>;

// constants taken from echo statements in base_plate.scad
mounting_post_diameter = 9;
mounting_thru_diameter = 4;

mounting_hole_xy_list = [
 [  -6.6066, -6.6066],
 [27.1898, -40.403],
 [ -40.403, 27.1898],
 [    0, 48.7],
 [ 48.7,    0],
];

arc_angles = [146.061, -56.0608];
arc_radius = 105.4/2;

cover_thickness = 4;

// chord box
obtuse_angle = (360 - (arc_angles[0] - arc_angles[1]));
echo ("obtuse angle:", obtuse_angle);
acute_angle = 90 - obtuse_angle/2;
echo ("acute angle:", acute_angle);
adj = cos(acute_angle) * arc_radius;
echo ("adjacent:", adj);
opp = sin(acute_angle) * arc_radius;
square_length = adj * 2;
square_width = opp * 2;
echo ("square width/length:", square_width, square_length);

//

//for (center = (mounting_hole_xy_list))
//    {
//            {
//             // post
//            translate(center)
//            cylinder(h=cover_thickness+1, r=mounting_post_diameter/2);
//            }
//        }
    
difference() {

        {
        // union the 2D + 3D objects
        union () 
            {
            // cover - 2D
            linear_extrude(cover_thickness)  
            union () {
                sector(radius = arc_radius, angles = arc_angles, fn = 50);
                rotate([0,0, -(arc_angles[0] + (90-acute_angle))])
                // fat finger adjustment !! not mathmatical
                square([square_length - 6.6, square_width + 6.4], center=true);
                }
            // post - 3D
            for (center = (mounting_hole_xy_list))           
                {
                translate(center)
                cylinder(h=cover_thickness+1, r=mounting_post_diameter/2);
                }
            } 

        }
        {
        // thru hole
        for (center = (mounting_hole_xy_list))           
            {
            translate (center)
            cylinder(h=cover_thickness+3, r=mounting_thru_diameter/2);
            }
        }
    }        
    
    
    
     
 