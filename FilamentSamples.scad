// Change For Each Card
BRAND="extrudr";
COLOR="Metallic Grey";
TYPE="Biofusion";
TEMP_HOTEND="225";
TEMP_BED="60";

//hole radius. Set to 0 to have no hole
r_hole=2;

// Change only if absolutely necessary
COLOR_SIZE=5.5;
// Change only if absolutely necessary
TEMP_SIZE=4.2;
// Change only if absolutely necessary
BRAND_SIZE=4.2;
// Change only if absolutely necessary
TYPE_SIZE=4.2;

// change not supported right now
SHOW_FIRSTLAYER_TEMP=0;
// change not supported right now
TEMP_HOTEND_FIRST_LAYER="240";
// change not supported right now
TEMP_BED_FIRST_LAYER="85";
// change not supported right now
INVERT_CARD=1;
// change not supported right now
INFILL_SAMPLE=0;

// General Card Settings

CARD_LENGTH=80.0;
CARD_HEIGHT=35;
CARD_THICKNESS=2.2;
CARD_CORNER_RADIUS=3.3;
CARD_EDGE_RADIUS=1.1;

// General Notch

NOTCH_RADIUS=3.0;
NOTCH_Y=CARD_HEIGHT - 6.75;

// PLA Notch

PLA_NOTCH_X=73.0;

// PETG Notch

//PETG_NOTCH_X=34.0;

// ABS Notch Location

//ABS_NOTCH_X=51.0;

// Other Notch Location

OTHER_NOTCH_X=73.0;
INFILL_NOTCH_X=25.5;

// Inset
INSET_CORNER_RADIUS=2.2;
INSET_EDGE_RADIUS=1.0;
INSET_HEIGHT=10.0;
INSET_WIDTH=7.0;
INSET_FROM_BOTTOM=2.5;
//INSET_DEPTHS=[0.2, 0.4, 0.6, 0.8, 1.0];
INSET_DEPTHS=[1.0, 0.8, 0.6, 0.4, 0.2];

// Text
// FONT = "Arial Rounded MT Bold:style=Regular";
FONT = "Liberation Sans:style=Bold";
TEXT_X=4.0;
TEXT_Y=39.0;
TEXT_DEPTH=1.5;
//TEXT_TEMP=str(TEMP_HOTEND, "\u00B0\u2013", TEMP_BED, "\u00B0");
TEXT_TEMP=str("N", TEMP_HOTEND, "\u00B0 B", TEMP_BED, "\u00B0");
TEXT_FL_TEMP=str("   ", TEMP_HOTEND_FIRST_LAYER, "\u00B0\u2013", TEMP_BED_FIRST_LAYER, "\u00B0");

$fn = 50;

module CardCorner(x, y, z) {
  translate([x, y, z])
    hull() {
      rotate_extrude()
        translate([CARD_CORNER_RADIUS - CARD_EDGE_RADIUS, 0, 0])
        circle(CARD_EDGE_RADIUS);
    }
}

module CardBody() {
  hull() {
    CardCorner(CARD_CORNER_RADIUS, CARD_CORNER_RADIUS, CARD_EDGE_RADIUS);
    CardCorner(CARD_CORNER_RADIUS, CARD_CORNER_RADIUS, CARD_THICKNESS - CARD_EDGE_RADIUS);
      
    CardCorner(CARD_LENGTH - CARD_CORNER_RADIUS, CARD_CORNER_RADIUS, CARD_EDGE_RADIUS);
    CardCorner(CARD_LENGTH - CARD_CORNER_RADIUS, CARD_CORNER_RADIUS, CARD_THICKNESS - CARD_EDGE_RADIUS);
      
    CardCorner(CARD_CORNER_RADIUS, CARD_HEIGHT - CARD_CORNER_RADIUS, CARD_EDGE_RADIUS);
    CardCorner(CARD_CORNER_RADIUS, CARD_HEIGHT - CARD_CORNER_RADIUS, CARD_THICKNESS - CARD_EDGE_RADIUS);
      
    CardCorner(CARD_LENGTH - CARD_CORNER_RADIUS, CARD_HEIGHT - CARD_CORNER_RADIUS, CARD_EDGE_RADIUS);
    CardCorner(CARD_LENGTH - CARD_CORNER_RADIUS, CARD_HEIGHT - CARD_CORNER_RADIUS, CARD_THICKNESS - CARD_EDGE_RADIUS);
    
    
    
  }
}


module Notch(X) {
  translate([X, NOTCH_Y, 0])
    cylinder(CARD_THICKNESS, NOTCH_RADIUS, NOTCH_RADIUS);
}

module Insets() {
  Inset(42.5, INSET_DEPTHS[0]);
  Inset(49.5, INSET_DEPTHS[1]);
  Inset(56.5, INSET_DEPTHS[2]);
  Inset(63.5, INSET_DEPTHS[3]);
  Inset(70.5, INSET_DEPTHS[4]);
}

module Inset(Inset_X, Thickness) {
  hull() {
    translate([Inset_X, INSET_FROM_BOTTOM, Thickness])
      cube([INSET_WIDTH, INSET_HEIGHT, CARD_THICKNESS]);
  }
}

module TopInset(Inset_X, Thickness) {
  hull() {
    translate([Inset_X, INSET_FROM_BOTTOM, Thickness])
      cube([INSET_WIDTH, INSET_HEIGHT, CARD_THICKNESS]);
  }
}

module CardInfo() {
  Text(16.5, TEXT_TEMP, TEMP_SIZE, 1.1, "right", CARD_LENGTH-TEXT_X+0.2);
  Text(24, COLOR, COLOR_SIZE, 1.0);
  Text(10, BRAND, BRAND_SIZE, 1.0);
  if (SHOW_FIRSTLAYER_TEMP == 1) {
    Text(14, TEXT_FL_TEMP, 3, 1.0);
  }
  Text(4, TYPE, TYPE_SIZE, 1.0);
}

module InfillInfo() {
  Text(40, BRAND, 6.4, 1.0);
  Text(32, COLOR, COLOR_SIZE, 1.1);
}

module Text(Y, Text, Size, Spacing, Halign="left", X=TEXT_X) {
  translate([X, Y, CARD_THICKNESS - TEXT_DEPTH - 0.2])
    linear_extrude(TEXT_DEPTH)
      text(text = Text, size = Size, font = FONT, spacing = Spacing, halign=Halign);
}

module Invert() {
    translate([INSET_FROM_BOTTOM, INSET_FROM_BOTTOM, TEXT_DEPTH])
        cube([37.5,CARD_HEIGHT - (2 * INSET_FROM_BOTTOM),4]);
    translate([37.5, 15, TEXT_DEPTH])
        cube([40,17.5,4]);
}

module Infill() {
    translate([INSET_FROM_BOTTOM, CARD_HEIGHT - 24.4, TEXT_DEPTH])
        cube([CARD_LENGTH - (2 * INSET_FROM_BOTTOM), 24.4 - INSET_FROM_BOTTOM, 4]);
    translate([INSET_FROM_BOTTOM, INSET_FROM_BOTTOM, CARD_THICKNESS - 0.15])
        cube([CARD_LENGTH - (2 * INSET_FROM_BOTTOM), INSET_HEIGHT, .25]);
}

module Card() {
  difference() {
    CardBody();
    Notch(PLA_NOTCH_X);
    if (INFILL_SAMPLE==1) {
        Infill();
        Notch(INFILL_NOTCH_X);
    }
    if (INFILL_SAMPLE==0) {
        if (INVERT_CARD==1) {
          Invert();
        }
        if (TYPE=="PETG") {
          Notch(PETG_NOTCH_X);
        } else {
            if (TYPE=="ABS") {
              Notch(ABS_NOTCH_X);
            } else {
                if (TYPE != "PLA") {
                  Notch(OTHER_NOTCH_X);
                }
            }
        }
        
        Insets();
        if (INVERT_CARD!=1) {
          CardInfo();
        }
      }
  }
  
  if (INFILL_SAMPLE==0) {
      if (INVERT_CARD==1) {
        CardInfo();
      }
  }
  if (INFILL_SAMPLE==1) {
      InfillInfo();
  }
}

Card();