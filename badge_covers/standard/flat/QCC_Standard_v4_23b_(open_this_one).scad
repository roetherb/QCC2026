// QCC 2026 Standard badge cover | Scarab Sentinel v4.23b
// Open in OpenSCAD. All coordinates are millimetres in the artwork-down print frame.
use <Artwork.scad>;
use <Spring_Arms.scad>;
part = "assembly"; // [assembly,body,artwork,outlines,blank]
inlay_depth = 0.24;
module pocket_footprint(){ union(){ artwork_2d();outlines_2d(); } }
module body(){
    difference(){
        mechanical_blank();
        translate([0,0,-0.02])
            linear_extrude(height=inlay_depth+0.02,convexity=32) pocket_footprint();
    }
}
if(part=="blank" || (part=="assembly" && !$preview)) mechanical_blank();
if(part=="body" || (part=="assembly" && $preview)) color("#2463BA") body();
if(part=="artwork" || (part=="assembly" && $preview)) color("#FFFFFF") linear_extrude(height=inlay_depth,convexity=32) artwork_2d();
if(part=="outlines" || (part=="assembly" && $preview)) color("#171717") linear_extrude(height=inlay_depth,convexity=32) outlines_2d();
