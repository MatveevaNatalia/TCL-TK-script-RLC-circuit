#!/usr/bin/wish

frame .ffr

wm title . "RLC circuit simulator" 
wm geometry . 1000x600+200+200


package require Img


frame .fr -background "#333"
pack .fr -fill both -expand 1

image create photo img1 -file "RLC_circuit.png"

label .fr.lbl1 -image img1 
place .fr.lbl1 -x 20 -y 20

label .fr.l -text "L:" -font {Helvetica -18 bold} -background red
place .fr.l -x 500 -y 20
entry .e  -relief sunken -bd 2 -textvariable L -background red  -width 5
place .e -x 530 -y 25
focus .e

label .fr.l1 -text "C:" -font {Helvetica -18 bold} -background green
place .fr.l1 -x 600 -y 20
entry .e1 -width 5 -relief sunken -bd 2 -textvariable C -background green
place .e1 -x 630 -y 25
focus .e1

label .fr.l2 -text "R:" -font {Helvetica -18 bold} -background yellow
place .fr.l2 -x 700 -y 20
entry .e2 -width 5 -relief sunken -bd 2 -textvariable R -background yellow
place .e2 -x 730 -y 25
focus .e2

label .fr.l3 -width 3 -text "t" -font {Helvetica -18 bold} 
place .fr.l3 -x 954 -y 507

label .fr.l4 -width 3 -text "I(t)" -font {Helvetica -18 bold} 
place .fr.l4 -x 450 -y 105

button .b -text Calculate -font {Helvetica -18 bold} -command {
	.c delete all

	set alpha [expr $R / (2.0 * $L)]
	set omega [expr 1.0 / sqrt($L * $C) ]
	set zeta  [expr $alpha / $omega ]
	if {$R == 0} { set timescale [expr 15.0/$omega] } else { set timescale [expr 5.0/$alpha] }

	if {$zeta > 1} {
	    # Overdamped case
	    for {set i 0} {$i < 500.0} {incr i} {
		set t($i) [expr {$timescale * $i/500.0}]
		set y($i) [expr exp(-$omega*($zeta + sqrt($zeta*$zeta - 1))*$t($i))]
	    }
	} else {
	    # Underdamped case
	    for {set i 0} {$i < 500.0} {incr i} {
		set t($i) [expr {$timescale * $i/500.0}]
		set y($i) [expr exp(-$alpha*$t($i))*sin($omega*sqrt(1-$zeta*$zeta)*$t($i))]
	    }
	}

	for {set i 0} {$i < 500} {incr i} {
	    if {$i == 0} {
	       set oldx [expr $i]
	       set oldy [expr 200+100*$y($i)]
	    }
	    if {$i > 0} {
	       set newx [expr $i]
	       set newy [expr 200-100*$y($i)]
	       .c create line $oldx $oldy $newx $newy -width 3 
	       set oldx $newx
	       set oldy $newy
	    }
	 }
}
place  .b -x 600 -y 90

set width 500
set height 400
canvas .c -width $width -height $height -background white
place .c -x 450 -y 138

button .hello -text "Quit" -font {Helvetica -18 bold}  -command { exit }
place .hello -x 900 -y 20 




