// R E O L I N K
// POST (or standoff)
// default is for an M3 thread

$fn=50;

module post (postD = 5, postH = 8, pilotD = 3) {
    f = 2; // filllet
    
    cylinder(r = postD/2, h = postH);


    rotate_extrude(convexity = 10) {
        translate([(postD/2), 0, 0]) {
            intersection() {
                difference() {
                    square(f * 2, center = true);
                    translate([f, f, 0]) circle(f);
                }
                square(f * 2);
            }
        }
    }
}

