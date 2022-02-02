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

translate([162,0,0])
mirror(v=[1,0,0])
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