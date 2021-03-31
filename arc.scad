
// function - radius is inside radius
//   BUT - I called radius the OUTSIDE


$fn = 50;

module sector(radius, angles, fn = 24) {
    r = radius / cos(180 / fn);
    step = -360 / fn;

    points = concat([[0, 0]],
        [for(a = [angles[0] : step : angles[1] - 360]) 
            [r * cos(a), r * sin(a)]
        ],
        [[r * cos(angles[1]), r * sin(angles[1])]]
    );

    difference() {
        circle(radius, $fn = fn);
        polygon(points);
    }
}

module arc(radius, angles, width = 1, fn = 24) {
    echo ("INSIDE radius =", radius);
    echo ("OUTSIDE radius =", (radius + width));
    echo ("Angle Range =", angles);
    difference() {
        sector(radius + width, angles, fn);
        sector(radius, angles, fn);
    }
} 

// linear_extrude(50)
// arc(105, [146, -56], 2, 50);
