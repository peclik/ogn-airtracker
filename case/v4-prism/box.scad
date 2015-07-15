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
[+] battery holder fixation points (battery on its left side, screwed to the wall printed in the middle of the cover)

TODO:
[+] battery charger holder - check size (back support between corners), holes, usb position
[+] move back mounting poles to corners (battery should be aligned with the right wall)
[-] more space for buttons PCB (probably move GPS to the left wall, move middle charger pole beside GPS poles, so that GPS can be moved further to back)

CHANGELOG:

V4.1 (after prototype 1):
[+] engrave for antenna and on/off switch nuts
[-] corrected holes in GPS holder poles
[-] larger holes for button knobs


V4.0 (based on V3.1):
DONE for printing the box from top to bottom:
[!] LCD view upside down
[!] antenna and on/off switch positions flipped
[!] microswitches replaced from the cover to the box
[*] 4 cover mounting columns instead of 3 - better anti-delamination support
[+] GPS holder


*/

include <dimensions.scad>;

//------------------------------------------------------------------------------

// columns for screwing back cover
module box_screw_column(h=box_i_z-tolerance/2) {
  screw_h = 15;

  difference() {
    cube([box_screw_t, box_screw_t, h]);
    translate([box_screw_t/2, box_screw_t/2, h-screw_h/2+rf])
      cylinder(h=screw_h+rf, r=box_screw_r, center=true);
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
    translate([-rf, box_screw34_y, -rf])
      box_screw_column();

    translate([box_i_x-box_screw_t+rf, box_screw34_y, -rf])
      box_screw_column();

    translate([wall_t-box_screw_t+box_screw_r+rf, 15, -rf])
      box_screw_column();

    translate([box_i_x-box_screw_t/2-box_screw_r+rf, 15, -rf])
      box_screw_column();
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

  color("gray") {
  translate([to_center_x_ofs+displ_lcd_x_ofs-rf, -wall_t, displ_lcd_z_ofs-rf])
    cube([displ_lcd_x+2*rf, supp_t, displ_lcd_z+2*rf]);

  translate([to_center_x_ofs+displ_lcd_x_ofs+1, -wall_t, view_hole_top_z-5])
    rotate([-12, 0, 0])
      cube([displ_lcd_x-2, supp_t, 6]);

  translate([to_center_x_ofs+displ_lcd_x_ofs+1, -wall_t, view_hole_top_z-5])
    rotate([-23, 0, 0])
      cube([displ_lcd_x-2, supp_t, 6]);
  }
}

//------------------------------------------------------------------------------

module gps_support_poles(hole=false) {

  gps_pole_x_ofs = 2.5;
  gps_pole_y_ofs = 2.5;
  gps_pole_r = hole ? 1.2 : 2.5;
  gps_pole_h = hole ? (gps_supp_z + 2*rf) : gps_supp_z;

  translate([gps_pole_x_ofs, gps_supp_t + gps_pole_y_ofs, gps_pole_h/2])
    cylinder(h=gps_pole_h, r=gps_pole_r, center=true);
  if (!hole)
    translate([gps_pole_r, gps_pole_r, gps_pole_h/2])
      cube([2*gps_pole_r, 2*gps_pole_r, gps_pole_h], center=true);

  translate([gps_supp_x - gps_pole_x_ofs, gps_supp_t + gps_pole_y_ofs, gps_pole_h/2])
    cylinder(h=gps_pole_h, r=gps_pole_r, center=true);
  if (!hole)
    translate([gps_supp_x - gps_pole_x_ofs, gps_pole_r, gps_pole_h/2])
      cube([2*gps_pole_r, 2*gps_pole_r, gps_pole_h], center=true);

  translate([gps_pole_x_ofs, gps_supp_gap + gps_supp_t - gps_pole_y_ofs, gps_pole_h/2])
    cylinder(h=gps_pole_h, r=gps_pole_r, center=true);
  if (!hole)
    translate([gps_pole_r, gps_supp_gap+gps_pole_r-gps_supp_t, gps_pole_h/2])
      cube([2*gps_pole_r, 2*gps_pole_r, gps_pole_h], center=true);

  translate([gps_supp_x - gps_pole_x_ofs, gps_supp_gap + gps_supp_t - gps_pole_y_ofs, gps_pole_h/2])
    cylinder(h=gps_pole_h, r=gps_pole_r, center=true);
  if (!hole)
    translate([gps_supp_x - gps_pole_x_ofs, gps_supp_gap+gps_pole_r-gps_supp_t, gps_pole_h/2])
      cube([2*gps_pole_r, 2*gps_pole_r, gps_pole_h], center=true);
}

module gps_support() {
  color("red")
  union() {
    translate([0, gps_supp_gap + gps_supp_t, 0])
      cube([gps_supp_x, gps_supp_t, gps_supp_z]);

    cube([gps_supp_x, gps_supp_t, gps_supp_z]);

    gps_support_poles();
  }
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
    sw_hole_r = 1.7;

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
          text("\u25bc", size=4, font="DejaVu Sans", halign="center", valign="center");

    translate([sw_up_x_ofs, -pcb_hole_spacing-1, -bottom_t+text_engrave])
      rotate([0, 180, 180])
        linear_extrude(height=text_engrave)
          text("\u25b2", size=4, font="DejaVu Sans", halign="center", valign="center");

    translate([sw_set_x_ofs, -pcb_hole_spacing-1, -bottom_t+text_engrave])
      rotate([0, 180, 180])
        linear_extrude(height=text_engrave)
          text("\u25cf", size=4, font="DejaVu Sans", halign="center", valign="center");

  }
}

//------------------------------------------------------------------------------

// hole for micro USB connectors (x/z-centered at 0)
module micro_usb_hole() {
  translate([-(12+tolerance)/2, 0, -(8+tolerance)/2]) {
    // outter engrave
    u_engrave = wall_t-1.5;
    cube([12+tolerance, u_engrave+rf, 8+tolerance]);

    // hole
    translate([(12-8)/2, 0, (8-3)/2])
      cube([8+tolerance, wall_t+2*rf, 3+tolerance]);
  }
}

//------------------------------------------------------------------------------

// battery charger support
module charger_supp() {
  color("pink") {
    charger_supp_h = charger_pcb_ofs_z + charger_overlap_z;
    // PCB support blocks - to be cut for PCB fitting

    // front left block
    cube([charger_supp_t + charger_overlap_x, charger_supp_t, charger_supp_h]);

    // front right block
    translate([charger_supp_x - charger_overlap_x - charger_supp_t, 0, 0])
      cube([charger_supp_t + charger_overlap_x, charger_supp_t, charger_supp_h]);

    // back right block
    //~ translate([charger_supp_x - charger_overlap_x + rf, charger_pcb_my - charger_supp_t, 0])
      //~ cube([charger_supp_ofs_x, charger_supp_t, charger_supp_h]);

    // back middle block
    translate([(charger_supp_x - charger_supp_t)/2, charger_pcb_my - charger_b_supp_y, 0])
      cube([charger_supp_t, charger_b_supp_y + charger_overlap_y, charger_supp_h]);
  }
}

// cut for battery charger PCB and USB connector
module charger_supp_cut() {
  pcb_t = 2;

  translate([charger_overlap_x, 0, charger_pcb_ofs_z - tolerance/2]) {
    cube([charger_pcb_x + tolerance, charger_pcb_my + tolerance, tolerance/2 + charger_overlap_z + rf]);

    translate([(charger_pcb_x + tolerance)/2, -wall_t, -charger_usb_ofs_z + tolerance/2])
      micro_usb_hole();
  }

  charger_hole_h = charger_pcb_ofs_z + charger_overlap_z + rf;
  charger_hole_r = 1;

  translate([charger_overlap_x + 2 + tolerance/2, 2, charger_hole_h/2])
    cylinder(h=charger_hole_h, r=charger_hole_r, center=true);

  translate([charger_overlap_x + charger_pcb_x - 2 + tolerance/2, 2, charger_hole_h/2])
    cylinder(h=charger_hole_h, r=charger_hole_r, center=true);

  translate([charger_supp_x/2, charger_pcb_my + charger_hole_r + 2*tolerance, charger_hole_h/2])
    cylinder(h=charger_hole_h, r=charger_hole_r, center=true);

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
  uswitch_y = box_screw34_y - uswitch_supp_y - 1;

  gps_x = box_i_x-gps_supp_x+rf;
  //gps_y = uswitch_y - gps_supp_y - 3;
  gps_y = charger_pcb_my + charger_overlap_y - rf;

  //charger_x = box_i_x - charger_supp_x + charger_overlap_x - charger_supp_ofs_x + rf;
  charger_x = box_i_x-box_screw_t/2-box_screw_r-charger_supp_x+charger_overlap_x-rf;
  charger_z = -rf;

  difference() {
  //union() {
    union() {
      base_box();

      translate([displ_x, displ_y, -rf])
          display_supp();

      translate([uswitch_x, uswitch_y, -rf])
        uswitch_supp(show_pcb=false);

      translate([gps_x, gps_y, -rf])
        gps_support();

      translate([charger_x, -rf, charger_z])
        charger_supp();
    }

    translate([-cover_overlap-tolerance/4, -cover_overlap-tolerance/4, box_i_z - tolerance / 2 +rf])
      top_cover(hole=true);

    translate([displ_x, displ_y, -rf])
        display_box();

    translate([uswitch_x, uswitch_y, -rf])
      uswitch_holes();

    translate([gps_x, gps_y, -rf])
      gps_support_poles(hole=true);

    translate([charger_x, -rf, charger_z])
      charger_supp_cut();

    mount_hole_t = wall_t+rf;
    switch_hole_r = 2.5+tolerance/2;
    mount_hole_y_ofs = -mount_hole_t/2+rf;

    // on/off switch
    translate([box_i_x-charger_pcb_x/2-charger_supp_ofs_x, mount_hole_y_ofs, charger_pcb_ofs_z + 13])
      rotate([90, 0, 0]) {
        cylinder(h=mount_hole_t, r=switch_hole_r, center=true);
        translate([0, 0, -(mount_hole_t-1)/2])
          cylinder(h=1, r=4+tolerance/2, center=true, $fn=6);
      }

    // hole for antenna
    translate([(box_i_x-box_screw_t)/4, mount_hole_y_ofs, box_i_z-10])
      rotate([90, 0, 0]) {
        cylinder(h=mount_hole_t, r=3+tolerance/2, center=true);
        translate([0, 0, -(mount_hole_t-1)/2])
          cylinder(h=1, r=4.5+tolerance/2, center=true, $fn=6);
      }
  }

  translate([displ_x, displ_y, -rf])
    display_view_support();
}


airtracker_box();

//translate([-cover_overlap, -cover_overlap, box_i_z+10])
//  top_cover();
