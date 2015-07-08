//------------------------------------------------------------------------------
/*
  LCD5110 project case.
  V2 variant - tiny with powerbank or completely without battery.

  This work by Richard Pecl is licensed under a Creative Commons
  Attribution-ShareAlike 4.0 International License
  <http://creativecommons.org/licenses/by-sa/4.0/>.
*/
//------------------------------------------------------------------------------
/*
TODO:

[*] flip battery pcb upside-down, holes for LEDs (so that LEDs will be visible from front side; contacts could be easily resoldered)
[+] battery fixation protrusion in back cover?
[+] GPS fixation protrusion in back cover?

CHANGELOG:

V2.0 (based on V1.1):
[+] added box variant without battery
[+] engraved GPS text
[*] shortened both width (as long as battery comp.) and height (displ+battery)
[-] space around micro-usb battery connector so that it can be fully plugged-in
[-] hardened corner at battery usb connectors so it would not delaminate so easily

*/


include <dimensions.scad>;

//------------------------------------------------------------------------------

// columns for screwing back cover
module box_screw_column(h=box_i_z) {
  screw_h = h;
  hole_r = 0.9;

  difference() {
    cube([box_screw_t, box_screw_t, h]);
    translate([box_screw_t/2, box_screw_t/2, h-screw_h/2+rf])
      cylinder(h=screw_h+rf, r=hole_r, center=true);
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

    if (with_battery) {
      // columns for screws mounting back cover
      translate([batt_in_gap+batt_wall_t-rf, -rf, -rf])
        box_screw_column();

      translate([batt_in_gap+batt_wall_t-rf, box_i_y-box_screw_t+rf, -rf])
        box_screw_column();

      translate([box_i_x-box_screw_t+rf, box_i_y-box_screw_t+rf, -rf])
        box_screw_column();
    }
    else {
      // columns for screws mounting back cover
      translate([-rf, -rf, -rf])
        box_screw_column();

      translate([box_i_x-box_screw_t+rf, box_i_y-box_screw_t+rf, -rf])
        box_screw_column();

      // hardening column
      translate([-rf, box_i_y-1+rf, -rf])
        cube([1, 1, box_i_z+top_t+rf]);

      // cpu pcb mounting columns
      translate([-rf, gps_supp_y-box_screw_t+1+rf, -rf])
        box_screw_column(h=cpu_pcb_z_ofs-4);

      translate([box_i_x-gps_supp_x-box_screw_t+rf, gps_supp_y-box_screw_t+1+rf, -rf])
        box_screw_column(h=cpu_pcb_z_ofs-4);
    }
  }
}

//------------------------------------------------------------------------------

module gps_support_1(glue_t=0) {
  translate([gps_supp_t + glue_t, -gps_supp_x, 0])
    rotate([0, -90, 0])
      linear_extrude(height = gps_supp_t + glue_t + rf)
        polygon(points = [[0, 0], [0, gps_supp_x], [gps_supp_z, gps_supp_x], [3, 0]]);
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
    translate([0, -gps_supp_x-gps_supp_t, 0])
      cube([(gps_supp_gap-14)/2+gps_supp_t+gps_supp_glue_t*glueLeft, gps_supp_t, 9]);
    translate([(gps_supp_gap+14)/2+gps_supp_t+gps_supp_glue_t*glueLeft, -gps_supp_x-gps_supp_t, 0])
      cube([(gps_supp_gap-14)/2+gps_supp_t+gps_supp_glue_t*glueRight, gps_supp_t, 9]);
  }
}

module gps_text() {
  t_engrave = 0.3;

  translate([0, 2.5, 0]) {

  translate([gps_supp_x/2, -gps_supp_y/2, -bottom_t])
    difference() {
      cube([gps_supp_x-15, gps_supp_y-15, t_engrave+rf], center=true);
      cube([gps_supp_x-15.5, gps_supp_y-15.5, t_engrave+rf], center=true);
    }

  translate([gps_supp_x/2, -gps_supp_t-gps_supp_gap/2+2.5, -bottom_t+t_engrave])
    rotate([0, 180, 0])
      linear_extrude(height=t_engrave)
        text("\u21c8", size=3, font="DejaVu Sans", halign="center", valign="center");
  translate([gps_supp_x/2, -gps_supp_t-gps_supp_gap/2-2.5, -bottom_t+t_engrave])
    rotate([0, 180, 0])
      linear_extrude(height=t_engrave)
        text("GPS", size=3, font="DejaVu Sans", halign="center", valign="center");
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

  translate([0, batt_el_len-2.2, 0])
    cube(size = [1.5, 2.2, box_i_z]);

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

  //translate([0, 0, 7.5-rf])
  //  cube(size = [0.5, 2, box_i_z-7.5]);
  //translate([0, 16, 7.5-rf])
  //  cube(size = [0.5, 2, box_i_z-7.5]);

  translate([0, 0, 0])
    cube(size = [0.5, batt_el_len, box_i_z]);
  }

  //color("red")
  //translate([3, 21+tolerance-rf, 0])
  //  cube(size = [2, 2, 10]);
}

// holes for power bank usb connectors
module battery_usb_holes() {
  translate([(batt_in_gap-13-tolerance)/2, 0, 10])
    cube([13+tolerance, wall_t+2*rf, 6+tolerance]);

  translate([(batt_in_gap-8-tolerance)/2, 0, 5])
    cube([8+tolerance, wall_t+2*rf, 3+tolerance]);

  // micro outter engrave
  u_engrave = wall_t-1;
  translate([(batt_in_gap-11-tolerance)/2, 0, 5-(7-5+tolerance)/2])
    cube([11+tolerance, u_engrave+rf, 7+tolerance]);
}

//------------------------------------------------------------------------------

// holes for CPU board usb connectors
module cpu_usb_holes() {
  cpu_pcb_x = 23;
  cpu_pcb_z = 1.5;
  cpu_pcb_engrave = 1;
  cpu_usb_x = 8;
  cpu_usb_z = 3;
  union() {
    cube([cpu_pcb_x+tolerance, cpu_pcb_engrave+rf, cpu_pcb_z]);
    translate([(cpu_pcb_x-cpu_usb_x)/2, 0, 0.5])
      cube([cpu_usb_x+tolerance, wall_t+rf, cpu_usb_z]);
  }
}

//------------------------------------------------------------------------------

// columns for screwing display (through the case)
module display_screw_column(x=8, y=8) {
  col_h = 3;
  hole_r = 0.9;

  // move at center
  translate([-x/2, -y/2, 0])
    difference() {
      cube([x, y, col_h]);
      translate([x/2, y-3, col_h/2])
        cylinder(h=col_h+2*rf, r=hole_r, center=true);
    }
}

// display support
module display_supp(show_pcb=false) {
  union() {
    //pcb
    if (show_pcb) {
      color("blue")
        cube([displ_pcb_y, displ_pcb_x, 0.1]);
    }

    translate([1.5-displ_supp_t, 6-displ_supp_t, 0])
      difference() {
        cube([displ_cover_y+2*displ_supp_t, displ_cover_x+2*displ_supp_t, 2]);
        translate([displ_supp_t-tolerance/2, displ_supp_t-tolerance/2, -rf])
          cube([displ_cover_y+tolerance, displ_cover_x+tolerance, 2+2*rf]);
      }
    }
    // screw holes blocks
    //translate([displ_hole_y_ofs-8/2, displ_hole_x_ofs-8/2-tolerance/2, 0])
    //  cube(size = [8, 8, 3]);
    translate([displ_hole_y_ofs, displ_hole_x_ofs-tolerance/2, 0])
      display_screw_column();
    translate([displ_pcb_y-displ_hole_y_ofs, displ_hole_x_ofs-tolerance/2, 0])
      display_screw_column();
    translate([displ_hole_y_ofs, displ_pcb_x-displ_hole_x_ofs+tolerance/2, 0])
      display_screw_column(y=6);
    translate([displ_pcb_y-displ_hole_y_ofs, displ_pcb_x-displ_hole_x_ofs+tolerance/2, 0])
      display_screw_column(y=6);
}

// display screen hole
module display_hole() {
  translate([5, displ_lcd_y_ofs, 0])
    cube([displ_lcd_y, displ_lcd_x, bottom_t+2*rf]);
}

//------------------------------------------------------------------------------

// support for 3 microswitches (each 3x3 holes in size)
module uswitch_supp(show_pcb=false) {
  union() {
    if (show_pcb) {
      color("blue")
        translate([0, 0, 0])
          cube([uswitch_supp_y, uswitch_supp_x, 2*rf]);
    }

    translate([uswitch_supp_y/2, pcb_hole_spacing/2+1*pcb_hole_spacing, uswitch_supp_z/2])
      cylinder(h=uswitch_supp_z, r=2.5, center=true);
    translate([uswitch_supp_y/2, pcb_hole_spacing/2+15*pcb_hole_spacing, uswitch_supp_z/2])
      cylinder(h=uswitch_supp_z, r=2.5, center=true);
  }
}

// holes for 3 microswitches (each 3x3 holes in size)
module uswitch_holes() {
  hole_engrave_t = bottom_t-0.5;
  hole_r = 0.9;

  union() {
    hole_h = uswitch_supp_z+hole_engrave_t;
    translate([uswitch_supp_y/2, pcb_hole_spacing/2+1*pcb_hole_spacing, (uswitch_supp_z-hole_engrave_t-rf)/2+rf])
      cylinder(h=hole_h+rf, r=hole_r, center=true);
    translate([uswitch_supp_y/2, pcb_hole_spacing/2+15*pcb_hole_spacing, (uswitch_supp_z-hole_engrave_t-rf)/2+rf])
      cylinder(h=hole_h+rf, r=hole_r, center=true);

    //sw_hole_h = hole_engrave_t+rf;
    sw_hole_h = bottom_t + 2*rf;
    translate([uswitch_supp_y/2, pcb_hole_spacing/2+4*pcb_hole_spacing, -sw_hole_h/2+rf])
      cylinder(h=sw_hole_h, r=hole_r, center=true);
    translate([uswitch_supp_y/2, pcb_hole_spacing/2+8*pcb_hole_spacing, -sw_hole_h/2+rf])
      cylinder(h=sw_hole_h, r=hole_r, center=true);
    translate([uswitch_supp_y/2, pcb_hole_spacing/2+12*pcb_hole_spacing, -sw_hole_h/2+rf])
      cylinder(h=sw_hole_h, r=hole_r, center=true);
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
        raft_h = cover_raft_z+rf;
        //translate([batt_in_gap-raft_w-tolerance, cover_overlap+tolerance, top_t-rf])
        translate([raft_w-tolerance, cover_overlap+tolerance, top_t-rf])
          cube([raft_w, box_i_y - 2*tolerance, raft_h]);
        translate([2*cover_x_c/3, cover_overlap+tolerance, top_t-rf])
          cube([raft_w, box_i_y - 2*tolerance, raft_h]);
        translate([cover_overlap+tolerance, (cover_y_c-raft_w)/2, top_t-rf])
          cube([box_i_x - 2*tolerance, raft_w, raft_h]);
      }

      hole_r_x_ofs = cover_x_c-cover_overlap-box_screw_t/2;
      hole_t_y_ofs = cover_y_c-cover_overlap-box_screw_t/2;
      hole_lb_ofs = cover_overlap+box_screw_t/2;

      if (with_battery) {
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
      else {
        // screw holes (must be flipped upside down)
        translate([hole_lb_ofs, hole_lb_ofs, top_t/2])
          cylinder(h=top_t+2*rf, r=1.5, center=true);
        translate([hole_lb_ofs, hole_t_y_ofs, top_t/2])
          cylinder(h=top_t+2*rf, r=1.5, center=true);
        translate([hole_r_x_ofs, hole_t_y_ofs, top_t/2])
          cylinder(h=top_t+2*rf, r=1.5, center=true);
      }
    }
  }
}

//------------------------------------------------------------------------------

module airtracker_box() {
  displ_x = box_i_x-displ_pcb_x-1.2+rf;
  displ_y = gps_supp_y + displ_pcb_y + 1;

  uswitch_x = displ_x - (uswitch_supp_x/2-(displ_lcd_y_ofs+displ_lcd_x/2));
  uswitch_y = displ_y + uswitch_supp_y + tolerance;

  difference() {
    union() {
      base_box();

      if (with_battery) {
        translate([-rf, -rf, -rf])
          battery_comp();
      }

      translate([box_i_x+rf, gps_supp_y-rf, -rf])
        rotate([0, 0, 270])
          gps_support(glueLeft=0, glueRight=1);

      translate([displ_x, displ_y, -rf])
        rotate([0, 0, 270])
          display_supp(show_pcb=false);

      translate([uswitch_x, uswitch_y, -rf])
        rotate([0, 0, 270])
          uswitch_supp(show_pcb=false);
    }

    if (with_battery) {
      translate([0, -wall_t-rf, 0])
        battery_usb_holes();
    }
    else {
      translate([1, box_i_y-rf, cpu_pcb_z_ofs])
        cpu_usb_holes();
    }

    translate([box_i_x+rf, gps_supp_y-rf, -rf])
      rotate([0, 0, 270])
        gps_text();

    translate([displ_x, displ_y, -bottom_t-rf])
      rotate([0, 0, 270])
        display_hole();

    translate([uswitch_x, uswitch_y, 0])
      rotate([0, 0, 270])
        uswitch_holes();

    translate([-cover_overlap-tolerance/4, -cover_overlap-tolerance/4, box_i_z])
      back_cover(hole=true);

    // hole for switch on top
    mount_hole1_y_ofs = box_i_y-box_screw_t-8;
    mount_hole2_y_ofs = mount_hole1_y_ofs-3*6;
    mount_hole_t = wall_t-0.3;
    switch_hole_r = 2.5+tolerance/2;

    // switch option 1
    translate([box_i_x-rf, mount_hole2_y_ofs, 2*box_i_z/3])
      rotate([0, 90, 0])
        cylinder(h=mount_hole_t, r=switch_hole_r, center=true);

    // switch option 2
    translate([box_i_x-rf, gps_supp_y+15, displ_supp_t+2*switch_hole_r+2])
      rotate([0, 90, 0])
        cylinder(h=mount_hole_t, r=switch_hole_r, center=true);

    // switch option 3
    translate([box_i_x-rf, gps_supp_y+6, 2*box_i_z/3])
      rotate([0, 90, 0])
        cylinder(h=mount_hole_t, r=switch_hole_r, center=true);

    // hole for antenna on top
    translate([box_i_x-rf, mount_hole1_y_ofs, 2*box_i_z/3])
      rotate([0, 90, 0])
        cylinder(h=mount_hole_t, r=3+tolerance/2, center=true);
  }
}


airtracker_box();
//back_cover();
