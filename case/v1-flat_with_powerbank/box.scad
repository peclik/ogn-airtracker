//------------------------------------------------------------------------------
/*
  LCD5110 project case.
  V1 variant - spacy with powerbank.

  This work by Richard Pecl is licensed under a Creative Commons
  Attribution-ShareAlike 4.0 International License
  <http://creativecommons.org/licenses/by-sa/4.0/>.
*/
//------------------------------------------------------------------------------
/*
TODO:

[*] change width and height?
[*] flip battery pcb upside-down, holes for LEDs (so that LEDs will be visible from front side; contacts could be easily resoldered)
[+] battery fixation protrusion in back cover?
[+] GPS fixation protrusion in back cover?
[*] aligned bottom mounting poles
[*] shorten support for GPS (more space below GPS, moved closely to top wall)
[*] hardening corner at battery usb connectors so it would not delaminate so easily
[-] space around micro-usb battery connector so that it can be fully plugged-in

CHANGELOG:

V1.1:
[+] screw holes in corners and display support
[+] added options for switch positioning
[+] holes and mounting poles for micro-switch buttons
[*] more space for GPS on sides
[*] shortened support for GPS by 5mm (more space below GPS)
[*] longer space for battery in compartment and pcb
[*] display support moved up to top wall
[-] back cover holes flipped upside down

V1.0:
[!] first design

*/


include <dimensions.scad>;

//------------------------------------------------------------------------------

// columns for screwing back cover
module box_screw_column() {
  screw_h = box_i_z;

  difference() {
    cube([box_screw_t, box_screw_t, box_i_z]);
    translate([box_screw_t/2, box_screw_t/2, box_i_z-screw_h/2+rf])
      cylinder(h=screw_h+rf, r=1, center=true);
  }
}

module base_box() {

  box_o_x = box_i_x + 2*wall_t;
  box_o_y = box_i_y + 2*wall_t;
  box_o_z = box_i_z + bottom_t + top_t;

  union() {
    difference() {
      // outer face
      translate([box_corner_r-wall_t, box_corner_r-wall_t, box_corner_r-bottom_t])
      hull()
      {
        //cube([box_o_x-2*box_corner_r, box_o_y-2*box_corner_r, box_o_z-2*box_corner_r]);
        // bottom rounded corners
        sphere(r = box_corner_r);
        translate([box_o_x-2*box_corner_r, 0, 0])
          sphere(r = box_corner_r);
        translate([box_o_x-2*box_corner_r, box_o_y-2*box_corner_r, 0])
          sphere(r = box_corner_r);
        translate([0, box_o_y-2*box_corner_r, 0])
          sphere(r = box_corner_r);
        // top rounded corners
        translate([0, 0, box_o_z-2*box_corner_r])
          sphere(r = box_corner_r);
        translate([box_o_x-2*box_corner_r, 0, box_o_z-2*box_corner_r])
          sphere(r = box_corner_r);
        translate([box_o_x-2*box_corner_r, box_o_y-2*box_corner_r, box_o_z-2*box_corner_r])
          sphere(r = box_corner_r);
        translate([0, box_o_y-2*box_corner_r, box_o_z-2*box_corner_r])
          sphere(r = box_corner_r);
      }

      cube([box_i_x, box_i_y, box_i_z+top_t+rf]);
    }

    // columns for screws mounting back cover
    translate([batt_in_gap+batt_wall_t-rf, -rf, -rf])
      box_screw_column();

    translate([box_i_x-box_screw_t+rf, -rf, -rf])
      box_screw_column();

    translate([-rf, box_i_y-box_screw_t+rf, -rf])
      box_screw_column();

    translate([box_i_x-box_screw_t+rf, box_i_y-box_screw_t+rf, -rf])
      box_screw_column();
  }
}

//------------------------------------------------------------------------------

module gps_support_1(glue_t=0) {
  translate([gps_supp_t + glue_t, -gps_supp_y, 0])
    rotate([0, -90, 0])
      linear_extrude(height = gps_supp_t + glue_t + rf)
        polygon(points = [[0, 0], [0, gps_supp_y], [box_i_z, gps_supp_y], [4, 0]]);
}

module gps_support(glueLeft=1, glueRight=0) {
  color("red")
  union() {
    // gps left support
    gps_support_1(glue_t=gps_supp_glue_t*glueLeft);
    // gps right support
    translate([gps_supp_glue_t*glueLeft + gps_supp_t + gps_supp_gap, 0, 0])
      gps_support_1(glue_t=gps_supp_glue_t*glueRight);
    // gps front cage
    translate([0, -gps_supp_y-gps_supp_t, 0])
      cube([(gps_supp_gap-14)/2+gps_supp_t+gps_supp_glue_t*glueLeft, gps_supp_t, box_i_z/2]);
    translate([(gps_supp_gap+14)/2+gps_supp_t+gps_supp_glue_t*glueLeft, -gps_supp_y-gps_supp_t, 0])
      cube([(gps_supp_gap-14)/2+gps_supp_t+gps_supp_glue_t*glueRight, gps_supp_t, box_i_z/2]);
  }
}

//------------------------------------------------------------------------------

// battery compartment
module battery_comp() {
  minus_y = batt_len + batt_el_len;

  color("lightblue") {

  // battery minus side
  translate([0, minus_y, 0])
    cube(size = [batt_in_gap + batt_wall_t, batt_wall_t, batt_wall_z]);
  translate([batt_in_gap, minus_y - batt_in_gap, 0])
    cube(size = [batt_wall_t, batt_in_gap, batt_wall_z]);

  // minus contact side support
  translate([0.5, minus_y-2+rf, 0])
    cube(size = [1, 2, 12]);
  translate([3, minus_y-2+rf, 0])
    cube(size = [1, 2, 12]);
  translate([3+1+13+1, minus_y-2+rf, 0])
    cube(size = [1, 2, 12]);
  translate([3+1+13-1.5, minus_y-2+rf, 0])
    cube(size = [1, 2, 12]);
  // securing top minus (whole width for better printing without support)
  translate([0, minus_y-2+rf, 14])
    cube(size = [batt_in_gap+rf, 2, 2]);

  // plus side wall
  translate([batt_in_gap, 0, 0])
    cube([batt_wall_t, batt_el_len+batt_in_gap, batt_wall_z]);

  // plus contact
  translate([0, batt_el_len-2.2, 0])
    cube([batt_in_gap-4, 2.2, 14]);

  // plus contact strut
  translate([batt_in_gap-6, batt_el_len-4-rf, 0])
    cube([2, 2, 7.5]);

  // pcb supports
  translate([0, 0, 0])
    cube(size = [2, 2, 7.5]);
  translate([batt_in_gap-2+rf, 0, 0])
    cube(size = [2, 2, 7.5]);
  translate([0, 16, 0])
    cube(size = [2, 2, 7.5]);
  translate([batt_in_gap-1+rf, 16, 0])
    cube(size = [1, 2, 7.5]);

  translate([0, 0, 7.5-rf])
    cube(size = [0.5, 2, 5]);
  translate([0, 16, 7.5-rf])
    cube(size = [0.5, 2, 5]);

  }

  //color("red")
  //translate([3, 21+tolerance-rf, 0])
  //  cube(size = [2, 2, 10]);
}

// holes for power bank usb connectors
module usb_holes() {
  translate([(batt_in_gap-13-tolerance)/2, 0, 10])
    cube([13+tolerance, wall_t+2*rf, 6+tolerance]);

  translate([(batt_in_gap-8-tolerance)/2, 0, 5])
    cube([8+tolerance, wall_t+2*rf, 3+tolerance]);
}

//------------------------------------------------------------------------------

// columns for screwing display (through the case)
module display_screw_column(x=8, y=8) {
  col_h = 3;

  // move at center
  translate([-x/2, -y/2, 0])
    difference() {
      cube([x, y, col_h]);
      translate([x/2, y-3, col_h/2])
        cylinder(h=col_h+2*rf, r=1, center=true);
    }
}

// display support
module display_supp(show_pcb=false) {
  union() {
    //pcb
    if (show_pcb) {
      color("blue")
        cube([displ_pcb_x, displ_pcb_y, 0.1]);
    }

    translate([1.5-displ_supp_t, 6-displ_supp_t, 0])
      difference() {
        cube([displ_cover_x+2*displ_supp_t, displ_cover_y+2*displ_supp_t, 2]);
        translate([displ_supp_t-tolerance/2, displ_supp_t-tolerance/2, -rf])
          cube([displ_cover_x+tolerance, displ_cover_y+tolerance, 2+2*rf]);
      }
    }
    // screw holes blocks
    //translate([displ_hole_x_ofs-8/2, displ_hole_y_ofs-8/2-tolerance/2, 0])
    //  cube(size = [8, 8, 3]);
    translate([displ_hole_x_ofs, displ_hole_y_ofs-tolerance/2, 0])
      display_screw_column();
    translate([displ_pcb_x-displ_hole_x_ofs, displ_hole_y_ofs-tolerance/2, 0])
      display_screw_column();
    translate([displ_hole_x_ofs, displ_pcb_y-displ_hole_y_ofs+tolerance/2, 0])
      display_screw_column(y=6);
    translate([displ_pcb_x-displ_hole_x_ofs, displ_pcb_y-displ_hole_y_ofs+tolerance/2, 0])
      display_screw_column(y=6);
}

// display screen hole
module display_hole() {
  translate([5, displ_lcd_y_ofs, 0])
    cube([displ_lcd_x, displ_lcd_y, bottom_t+2*rf]);
}

//------------------------------------------------------------------------------

// support for 3 microswitches (each 3x3 holes in size)
module uswitch_supp(show_pcb=false) {
  union() {
    if (show_pcb) {
      color("blue")
        translate([0, 0, 0])
          cube([uswitch_supp_x, uswitch_supp_y, 2*rf]);
    }

    translate([uswitch_supp_x/2, pcb_hole_spacing/2+1*pcb_hole_spacing, uswitch_supp_z/2])
      cylinder(h=uswitch_supp_z, r=2.5, center=true);
    translate([uswitch_supp_x/2, pcb_hole_spacing/2+15*pcb_hole_spacing, uswitch_supp_z/2])
      cylinder(h=uswitch_supp_z, r=2.5, center=true);
  }
}

// holes for 3 microswitches (each 3x3 holes in size)
module uswitch_holes() {
  hole_engrave_t = bottom_t-0.5;

  union() {
    hole_h = uswitch_supp_z+hole_engrave_t;
    translate([uswitch_supp_x/2, pcb_hole_spacing/2+1*pcb_hole_spacing, (uswitch_supp_z-hole_engrave_t-rf)/2+rf])
      cylinder(h=hole_h+rf, r=1, center=true);
    translate([uswitch_supp_x/2, pcb_hole_spacing/2+15*pcb_hole_spacing, (uswitch_supp_z-hole_engrave_t-rf)/2+rf])
      cylinder(h=hole_h+rf, r=1, center=true);

    translate([uswitch_supp_x/2, pcb_hole_spacing/2+4*pcb_hole_spacing, (-hole_engrave_t-rf)/2+rf])
      cylinder(h=hole_engrave_t+rf, r=1, center=true);
    translate([uswitch_supp_x/2, pcb_hole_spacing/2+8*pcb_hole_spacing, (-hole_engrave_t-rf)/2+rf])
      cylinder(h=hole_engrave_t+rf, r=1, center=true);
    translate([uswitch_supp_x/2, pcb_hole_spacing/2+12*pcb_hole_spacing, (-hole_engrave_t-rf)/2+rf])
      cylinder(h=hole_engrave_t+rf, r=1, center=true);
  }
}


//------------------------------------------------------------------------------

// back covering or hole
module back_cover(hole) {
  cover_x_c = box_i_x + 2*cover_overlap;
  cover_y_c = box_i_y + 2*cover_overlap;

  if (hole)
    cube([cover_x_c + tolerance/2, cover_y_c + tolerance/2, top_t + tolerance/2]);
  else {
    difference() {
      union() {
        cube([cover_x_c - tolerance/2, cover_y_c - tolerance/2, top_t]);

        // solidifying rafts
        raft_w = 3;
        raft_h = 2+rf;
        translate([batt_in_gap-raft_w-tolerance, cover_overlap+tolerance, top_t-rf])
          cube([raft_w, box_i_y - 2*tolerance, raft_h]);
        translate([2*cover_x_c/3, cover_overlap+tolerance, top_t-rf])
          cube([raft_w, box_i_y - 2*tolerance, raft_h]);
        translate([cover_overlap+tolerance, (cover_y_c-raft_w)/2, top_t-rf])
          cube([box_i_x - 2*tolerance, raft_w, raft_h]);
      }

      hole_r_x_ofs = cover_x_c-cover_overlap-box_screw_t/2;
      hole_t_y_ofs = cover_y_c-cover_overlap-box_screw_t/2;
      hole_lb_ofs = cover_overlap+box_screw_t/2;

      // screw holes (must be flipped upside down)
      translate([hole_r_x_ofs-(cover_overlap+batt_in_gap+batt_wall_t+box_screw_t/2), cover_overlap+box_screw_t/2, top_t/2])
        cylinder(h=top_t+2*rf, r=1.5, center=true);

      translate([hole_lb_ofs, hole_lb_ofs, top_t/2])
        cylinder(h=top_t+2*rf, r=1.5, center=true);
      translate([hole_lb_ofs, hole_t_y_ofs, top_t/2])
        cylinder(h=top_t+2*rf, r=1.5, center=true);
      translate([hole_r_x_ofs, hole_t_y_ofs, top_t/2])
        cylinder(h=top_t+2*rf, r=1.5, center=true);
    }
  }
}

//------------------------------------------------------------------------------

// variant 3: landscape / w = 110mm, h = 80mm
module airtracker_box3() {
  displ_x = box_i_x-displ_pcb_y-1.2+rf;
  displ_y = gps_supp_x + displ_pcb_x + 1;

  uswitch_x = displ_x - (uswitch_supp_y/2-(displ_lcd_y_ofs+displ_lcd_y/2));
  uswitch_y = displ_y + uswitch_supp_x + tolerance;

  difference() {
    union() {
      base_box();

      translate([-rf, -rf, -rf])
        battery_comp();

      translate([box_i_x-box_screw_t+rf, gps_supp_x-rf, -rf])
        rotate([0, 0, 270])
          gps_support(glueLeft=0, glueRight=1);

      // connect battery left wall with outter wall
      translate([box_i_x-box_screw_t-rf, gps_supp_x-gps_supp_t-rf, -rf])
        cube([box_screw_t+2*rf, gps_supp_t, 2*box_i_z/3]);

      translate([displ_x, displ_y, -rf])
        rotate([0, 0, 270])
          display_supp(show_pcb=false);

      translate([uswitch_x, uswitch_y, -rf])
        rotate([0, 0, 270])
          uswitch_supp(show_pcb=false);
    }
    translate([0, -wall_t-rf, 0])
      usb_holes();

    translate([displ_x, displ_y, -bottom_t-rf])
      rotate([0, 0, 270])
        display_hole();

    translate([uswitch_x, uswitch_y, 0])
      rotate([0, 0, 270])
        uswitch_holes();

    translate([-cover_overlap-tolerance/4, -cover_overlap-tolerance/4, box_i_z])
      back_cover(hole=true);

    // hole for switch on top
    mount_hole1_y_ofs = box_i_y-box_screw_t-2*6;
    mount_hole2_y_ofs = mount_hole1_y_ofs-3*6;
    mount_hole_t = wall_t-0.3;
    switch_hole_r = 2.5+tolerance/2;

    // switch option 1
    translate([box_i_x-rf, mount_hole2_y_ofs, 2*box_i_z/3])
      rotate([0, 90, 0])
        cylinder(h=mount_hole_t, r=switch_hole_r, center=true);

    // switch option 2
    translate([box_i_x-rf, gps_supp_x+15, displ_supp_t+2*switch_hole_r+2])
      rotate([0, 90, 0])
        cylinder(h=mount_hole_t, r=switch_hole_r, center=true);

    // switch option 3
    translate([box_i_x-rf, gps_supp_x+6, 2*box_i_z/3])
      rotate([0, 90, 0])
        cylinder(h=mount_hole_t, r=switch_hole_r, center=true);

    // switch option 4
    translate([box_i_x-rf, mount_hole1_y_ofs, 2*switch_hole_r])
      rotate([0, 90, 0])
        cylinder(h=mount_hole_t, r=switch_hole_r, center=true);

    // hole for antenna on top
    translate([box_i_x-rf, mount_hole1_y_ofs, 2*box_i_z/3])
      rotate([0, 90, 0])
        cylinder(h=mount_hole_t, r=3+tolerance/2, center=true);
  }
}


airtracker_box3();
//back_cover();
