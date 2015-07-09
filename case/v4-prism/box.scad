//------------------------------------------------------------------------------
/*
  LCD5110 project case.
  V4 variant - Prismatic design.

  This work by Richard Pecl is licensed under a Creative Commons
  Attribution-ShareAlike 4.0 International License
  <http://creativecommons.org/licenses/by-sa/4.0/>.
*/
//------------------------------------------------------------------------------
/*
TODO for printing the box from top to bottom:
[!] print the box from top to bottom
 - better access to battery when it's just above the cover
[+] GPS holder
[+] battery holder fixation points
 - charger holder on a side like LCD holder,

DONE for printing the box from top to bottom:
[!] LCD view upside down
[!] antenna and on/off switch positions flipped
[!] microswitches replaced from the cover to the box

TODO:
[*] 4 cover mounting columns instead of 3? - better anti-delamination support

CHANGELOG:


V4.0 (based on V3.1):

*/

include <dimensions.scad>;

//------------------------------------------------------------------------------

// columns for screwing back cover
module box_screw_column(h=box_i_z-tolerance/2) {
  screw_h = h;
  hole_r = 1.2;

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
    translate([box_screw1_x, -rf, -rf])
      box_screw_column();

    translate([-rf, box_screw34_y, -rf])
      box_screw_column();

    translate([box_i_x-box_screw_t+rf, box_screw34_y, -rf])
      box_screw_column();


    translate([wall_t-box_screw_t+rf, 25, -rf])
      cube([box_screw_t, box_screw_t, box_i_z-tolerance/2]);
  }
}

//------------------------------------------------------------------------------

// holes for power bank usb connectors
module battery_usb_holes() {
  translate([(box_i_x-8-tolerance)/2, 0, 5])
    cube([8+tolerance, wall_t+2*rf, 3+tolerance]);

  // micro outter engrave
  u_engrave = wall_t-1;
  translate([(box_i_x-12-tolerance)/2, 0, 5-(8-3-tolerance)/2])
    cube([12+tolerance, u_engrave+rf, 8+tolerance]);
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

// display support
module display_supp() {
  display_supp_x = (box_i_x - displ_pcb_x - tolerance) / 2;
  display_supp_y = displ_box_y + 2;

  translate([-rf, -display_supp_y-wall_t, 0])
    cube([display_supp_x+rf, display_supp_y+rf, box_i_z-tolerance/2]);

  translate([box_i_x-display_supp_x+rf, -display_supp_y-wall_t, 0])
    cube([display_supp_x+rf, display_supp_y+rf, box_i_z-tolerance/2]);
}

// display box
module display_box() {
  to_center_x_ofs = (box_i_x - displ_pcb_x) / 2;

  // view hole
  translate([to_center_x_ofs+displ_lcd_x_ofs, -wall_t-rf, displ_lcd_z_ofs])
    cube([displ_lcd_x, wall_t+2*rf, displ_lcd_z]);
}

// support for material above display view hole
module display_view_support() {
  to_center_x_ofs = (box_i_x - displ_pcb_x) / 2;
  view_hole_top_z = displ_lcd_z_ofs + displ_lcd_z;
  supp_t = 0.3;

  translate([to_center_x_ofs+displ_lcd_x_ofs-rf, -wall_t, displ_lcd_z_ofs-rf])
    cube([displ_lcd_x+2*rf, supp_t, displ_lcd_z+2*rf]);

  translate([to_center_x_ofs+displ_lcd_x_ofs+1, -wall_t, view_hole_top_z-5])
    rotate([-12, 0, 0])
      cube([displ_lcd_x-2, supp_t, 6]);

  translate([to_center_x_ofs+displ_lcd_x_ofs+1, -wall_t, view_hole_top_z-5])
    rotate([-23, 0, 0])
      cube([displ_lcd_x-2, supp_t, 6]);
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

    translate([pcb_hole_spacing/2+1*pcb_hole_spacing, uswitch_supp_y/2, uswitch_supp_z/2])
      cylinder(h=uswitch_supp_z, r=2.5, center=true);
    translate([pcb_hole_spacing/2+15*pcb_hole_spacing, uswitch_supp_y/2, uswitch_supp_z/2])
      cylinder(h=uswitch_supp_z, r=2.5, center=true);
  }
}

// holes for 3 microswitches (each 3x3 holes in size)
module uswitch_holes() {

  union() {
    hole_engrave_t = bottom_t-0.5;
    hole_r = 1.2;
    hole_h = uswitch_supp_z+hole_engrave_t;

    translate([pcb_hole_spacing/2+1*pcb_hole_spacing, uswitch_supp_y/2, (hole_h-hole_engrave_t)/2])
      cylinder(h=hole_h+rf, r=hole_r, center=true);

    translate([pcb_hole_spacing/2+15*pcb_hole_spacing, uswitch_supp_y/2, (hole_h-hole_engrave_t)/2])
      cylinder(h=hole_h+rf, r=hole_r, center=true);

    //sw_hole_h = hole_engrave_t+rf;
    sw_hole_h = bottom_t;
    sw_hole_r = 1.5;

    sw_down_x_ofs = pcb_hole_spacing/2+4*pcb_hole_spacing;
    translate([sw_down_x_ofs, uswitch_supp_y/2+pcb_hole_spacing, -sw_hole_h/2])
      cylinder(h=sw_hole_h+3*rf, r=sw_hole_r, center=true);

    sw_up_x_ofs = pcb_hole_spacing/2+8*pcb_hole_spacing;
    translate([sw_up_x_ofs, uswitch_supp_y/2-pcb_hole_spacing, -sw_hole_h/2])
      cylinder(h=sw_hole_h+3*rf, r=sw_hole_r, center=true);

    sw_set_x_ofs = pcb_hole_spacing/2+12*pcb_hole_spacing;
    translate([sw_set_x_ofs, uswitch_supp_y/2+pcb_hole_spacing, -sw_hole_h/2])
      cylinder(h=sw_hole_h+3*rf, r=sw_hole_r, center=true);

    // engrave switch descriptions
    text_engrave = 0.2;

    translate([sw_down_x_ofs, -pcb_hole_spacing-1, -bottom_t+text_engrave])
      rotate([0, 180, 180])
        linear_extrude(height=text_engrave)
          text("\u25bc", size=5, font="DejaVu Sans", halign="center", valign="center");

    translate([sw_up_x_ofs, -pcb_hole_spacing-1, -bottom_t+text_engrave])
      rotate([0, 180, 180])
        linear_extrude(height=text_engrave)
          text("\u25b2", size=5, font="DejaVu Sans", halign="center", valign="center");

    translate([sw_set_x_ofs, -pcb_hole_spacing-1, -bottom_t+text_engrave])
      rotate([0, 180, 180])
        linear_extrude(height=text_engrave)
          text("\u25cf", size=5, font="DejaVu Sans", halign="center", valign="center");

  }
}


//------------------------------------------------------------------------------

// back covering or hole
module top_cover(hole) {
  cover_x_c = box_i_x + 2*cover_overlap;
  cover_y_c = box_i_y + 2*cover_overlap;

  if (hole)
    cube([cover_x_c + tolerance/2, cover_y_c + tolerance/2, top_t + tolerance/2]);
  else {
    difference() {
    //union() {
      union() {
        cube([cover_x_c - tolerance/2, cover_y_c - tolerance/2, top_t]);

        // solidifying rafts
        raft_w = 3;
        raft_h = cover_raft_z+rf;
        translate([1*cover_x_c/3-raft_w/2, cover_overlap+tolerance, top_t-rf])
          cube([raft_w, box_i_y - displ_box_y - 2*tolerance, raft_h]);

        translate([2*cover_x_c/3-raft_w/2, cover_overlap+tolerance, top_t-rf])
          cube([raft_w, box_i_y - displ_box_y - 2*tolerance, raft_h]);

        translate([cover_overlap+tolerance, (cover_y_c-raft_w)/2, top_t-rf])
          cube([box_i_x - 2*tolerance, raft_w, raft_h]);
      }

      hole_1_x_ofs = cover_overlap+box_screw1_x+box_screw_t/2;
      hole_1_y_ofs = cover_overlap+box_screw_t/2-rf;

      hole_34_y_ofs = cover_overlap+box_screw34_y+box_screw_t/2;
      hole_h = top_t+2*rf;

      // screw holes (must be flipped upside down !!!)
      translate([cover_x_c, 0, hole_h-2*rf]) {
        rotate([0, 180, 0]) {
          union() {
            translate([hole_1_x_ofs, hole_1_y_ofs, top_t/2])
              cylinder(h=hole_h, r=1.6, center=true);

            translate([cover_overlap+box_screw_t/2-rf, hole_34_y_ofs, top_t/2])
              cylinder(h=hole_h, r=1.6, center=true);

            translate([cover_overlap+box_i_x-box_screw_t/2+rf, hole_34_y_ofs, top_t/2])
              cylinder(h=hole_h, r=1.6, center=true);
          }
        }
      }
    }
  }
}

//------------------------------------------------------------------------------

module airtracker_box() {
  displ_x = -rf;
  displ_y = box_i_y+wall_t;

  uswitch_x = (box_i_x-uswitch_supp_x)/2;
  uswitch_y = box_screw34_y + cover_overlap - uswitch_supp_y - 5;

  difference() {
  //union() {
    union() {
      base_box();

      translate([displ_x, displ_y, -rf])
          display_supp();

      translate([uswitch_x, uswitch_y, -rf])
        uswitch_supp(show_pcb=true);
    }

    translate([-cover_overlap-tolerance/4, -cover_overlap-tolerance/4, box_i_z - tolerance / 2 +rf])
      top_cover(hole=true);

    translate([0, -wall_t-rf, 0])
      battery_usb_holes();

    translate([displ_x, displ_y, -rf])
        display_box();

    translate([uswitch_x, uswitch_y, -rf])
      uswitch_holes();

    mount_hole_t = wall_t-0.3;
    switch_hole_r = 2.5+tolerance/2;
    mount_hole_y_ofs = -mount_hole_t/2+rf;

    // on/off switch
    translate([3*box_i_x/4, mount_hole_y_ofs, 10])
      rotate([90, 0, 0])
        cylinder(h=mount_hole_t, r=switch_hole_r, center=true);

    // hole for antenna
    translate([box_i_x/4, mount_hole_y_ofs, box_i_z-13])
      rotate([90, 0, 0])
        cylinder(h=mount_hole_t, r=3+tolerance/2, center=true);
  }

  translate([displ_x, displ_y, -rf])
    display_view_support();
}


airtracker_box();

//translate([-cover_overlap, -cover_overlap, box_i_z+10])
//  top_cover();
