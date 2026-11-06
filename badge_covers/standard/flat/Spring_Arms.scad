// The local axes follow each sloping edge. u points outward from the PCB and s runs from the former root to the latch.
use <Branch_v423.scad>;
edge_frames = [
    [[0.7716454795839922,0.6360528703162895],[-0.6360528703162895,0.7716454795839922],[70.92740259540851,18.37687924580502]],
    [[0.7913123473784152,0.6114121105166813],[-0.6114121105166813,0.7913123473784152],[48.01035303959223,46.00863672617494]],
    [[-0.7716455532488753,0.6360527809476484],[0.6360527809476484,0.7716455532488753],[-70.92739762779917,18.376874399796822]],
    [[-0.7913125891141128,0.6114117976532014],[0.6114117976532014,0.7913125891141128],[-48.010342058634286,46.0086357794829]]
];
old_length=24.0;
arm_length=12.0;
root_length=3.0;
relocation=old_length-arm_length;
module at_edge(f){multmatrix([[f[0][0],f[1][0],0,f[2][0]],[f[0][1],f[1][1],0,f[2][1]],[0,0,1,0],[0,0,0,1]])children();}
module root_profile(){
 // Root geometry, bearing pad and blend are copied from this exact four-clip revision.
 intersection(){
  baseline();
  for(f=edge_frames)at_edge(f) translate([-0.88,-0.001,1.2]) cube([3.64,4.21,5.06]);
 }
}
// Round the closed end of the flex slot in plan. At the middle of the opening
// the root ends exactly at s=15. Each side blends back into the adjacent rail.
module slot_end(inner,outer,top){
    r=(outer-inner)/2;
    linear_extrude(height=top)
        difference(){
            translate([inner-0.12,relocation+root_length-0.06])
                square([outer-inner+0.24,r+0.06]);
            translate([(inner+outer)/2,relocation+root_length+r])
                circle(r=r,$fn=64);
        }
}
module fixed_land(){
 // Close the first-layer cutout. The existing printed lip sets the outside contour.
 translate([-2.2,-1.2,0])cube([3.05,relocation+root_length+1.2,1.20]);
 slot_end(-1.40,0.00,1.20);
 slot_end(-1.40,0.30,5.00);
 // The fixed upper wall joins both the inboard rail and the earlier arm footprint.
 // The start is chamfered to the same height as the surrounding rail.
 multmatrix([[0,0,1,-2.05],[1,0,0,0],[0,1,0,0],[0,0,0,1]])
  linear_extrude(height=4.75)polygon([[-.96,1.15],[relocation+root_length,1.15],
    [relocation+root_length,5.0],[1.8,5.0],[-.96,2.24]]);
}
module mechanical_blank(){
 union(){
  difference(){
   baseline();
   for(f=edge_frames)at_edge(f)translate([-.85,-.01,1.2])cube([3.6,relocation+.01,5.15]);
  }
  for(f=edge_frames){
   at_edge(f)fixed_land();
   translate([f[1][0]*relocation,f[1][1]*relocation,0])
    intersection(){root_profile();at_edge(f)translate([-1,-.01,1.19])cube([4,4.23,5.15]);}
  }
 }
}
mechanical_blank();
