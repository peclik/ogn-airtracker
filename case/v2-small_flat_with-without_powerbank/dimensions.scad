//------------------------------------------------------------------------------
/*
  LCD5110 project case.

  This work by Richard Pecl is licensed under a Creative Commons
  Attribution-ShareAlike 4.0 International License
  <http://creativecommons.org/licenses/by-sa/4.0/>.
*/
//------------------------------------------------------------------------------

// with/without battery compartment box
with_battery = true;

//------------------------------------------------------------------------------

// printer tolerance
tolerance = 0.5;

//------------------------------------------------------------------------------

// outer wall thickness
wall_t = 2.5;
// bottom (LCD side) thickness
bottom_t = 1.5;
// bottom (back side cover) thickness
top_t = 2;

// back side cover overlap on each side
cover_overlap = 1.25;

// solidifying rafts height
cover_raft_z = 2;

// box inner dimensions (>= batt_wall_z)
box_i_z = 22-bottom_t-top_t+cover_raft_z;

//------------------------------------------------------------------------------

// GPS length
gps_len = 35;
// complete gps support thickness
gps_supp_t = 1.75;

// add some space for GPS PCB on the side adhering to some wall
gps_supp_glue_t = 0.5;

// gap between left and right GPS support (antenna width)
gps_supp_gap = 25.2 + tolerance;

gps_supp_z = box_i_z - 2;
gps_supp_x = sqrt(gps_len*gps_len - gps_supp_z*gps_supp_z);
gps_supp_y = gps_supp_gap + 2*gps_supp_t + gps_supp_glue_t;

//------------------------------------------------------------------------------

// battery wall thickness
batt_wall_t = 2.2;

// battery wall height (<= box_i_z)
batt_wall_z = box_i_z-cover_raft_z-tolerance;

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
displ_pcb_x = 45;
displ_pcb_y = 43;

displ_hole_x_ofs = 2;
displ_hole_y_ofs = 4;

displ_cover_x = 34;
displ_cover_y = 40;

displ_lcd_y_ofs = 9;

// lcd hole width and height
displ_lcd_x = displ_pcb_x-13-displ_lcd_y_ofs;
displ_lcd_y = displ_pcb_y-2*5;

displ_supp_t = 1.5;

//------------------------------------------------------------------------------

// CPU board placing (for USB hole in box without battery)
cpu_pcb_z_ofs = box_i_z-7;

//------------------------------------------------------------------------------

// universal PCB hole spacing
pcb_hole_spacing = 2.54;

// microswitches support and holes
uswitch_supp_x = (16+1)*pcb_hole_spacing;
uswitch_supp_y = (5+1)*pcb_hole_spacing;
uswitch_supp_z = 4;

//------------------------------------------------------------------------------

//box_i_y = box_screw_t + batt_wall_t + batt_len + batt_el_len;
//box_i_x = batt_in_gap + batt_wall_t + 60;
box_i_y = with_battery ? (batt_len + batt_el_len) : (97 - 2*wall_t);
box_i_x = with_battery ? (batt_in_gap+batt_wall_t+displ_pcb_x + 3)  : (displ_pcb_x + 3);

//------------------------------------------------------------------------------

// rounding fix
rf = 0.01;

$fn=100;
