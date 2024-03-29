// MIT License
//
// Copyright (c) 2022 David Lawson
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

// make a cutout for the mini USB connector
//     this module makes the positive element to use in a difference to cut it out.
module mini_usb_cutout() {
    hull() {
        translate([-4.5,-3,0]) cylinder(r=1,h=10,center=true);
        translate([-4.5,3,0]) cylinder(r=1,h=10,center=true);
        translate([4.5,-3,0]) cylinder(r=1,h=10,center=true);
        translate([4.5,3,0]) cylinder(r=1,h=10,center=true);
    }
}

// make a screw post for the screw diameter indicated. The height is the height of the hole
// in the center.
module screw_post(diameter, height,location=[0,0,0])
{
    $fn=64;
    r = diameter/2;
    translate(location)
    translate([0,0,height/2])
    difference() {
        cylinder(height,r+2.0,r+2.0,center = true);
        translate([0,0,1])
            cylinder(height-1, r, r, center = true);
        
    }
}

// make a cube with a corner at the origin. easier for placing exactly
module ocube(length, width, height) {
    translate([length/2, width/2, height/2])
        cube([length, width, height], center=true);
}

// make a positive which can be used to cut a slot with rounded ends
module slot(loc1, loc2, dia, height) {
    $fn=64;
    hull() {
        translate(loc1) cylinder(r=dia/2, h=height);
        translate(loc2) cylinder(r=dia/2, h=height);
    }
}

// make the very specific control box.
//    rather than being subtractive, the main box is built as a union of floor, walls, and screw posts.
module control_box(length, width, height) {
    $fn=64;
    translate([0,0,0]) {
        union() {
            // base
            translate([1,1,0]) 
                    minkowski() {
                        translate([length/2+.3, width/2+.3, .5])
                        cube([length, width, 1], center=true);
                        cylinder(r=3, h=1);
                    }

            // walls
            translate([1,-1.85,2]) 
                    ocube(length+1,2,height);
            translate([1,width+2.45,2]) 
                    ocube(length+1,2,height);
            translate([-1.85,1,2]) 
                    ocube(2,width+1,height);
            translate([length+2.45,1,2]) 
                    ocube(2,width+1,height);

            // corner screw posts
            $fn=16;
            screw_post(2.5, height, [1.25, 1.25, 2]);
            screw_post(2.5, height, [1.25, width+1.25, 2]);
            screw_post(2.5, height, [length+1.25, 1.25, 2]);
            screw_post(2.5, height, [length+1.25, width+1.25, 2]);
        }
    }
}

module mounting_holes(length,hole_side_offset=10, hole_end_offset=20) {
    $fn=16;
    // make holes to match the screw pattern of the ligth panel halves
    translate([length-hole_end_offset,hole_side_offset,-2]) translate([0,0,0]) cylinder(r=1.5,h=10);
    translate([length-hole_end_offset,hole_side_offset,-2]) translate([0,15,0]) cylinder(r=1.5,h=10);
    translate([length-hole_end_offset,hole_side_offset,-2]) translate([0,30,0]) cylinder(r=1.5,h=10);
    translate([length-hole_end_offset,hole_side_offset,-2]) translate([10,0,0]) cylinder(r=1.5,h=10);
    translate([length-hole_end_offset,hole_side_offset,-2]) translate([10,15,0]) cylinder(r=1.5,h=10);
    translate([length-hole_end_offset,hole_side_offset,-2]) translate([10,30,0]) cylinder(r=1.5,h=10);

    // add pass through for power cables from LED panel
    translate([length-hole_end_offset-15,35,-2]) translate([10,7,0]) cube([20,8,10]);
}


