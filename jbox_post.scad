// J-BOX POST 
// no fillet
// default is M6 (with a 5 mm pilot)

$fn=50;

// M4x 0.70 = pilot 3.3 mm
module jbox_post (postD = 8, postH = 50, pilotD = 3.3) {

    
    difference () {
        cylinder(r = postD/2, h = postH);
        cylinder(r = (pilotD/2) * 0.90, h = postH);
    }

}