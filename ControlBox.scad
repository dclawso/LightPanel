module mini_usb_cutout() {
    hull() {
        translate([-4.5,-3,0]) cylinder(r=1,h=10,center=true);
        translate([-4.5,3,0]) cylinder(r=1,h=10,center=true);
        translate([4.5,-3,0]) cylinder(r=1,h=10,center=true);
        translate([4.5,3,0]) cylinder(r=1,h=10,center=true);
    }
}

module screw_post(diameter, height,location=[0,0,0])
{
    r = diameter/2;
    translate(location)
    translate([0,0,height/2])
    difference() {
        cylinder(height,r+2.0,r+2.0,center = true);
        translate([0,0,1])
            cylinder(height-1, r, r, center = true);
        
    }
}

module ocube(length, width, height) {
    translate([length/2, width/2, height/2])
        cube([length, width, height], center=true);
}

module slot(loc1, loc2, dia, height) {
    hull() {
        translate(loc1) cylinder(r=dia/2, h=height);
        translate(loc2) cylinder(r=dia/2, h=height);
    }
}

module control_box(length, width, height, hole_side_offset=10, hole_end_offset=20) {
    translate([0,0,0]) {
        difference() {
            union() {
                translate([1,1,0]) 
                        minkowski() {
                            translate([length/2+.3, width/2+.3, .5])
                            cube([length, width, 1], center=true);
                            cylinder(r=3, h=1);
                        }

                translate([1,-1.85,2]) 
                        ocube(length+1,2,height);
                translate([1,width+2.45,2]) 
                        ocube(length+1,2,height);
                translate([-1.85,1,2]) 
                        ocube(2,width+1,height);
                translate([length+2.45,1,2]) 
                        ocube(2,width+1,height);
                $fn=16;
                screw_post(2.5, height, [1.25, 1.25, 2]);
                screw_post(2.5, height, [1.25, width+1.25, 2]);
                screw_post(2.5, height, [length+1.25, 1.25, 2]);
                screw_post(2.5, height, [length+1.25, width+1.25, 2]);
            }

            $fn=16;
            translate([length-hole_end_offset,hole_side_offset,-2]) translate([0,0,0]) cylinder(r=1.5,h=10);
            translate([length-hole_end_offset,hole_side_offset,-2]) translate([0,15,0]) cylinder(r=1.5,h=10);
            translate([length-hole_end_offset,hole_side_offset,-2]) translate([0,30,0]) cylinder(r=1.5,h=10);
            translate([length-hole_end_offset,hole_side_offset,-2]) translate([10,0,0]) cylinder(r=1.5,h=10);
            translate([length-hole_end_offset,hole_side_offset,-2]) translate([10,15,0]) cylinder(r=1.5,h=10);
            translate([length-hole_end_offset,hole_side_offset,-2]) translate([10,30,0]) cylinder(r=1.5,h=10);
            translate([length-hole_end_offset-15,35,-2]) translate([10,7,0]) cube([20,8,10]);
        }
    }
}

union() {
    difference() {
        control_box(150,50, 32, 5, 95);
        translate([85,5,-2]) translate([25,21,5]) cube([50,42,10],center=true);
        translate([12.5,5,-2]) translate([12.5,21,5]) cube([25,42,10],center=true);
        //translate([75,7,-2]) slot([0,0,0], [0,20,0],5,10);
        translate([145,0,10]) rotate([90,0,0]) cylinder(r=2.9,h=10);
        translate([-2,22.5,25]) rotate([90,0,90]) mini_usb_cutout();
        
        translate([150,22.5,15]) rotate([90,0,90]) union() {
            $fn=16;
            translate([-7,-7,0]) cylinder(r=2,h=10,center=true);
            translate([-7,7,0]) cylinder(r=2,h=10,center=true);
            translate([7,-7,0]) cylinder(r=2,h=10,center=true);
            translate([7,7,0]) cylinder(r=2,h=10,center=true);
        }
        
        // side vents
        for ( y = [-4, 50] ) {
            for ( i = [ 10 : 10 : 130]) {
                translate([i,y,8]) rotate([-90,-90,0]) slot([0,0,0],[20,0,0], 3, 10);
            }
        }
    }


    translate([25,22.5,2]) {
        union() {
            screw_post(2.5, 8, [-18.5,0,0]);
            screw_post(2.5, 8, [18.5,0,0]);
        }
    }
    
    translate([110,33,2]) {
        union() {
            screw_post(3, 8, [-32.5,0,0]);
            screw_post(3, 8, [32.5,0,0]);
        }
    }
}

