difference() {
    translate([41,42,2.5])
    cube([82,84,5], center=true);
    
    translate([3,3,3])
    translate([79,39,1.5]) cube([158,78,3], center=true);
    
    translate([2,2,3])
    translate([80,40,.5]) cube([160,80,1], center=true);
    
    $fn=16;
    translate([76, 27, 0])
        translate([1.5,1.5,-1]) cylinder(r=1.5,h=10);
    translate([76, 27, 0])
        translate([0,15,0])
        translate([1.5,1.5,-1]) cylinder(r=1.5,h=10);      
    translate([76, 27, 0])
        translate([0,30,0])
        translate([1.5,1.5,-1]) cylinder(r=1.5,h=10);      
 }