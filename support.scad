// R E O L I N K
// support rib

module support_rib (
ribW = 3,
ribH = 3,
ribL = 20) {

    f = 2;  // fillet radius
    $fn = 50;
    rotate([90,0,0])
    linear_extrude(height = ribL, convexity = 10) {
        union () {
            
            translate([-ribW/2,0,0])
            square([ribW,ribH], center = false);
            // left radius
            difference() {
                translate([-(f/2 + ribW/2),f/2,0])
                square([f,f], center = true);
                translate([-(f + ribW/2), f, 0]) 
                circle(f);
                }
            // right radius
            difference() {
                translate([(f/2 + ribW/2),f/2,0])
                square([f,f], center = true);
                translate([(f + ribW/2), f, 0]) 
                circle(f);
                }
        }
    }
}