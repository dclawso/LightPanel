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

module LightPanelHalf(length=160,width=80,ridge=2) {
    difference() {
        // main box for the panel
        translate([length/2+ridge-1,width/2+2,2.5])
        cube([length+ridge,width+ridge*2,5], center=true);
        
        /// cut out the top of the panel
        translate([ridge+1,ridge+1,3])
        translate([length/2-(ridge-1)/2,width/2-ridge/2,1.5]) cube([length+ridge-1,width-ridge,3], center=true);
        
        // make a notch for the LED panel
        translate([ridge,ridge,3])
        translate([length/2,width/2,.5]) cube([length+2,width,1], center=true);
        
        // make a hole in the back, saves filament, print time, and provides
        // space for DIN,DOUT cables.
        translate([12,12,-.5])
        translate([(length-38)/2,(width-18)/2,2.5]) cube([length-38,width-18,5], center=true);

        // make cutout for power wires in the center
        translate([length-12,49,-.5])
        translate([7.5,12.5,2.5]) cube([15,25,5], center=true);
        
        $fn=16;
        translate([156, 10, 0]) {
            translate([1.5,1.5,-1]) cylinder(r=1.5,h=10);

            translate([0,15,0])
            translate([1.5,1.5,-1]) cylinder(r=1.5,h=10);

            translate([0,30,0])
            translate([1.5,1.5,-1]) cylinder(r=1.5,h=10);      
        }
    }
}