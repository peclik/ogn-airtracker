//------------------------------------------------------------------------------
/*
  LCD5110 project case.

  This work by Richard Pecl is licensed under a Creative Commons
  Attribution-ShareAlike 4.0 International License
  <http://creativecommons.org/licenses/by-sa/4.0/>.
*/
//------------------------------------------------------------------------------

// printer tolerance
tolerance = 0.5;

//------------------------------------------------------------------------------

// outer wall thickness
wall_t = 3;
// bottom thickness
bottom_t = 1.5;
// top cover thickness
top_t = 2;

// back side cover overlap on each side
cover_overlap = 1.25;

// solidifying rafts height
cover_raft_z = 2;

//------------------------------------------------------------------------------

// battery wall thickness
batt_wall_t = 2.2;

// battery wall height
batt_wall_z = 20;

// gap between left and right battery compartment walls
batt_in_gap = 19 + tolerance;

// battery length (including contacts)
batt_len = 70.5;

// battery circuit length (from plus side contact to end of USB)
batt_el_len = 23.6;

//------------------------------------------------------------------------------

// column for screws mounting back cover
box_screw_t = 6;

// box outer rounded edge radius
box_corner_r = 1.5;

//------------------------------------------------------------------------------

// 5110 display dimensions
displ_pcb_x = 43;
displ_box_y = 6;
displ_pcb_z = 45;

displ_cover_x_ofs = 1;
displ_cover_z_ofs = 5;

displ_cover_x = 41;
displ_cover_y = 3.5;
displ_cover_z = 34;

displ_lcd_x_ofs = 5;
displ_lcd_z_ofs = 9;

// lcd hole width and height
displ_lcd_x = displ_pcb_x-2*displ_lcd_x_ofs;
displ_lcd_z = displ_pcb_z-13-displ_lcd_z_ofs;

displ_supp_t = 1.5;

//------------------------------------------------------------------------------

// universal PCB hole spacing
pcb_hole_spacing = 2.54;

// microswitches support and holes
uswitch_supp_x = (16+1)*pcb_hole_spacing;
uswitch_supp_y = (5+1)*pcb_hole_spacing;
uswitch_supp_z = 4;

//------------------------------------------------------------------------------

// box inner dimensions
box_i_x = ((displ_pcb_z > displ_pcb_x) ? displ_pcb_z : displ_pcb_x) + tolerance;
box_i_y = displ_box_y + tolerance + box_screw_t + batt_len + batt_el_len;
box_i_z = displ_pcb_z + tolerance;

//------------------------------------------------------------------------------

// cover mounting column 1 (x > batt_in_gap)
box_screw1_x = (box_i_x-box_screw_t)/2;
// cover mounting column 3 and 4
box_screw34_y = box_i_y-displ_box_y-box_screw_t-tolerance;

//------------------------------------------------------------------------------

// rounding fix
rf = 0.01;

$fn=100;
