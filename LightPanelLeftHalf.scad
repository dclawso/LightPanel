difference() {
    translate([81,42,2.5])
    cube([162,84,5], center=true);
    
    translate([3,3,3])
    translate([79,39,1.5]) cube([161,78,3], center=true);
    
    translate([2,2,3])
    translate([80,40,.5]) cube([162,80,1], center=true);
    
    translate([12,12,-.5])
    translate([61,31,2.5]) cube([122,62,5], center=true);

    translate([150,49,-.5])
    translate([7.5,12.5,2.5]) cube([15,25,5], center=true);
    
    $fn=16;
    translate([156, 10, 0])
        translate([1.5,1.5,-1]) cylinder(r=1.5,h=10);
    translate([156, 10, 0])
        translate([0,15,0])
        translate([1.5,1.5,-1]) cylinder(r=1.5,h=10);
    translate([156, 10, 0])
        translate([0,30,0])
        translate([1.5,1.5,-1]) cylinder(r=1.5,h=10);      
 }