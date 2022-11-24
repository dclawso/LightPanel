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

module slot(w,l,h) {
    hull() {
        cylinder(d=w,h=h);
        translate([l,0,0]) cylinder(d=w,h=h);
    }
}

module LightPanelHalf(length=160,width=80,ridge=2) {
    difference() {
        // main box for the panel
        cube([length+1,width+2,5]);
        
        /// cut out the top of the panel
        translate([ridge+1,ridge+1,3.9]) cube([length+ridge,width-ridge*2,2]);
        
        // make a notch for the LED panel
        translate([1,1,3]) cube([length+1,width,1]);
        
        // space for DIN,DOUT cables.
        translate([30,50,-1]) cube([20,20,8]);

        // make cutout for power wires in the center
        translate([length-15+ridge,50,-1]) cube([15+1,25,5]);
        
        $fn=64;
        translate([156, 10, 0]) {
            translate([1.5,1.5,-1]) cylinder(r=1.5,h=10);

            translate([0,15,0])
            translate([1.5,1.5,-1]) cylinder(r=1.5,h=10);

            translate([0,30,0])
            translate([1.5,1.5,-1]) cylinder(r=1.5,h=10);      
        }
        translate([20,15,-1]) rotate([0,0,135]) slot(5,12,10);
        translate([30,15,-1]) rotate([0,0,135]) slot(5,27,10);
        for (x=[40,50,60,70,80,90]) {
            translate([x,15,-1]) rotate([0,0,135]) slot(5,40,10);
        }
        translate([100,15,-1]) rotate([0,0,135]) slot(5,60,10);
        translate([110,15,-1]) rotate([0,0,135]) slot(5,75,10);
        for (x=[120,130,140]) {
            translate([x,15,-1]) rotate([0,0,135]) slot(5,80,10);
        }
        translate([140,25,-1]) rotate([0,0,135]) slot(5,67,10);
        translate([140,35,-1]) rotate([0,0,135]) slot(5,52,10);
        translate([140,45,-1]) rotate([0,0,135]) slot(5,37,10);
        translate([140,55,-1]) rotate([0,0,135]) slot(5,23,10);
        translate([140,65,-1]) rotate([0,0,135]) slot(5,8,10);
    }
}