// extruded wall - for j-box

height = 50;
thickness = 2;
length = 30;

linear_extrude(height)
square([length, thickness], center = true);