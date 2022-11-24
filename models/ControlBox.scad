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

use <controlboxparts.scad>

union() {
    difference() {
        control_box(160,50, 32);
        mounting_holes(160,5,20);
        // make a cutouts to save filament and print time
        translate([65,5,-2]) translate([25,21,5]) cube([50,42,10],center=true);
        translate([12.5,5,-2]) translate([12.5,21,5]) cube([25,42,10],center=true);

        // add hole for power connector
        translate([145,0,10]) rotate([90,0,0]) cylinder(r=2.9,h=10);
        // add hole for mini usb connector
        translate([-2,22.5,25]) rotate([90,0,90]) mini_usb_cutout();
        
        // screw holes on end for future mounting possibilies
        translate([160,27.5,17.5]) rotate([90,0,90]) union() {
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


    // add screw posts for nano mount
    translate([25,22.5,2]) {
        union() {
            screw_post(2.5, 8, [-18.5,0,0]);
            screw_post(2.5, 8, [18.5,0,0]);
        }
    }
    
    // add screw posts for power supply mount
    translate([90,33,2]) {
        union() {
            screw_post(3, 8, [-32.5,0,0]);
            screw_post(3, 8, [32.5,0,0]);
        }
    }
}

