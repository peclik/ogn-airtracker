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
// bottom thickness (in view of printing, will be top side)
bottom_t = 1.5;
// top cover thickness (in view of printing, will be bottom cover)
top_t = 2;

// back side cover overlap on each side
cover_overlap = 1.25;

// solidifying rafts height
cover_raft_z = 2;

//------------------------------------------------------------------------------

// battery holder length
batt_len = 75;

//------------------------------------------------------------------------------

// column for screws mounting back cover
box_screw_t = 6;
box_screw_r = 1.2;

// box outer rounded edge radius
box_corner_r = 1.5;

//------------------------------------------------------------------------------

// 5110 display dimensions
displ_pcb_x = 43;
displ_box_y = 6.5;
displ_pcb_z = 45;

//displ_cover_x_ofs = 1;
//displ_cover_z_ofs = 5;

//displ_cover_x = 41;
//displ_cover_y = 3.5;
//displ_cover_z = 34;

displ_lcd_x_ofs = 4;
displ_lcd_z_ofs = 8;

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
uswitch_supp_z = 5;

//------------------------------------------------------------------------------

// GPS PCB size

// gps support thickness
gps_supp_t = 1.75;

// gap between left and right GPS support (antenna width)
gps_supp_gap = 25.2 + tolerance;

gps_supp_x = 36;
gps_supp_y = gps_supp_gap + 2*gps_supp_t;
gps_supp_z = 4.5;


//------------------------------------------------------------------------------

// battery charger

 // TODO
charger_pcb_x = 17;
charger_pcb_y = 26;
// middle inset
charger_pcb_my = charger_pcb_y - 1;

// PCB z offset (bottom side)
charger_pcb_ofs_z = 5+1.5;

// connector's center offset relative to PCB
charger_usb_ofs_z = 2;

// PCB support overlaps
charger_overlap_x = 2;
charger_overlap_y = 4;
charger_overlap_z = 2;

// front & back support
charger_supp_t = 4;
charger_b_supp_y = 2;

// offset moving right support out of box wall for antidelamination around usb hole
charger_supp_ofs_x = 1;

//charger_supp_z = charger_pcb_x + 2 * (charger_supp_h-charger_overlap_z);
charger_supp_x = charger_pcb_x + 2 * charger_overlap_x + tolerance;

//------------------------------------------------------------------------------

// box inner dimensions
box_i_x = ((displ_pcb_z > displ_pcb_x) ? displ_pcb_z : displ_pcb_x) + tolerance;
box_i_y = displ_box_y + tolerance + box_screw_t + batt_len;
box_i_z = displ_pcb_z + 3*tolerance;
//box_i_z = 10;

//------------------------------------------------------------------------------

// cover mounting column 1
box_screw1_x = (box_i_x-box_screw_t)/2;
// cover mounting column 3 and 4
box_screw34_y = box_i_y-displ_box_y-box_screw_t-tolerance;

//------------------------------------------------------------------------------

// rounding fix
rf = 0.01;

$fn=100;
