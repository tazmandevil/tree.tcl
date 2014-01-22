#! /usr/bin/env wish8.5

##############################################
# libertree client
# (c) tazman deville | http://tazmandevil.info
# released according to the terms of the Gnu Public License, v. 3 or later
# further licensing details at the end of the code.

package require http
package require tls

uplevel #0 [list source ~/.treetcl.conf]

#############################
# I've been told that there are better ways to get stuff done
# than using tonso global variables.
# nonetheless, I'm about to name a whole herd of global variables:

global uname
global pword
global tree
global filename
global brow
global wbg
global wtx
global post
global plength
global apitoken
global update

set allvars [list tree apitoken txfg txbg brow wbg wtx novar]


set filename " "
set currentfile " "
set wrap word


font create font  -family fixed

set novar "cows"

set file_types {
{"All Files" * }
{"leaves" {.leaf}}
{"Text Files" { .txt .TXT}}
}

############33
# keybindings

bind . <Escape> leave
bind . <Control-z> {catch {.txt.txt edit undo}}
bind . <Control-r> {catch {.txt.txt edit redo}}
bind . <Control-a> {.txt.txt tag add sel 1.0 end}
bind . <F4> specialbox
bind . <F3> {FindPopup}
bind . <Control-s> {file_save}
bind . <Control-b> {file_saveas}
bind . <Control-o> {OpenFile}
bind . <Control-q> {clear}
bind . <F8> {prefs}
bind . <F7> {browz}
bind . <F5> {wordcount}

tk_setPalette background $::wbg foreground $::wtx

wm title . "Tazman's Tree Tickler"

######3
# Menus
#################################

# menu bar buttons
frame .fluff -bd 1 -relief raised

tk::menubutton .fluff.mb -text File -menu .fluff.mb.f 
tk::menubutton .fluff.ed -text Edit -menu .fluff.ed.t 
tk::menubutton .fluff.mu -text Markdown -menu .fluff.mu.t
tk::menubutton .fluff.view -text View -menu .fluff.view.t
tk::label .fluff.font1 -text "Font size:" 
ttk::combobox .fluff.size -width 4 -value [list 8 10 12 14 16 18 20 22] -state readonly

bind .fluff.size <<ComboboxSelected>> [list sizeFont .txt.txt .fluff.size]

# file menu
#############################
menu .fluff.mb.f -tearoff 1
.fluff.mb.f add command -label "Open" -command {OpenFile} -accelerator Ctrl+o
.fluff.mb.f add command -label  "Save" -command {file_save} -accelerator Ctrl+s
.fluff.mb.f  add command -label "SaveAs" -command {file_saveas} -accelerator Ctrl-b
.fluff.mb.f add command -label "Clear" -command {clear} -accelerator Ctrl+q
.fluff.mb.f add separator
.fluff.mb.f  add command -label "Quit" -command {leave} -accelerator Escape


# edit menu
######################################3
menu .fluff.ed.t -tearoff 1
.fluff.ed.t add command -label "Cut" -command cut_text -accelerator Ctrl+x
.fluff.ed.t add command -label "Copy" -command copy_text -accelerator Ctrl+c
.fluff.ed.t add command -label "Paste" -command paste_text -accelerator Ctrl+v
.fluff.ed.t add command -label "Select all"	-command ".txt.txt tag add sel 1.0 end" -accelerator Ctrl+a
.fluff.ed.t add command -label "Undo" -command {catch {.txt.txt edit undo}} -accelerator Ctrl+z
.fluff.ed.t add command -label "Redo" -command {catch {.txt.txt edit redo}} -accelerator Ctrl+r
.fluff.ed.t add separator
.fluff.ed.t add command -label "Search/Replace" -command {FindPopup} -accelerator F3
.fluff.ed.t add separator
.fluff.ed.t add command -label "Word Count" -command {wordcount} -accelerator F5
.fluff.ed.t add separator
.fluff.ed.t add command -label "Preferences" -command {prefs} -accelerator F8


tk::button .fluff.help -text "Help" -command {help}
tk::button .fluff.abt -text "About" -command {about}

# markdown menu
# ##################
 menu .fluff.mu.t -tearoff 1
 .fluff.mu.t add command -label "Link" -command {inlink}
 .fluff.mu.t add command -label "Image" -command {inpic}
 .fluff.mu.t add command -label "Time Stamp" -command {indate}
 .fluff.mu.t add command -label "Bold" -command {bold}
 .fluff.mu.t add command -label "Italics" -command {ital}
 .fluff.mu.t add command -label "Bold&Italic" -command {iboldic}
 .fluff.mu.t add command -label "Heading 1" -command {head1}
 .fluff.mu.t add command -label "Heading 2" -command {head2}
 .fluff.mu.t add command -label "Heading 3" -command {head3}
 .fluff.mu.t add command -label "Heading 4" -command {head4}



# view menu
####################################
menu .fluff.view.t -tearoff 1

.fluff.view.t add command -label "go to forest" -command {
    exec $::brow http://$::tree &
    }

# pack em in...
############################

pack .fluff.mb -in .fluff -side left
pack .fluff.ed -in .fluff -side left
pack .fluff.mu -in .fluff -side left
pack .fluff.view -in .fluff -side left
pack .fluff.font1 -in .fluff -side left
pack .fluff.size -in .fluff -side left

pack .fluff.help -in .fluff -side right
pack .fluff.abt -in .fluff -side right

pack .fluff -in . -fill x



# Here is the text widget
########################################TEXT WIDGET
# amazingly simple, this part, considering the great power in this little widget...
# of course, that's because someone a lot smarter than me built the widget already.
# that sure was nice of them...

frame .txt -bd 2 -relief sunken
text .txt.txt -yscrollcommand ".txt.ys set" -xscrollcommand ".txt.xs set" -maxundo 0 -undo true -wrap word -bg $::txbg -fg $::txfg

scrollbar .txt.ys -command ".txt.txt yview"
scrollbar .txt.xs -command ".txt.txt xview" -orient horizontal

pack .txt.xs -in .txt -side bottom -fill x
pack .txt.txt -in .txt -side left -fill both -expand true

pack .txt.ys -in .txt -side left -fill y
pack .txt -in . -fill both -expand true
focus .txt.txt
set foco .txt.txt
bind .txt.txt <FocusIn> {set foco .txt.txt}

# post buttons
#
###################
frame .p

grid [tk::button .p.post -text "GO" -command tpost]\
[tk::button .p.q -text "Quit" -command {leave}]

pack .p -in . -fill x


###
# font size, affects size of font in editor, not in post
# to affect font in post, you have to use html tags...sorry
# I should built that in.
########################################################

proc sizeFont {txt combo} {
	set font [$txt cget -font]
	font configure $font -size [list [$combo get]]
}


###
# open
############################

proc OpenFile {} {

if {$::filename != " "} {
	global filename
	set filename [tk_getOpenFile -filetypes $::file_types]
	wm title . "Now Tickling: $::filename"
	set data [open $::filename RDWR]
	.txt.txt delete 1.0 end
	while {![eof $data]} {
		.txt.txt insert end [read $data 1000]
		}
	close $data
	.txt.txt mark set insert 1.0
	}
}

##
# save & save-as
###########################

proc file_save {} {
	if {$::filename != " "} {
   set data [.txt.txt get 1.0 {end -1c}]
   set fileid [open $::filename w]
   puts -nonewline $fileid $data
   close $fileid
	} else {file_saveas}
 
}

proc file_saveas {} { 
global filename
set filename [tk_getSaveFile -filetypes $::file_types]
   set data [.txt.txt get 1.0 {end -1c}]
   wm title . "Now Tickling: $::filename"
   set fileid [open $::filename w]
   puts -nonewline $fileid $data
   close $fileid
}

# about message box
####################################ABOUT

proc about {} {

toplevel .about
wm title .about "About Tree.Tcl"
# tk_setPalette background $::wbg 

tk::message .about.t -text "Tazman\'s Tree Tickler\n by Tazman Deville\n http://tazmandevil.info\n A libertree posting client written in tcl/tk\n Released under the GPL\n For more info see README.\n" -width 280
tk::button .about.o -text "Okay" -command {destroy .about} 
pack .about.t -in .about -side top
pack .about.o -in .about -side top

}

# find/replace/go to line
############################################FIND REPLACE DIALOG

proc FindPopup {} {

global seltxt repltxt

toplevel .fpop 

# -width 12c -height 4c

wm title .fpop "Find Stuff... (but not your socks)"

frame .fpop.l1 -bd 2 -relief raised

tk::label .fpop.l1.fidis -text "FIND     :"
tk::entry .fpop.l1.en1 -width 20 -textvariable seltxt
tk::button .fpop.l1.finfo -text "Forward" -command {FindWord  -forwards $seltxt}
tk::button .fpop.l1.finbk -text "Backward" -command {FindWord  -backwards $seltxt}
tk::button .fpop.l1.tagall -text "Highlight All" -command {TagAll}

pack .fpop.l1.fidis -in .fpop.l1 -side left
pack .fpop.l1.en1 -in .fpop.l1 -side left
pack .fpop.l1.finfo -in .fpop.l1 -side left
pack .fpop.l1.finbk -in .fpop.l1 -side left
pack .fpop.l1.tagall -in .fpop.l1 -side left
pack .fpop.l1 -in .fpop -fill x


frame .fpop.l2 -bd 2 -relief raised

tk::label .fpop.l2.redis -text "REPLACE:"
tk::entry .fpop.l2.en2 -width 20 -textvariable repltxt
tk::button .fpop.l2.refo -text "Forward" -command {ReplaceSelection -forwards}
tk::button .fpop.l2.reback -text "Backward" -command {ReplaceSelection -backwards}
tk::button .fpop.l2.repall -text "Replace All" -command {ReplaceAll}

pack .fpop.l2.redis -in .fpop.l2 -side left
pack .fpop.l2.en2 -in .fpop.l2 -side left
pack .fpop.l2.refo -in .fpop.l2 -side left
pack .fpop.l2.reback -in .fpop.l2 -side left
pack .fpop.l2.repall -in .fpop.l2 -side left
pack .fpop.l2 -in .fpop -fill x

frame .fpop.l3 -bd 2 -relief raised

tk::label .fpop.l3.goto -text "Line No. :"
tk::entry .fpop.l3.line -textvariable lino
tk::button .fpop.l3.now -text "Go" -command {gotoline}
tk::button .fpop.l3.dismis -text Done -command {destroy .fpop}

pack .fpop.l3.goto -in .fpop.l3 -side left
pack .fpop.l3.line -in .fpop.l3 -side left
pack .fpop.l3.now -in .fpop.l3 -side left
pack .fpop.l3.dismis -in .fpop.l3 -side right
pack .fpop.l3 -in .fpop -fill x


# focus .fpop.en1
}
########################FIND/REPLACE#########
## all this find-replace stuff needs work...
#############################################

proc FindWord {swit seltxt} {
global found
set l1 [string length $seltxt]
scan [.txt.txt index end] %d nl
scan [.txt.txt index insert] %d cl
if {[string compare $swit "-forwards"] == 0 } {
set curpos [.txt.txt index "insert + $l1 chars"]

for {set i $cl} {$i < $nl} {incr i} {
		
	#.txt.txt mark set first $i.0
	.txt.txt mark set last  $i.end ;#another way "first lineend"
	set lpos [.txt.txt index last]
	set curpos [.txt.txt search $swit -exact $seltxt $curpos]
	if {$curpos != ""} {
		selection clear .txt.txt 
		.txt.txt mark set insert "$curpos + $l1 chars "
		.txt.txt see $curpos
		set found 1
		break
		} else {
		set curpos $lpos
		set found 0
			}
	}
} else {
	set curpos [.txt.txt index insert]
	set i $cl
	.txt.txt mark set first $i.0
	while  {$i >= 1} {
		
		set fpos [.txt.txt index first]
		set i [expr $i-1]
		
		set curpos [.txt.txt search $swit -exact $seltxt $curpos $fpos]
		if {$curpos != ""} {
			selection clear .txt.txt
			.txt.txt mark set insert $curpos
			.txt.txt see $curpos
			set found 1
			break
			} else {
				.txt.txt mark set first $i.0
				.txt.txt mark set last "first lineend"
				set curpos [.txt.txt index last]
				set found 0
			}
		
	}
}
}

proc FindSelection {swit} {

global seltxt GotSelection
if {$GotSelection == 0} {
	set seltxt [selection get STRING]
	set GotSelection 1
	} 
FindWord $swit $seltxt
}

proc FindValue {} {

FindPopup
}

proc TagSelection {} {
global seltxt GotSelection
if {$GotSelection == 0} {
	set seltxt [selection get STRING]
	set GotSelection 1
	} 
TagAll 
}

proc ReplaceSelection {swit} {
global repltxt seltxt found
set l1 [string length $seltxt]
FindWord $swit $seltxt
if {$found == 1} {
	.txt.txt delete insert "insert + $l1 chars"
	.txt.txt insert insert $repltxt
	}
}

proc ReplaceAll {} {
global seltxt repltxt
set l1 [string length $seltxt]
set l2 [string length $repltxt]
scan [.txt.txt index end] %d nl
set curpos [.txt.txt index 1.0]
for {set i 1} {$i < $nl} {incr i} {
	.txt.txt mark set last $i.end
	set lpos [.txt.txt index last]
	set curpos [.txt.txt search -forwards -exact $seltxt $curpos $lpos]
	
	if {$curpos != ""} {
		.txt.txt mark set insert $curpos
		.txt.txt delete insert "insert + $l1 chars"
		.txt.txt insert insert $repltxt
		.txt.txt mark set insert "insert + $l2 chars"
		set curpos [.txt.txt index insert]
		} else {
			set curpos $lpos
			}
	}
}

proc TagAll {} {
global seltxt 
set l1 [string length $seltxt]
scan [.txt.txt index end] %d nl
set curpos [.txt.txt index insert]
for {set i 1} {$i < $nl} {incr i} {
	.txt.txt mark set last $i.end
	set lpos [.txt.txt index last]
	set curpos [.txt.txt search -forwards -exact $seltxt $curpos $lpos]
		if {$curpos != ""} {
		.txt.txt mark set insert $curpos
		scan [.txt.txt index "insert + $l1 chars"] %f pos
		.txt.txt tag add $seltxt $curpos $pos
		.txt.txt tag configure $seltxt -background yellow -foreground purple
		.txt.txt mark set insert "insert + $l1 chars"
		set curpos $pos
		} else {
			set curpos $lpos
			}
	}
}

###THEMES
######COLORPROCS
##############################################
# set text widget colors
#######################
 proc tback {} {
    global i
    set color [tk_chooseColor -initialcolor [.txt.txt cget -bg]]
    if {$color != ""} {.txt.txt configure -bg $color}
    set ::txbg $color    
 }
 
 proc tfore {} {
    global i
    set color [tk_chooseColor -initialcolor [.txt.txt cget -fg]]
    if {$color != ""} {.txt.txt configure -fg $color}
    set ::txfg $color    
 }

# set window color
################################

proc winback {} {
	global wbg
    set wbg [tk_chooseColor -initialcolor $::wbg]
    if {$wbg != ""} {tk_setPalette background $wbg}
    set $::wbg $wbg

 }

#set window font color
###################################

proc wintex {} {

	global wtx
    set wtx [tk_chooseColor -initialcolor $::wtx]
    if {$wtx != ""} {tk_setPalette background $::wbg foreground $wtx}
    set $::wtx $wtx

 }

# special character box
# largely borrowed from David "Pa" McClamrock's SuperNotepad
################################################################

global charlist
set charlist [list \
	"¡" "¢" "£" "¤" "¥" \
	"¦" "§" "¨" "©" "ª" \
	"«" "¬" "­" "®" "¯" \
	"°" "±" "²" "³" "´" \
	"µ" "¶" "·" "¸" "¹" \
	"º" "»" "¼" "½" "¾" \
	"¿" "À" "Á" "Â" "Ã" \
	"Ä" "Å" "Æ" "Ç" "È" \
	"É" "Ê" "Ë" "Ì" "Í" \
	"Î" "Ï" "Ð" "Ñ" "Ò" \
	"Ó" "Ô" "Õ" "Ö" "×" \
	"Ø" "Ù" "Ú" "Û" "Ü" \
	"Ý" "Þ" "ß" "à" "á" \
	"â" "ã" "ä" "å" "æ" \
	"ç" "è" "é" "ê" "ë" \
	"ì" "í" "î" "ï" "ñ" \
	"ò" "ó" "ô" "õ" "ö" \
	"÷" "ø"	"ù" "ú" "û" \
	"ü" "ý" "þ" "ÿ"]


# Procedure for finding correct text or entry widget
# and inserting special (or non-special) characters:
########################################################33

proc findwin {char} {
	global foco
	set winclass [winfo class $foco]
	$foco insert insert $char
	if {$winclass == "Text"} {
		$foco edit separator
		}
	after 10 {focus $foco}
}

###########################################################################################
# Procedure for setting up special-character selection box (borrowed from supernotepad by David "Pa" McClamrock)

proc range {start cutoff finish {step 1}} {
	
	# "Step" has to be an integer, and
	# no infinite loops that go nowhere are allowed:
	if {$step == 0 || [string is integer -strict $step] == 0} {
		error "range: Step must be an integer other than zero"
	}
	
	# Does the range include the last number?
	switch $cutoff {
		"to" {set inclu 1}
		"no" {set inclu 0}
		default {
			error "range: Use \"to\" for an inclusive range,\
			or \"no\" for a noninclusive range"
		}
	}
		
	# Is the range ascending or descending (or neither)?
	set ascendo [expr $finish - $start]
	if {$ascendo > -1} {
		set up 1
	} else {
		set up 0
	}
	
	# If range is descending and step is positive but doesn't have a "+" sign,
	# change step to negative:
	if {$up == 0 && $step > 0 && [string first "+" $start] != 0} {
		set step [expr $step * -1]
	}
	
	set ranger [list] ; # Initialize list variable for generated range
	switch "$up $inclu" {
		"1 1" {set op "<=" ; # Ascending, inclusive range}
		"1 0" {set op "<" ; # Ascending, noninclusive range}
		"0 1" {set op ">=" ; # Descending, inclusive range}
		"0 0" {set op ">" ; # Descending, noninclusive range}
	}
	
	# Generate a list containing the specified range of integers:
	for {set i $start} "\$i $op $finish" {incr i $step} {
		lappend ranger $i
	}
	return $ranger
}


set specialbutts [list]

#  This special box was borrowed from Pa McClamrock's Supernotepad.

proc specialbox {} {
	global charlist foco buttlist
	toplevel .spec
	wm title .spec "Special"
	set bigfons -adobe-helvetica-bold-r-normal--14-*-*-*-*-*-*
	set row 0
	set col 0
	foreach c [range 0 no [llength $charlist]] {
		set chartext [lindex $charlist $c]
		grid [button .spec.but($c) -text $chartext -font $bigfons \
			-pady 1 -padx 2 -borderwidth 1] \
			-row $row -column $col -sticky news
			bind .spec.but($c) <Button-1> {
			set butt %W
			set charx [$butt cget -text]
			findwin $charx
		}
		incr col
		if {$col > 4} {
			set col 0
			incr row
		}
	}
		
	grid [button .spec.amp -text "&"] -row $row -column 4 -sticky news
	bind .spec.amp <Button-1> {findwin "&amp;"}
	
	set bigoe_data "
	#define bigoe_width 17
	#define bigoe_height 13
	static unsigned char bigoe_bits[] = {
		0xf8, 0xfe, 0x01, 0xfe, 0xff, 0x01, 0xcf, 0x07, \
		0x00, 0x87, 0x07, 0x00, 0x07, 0x07, 0x00, 0x07, \
		0x3f, 0x00, 0x07, 0x3f, 0x00, 0x07, 0x07, 0x00, \
		0x07, 0x07, 0x00, 0x07, 0x07, 0x00, 0x8e, 0x07, \
		0x00, 0xfc, 0xff, 0x01, 0xf8, 0xfe, 0x01 };"
	image create bitmap bigoe -data $bigoe_data
	grid [button .spec.oebig -image bigoe \
		-pady 1 -padx 2 -borderwidth 1] \
		-row [expr $row+1] -column 0 -sticky news
	bind .spec.oebig <Button-1> {findwin "&#140;"}
	
	set liloe_data "
	#define liloe_width 13
	#define liloe_height 9
	static unsigned char liloe_bits[] = {
		0xbc, 0x07, 0xfe, 0x0f, 0xc3, 0x18, 0xc3, 0x18, \
		0xc3, 0x1f, 0xc3, 0x00, 0xe7, 0x18, 0xfe, 0x0f, \
		0x3c, 0x07 };"
	image create bitmap liloe -data $liloe_data
	grid [button .spec.oelil -image liloe -pady 1 \
		-pady 1 -padx 2 -borderwidth 1] \
		-row [expr $row+1] -column 1 -sticky news
	bind .spec.oelil <Button-1> {findwin "&#156;"}
	
	grid [button .spec.lt -text "<"] \
		-row [expr $row+1] -column 2 -sticky news
	bind .spec.lt <Button-1> {findwin "&lt;"}
	grid [button .spec.gt -text ">"] \
		-row [expr $row+1] -column 3 -sticky news
	bind .spec.gt <Button-1> {findwin "&gt;"}
	grid [button .spec.quot -text "\""] \
		-row [expr $row+1] -column 4 -sticky news
	bind .spec.quot <Button-1> {findwin "&quot;"}
	grid [button .spec.nbsp -text " "] \
		-row [expr $row+2] -column 0 -columnspan 2 -sticky news
	bind .spec.nbsp <Button-1> {findwin "&nbsp;"}
	grid [button .spec.close -text "Close" \
		-command {destroy .spec}] -row [expr $row+2] \
		-column 2 -columnspan 3 -sticky news
	foreach butt [list .spec.oebig .spec.oelil .spec.nbsp .spec.amp \
		.spec.lt .spec.gt .spec.quot .spec.close] {
		$butt configure -pady 1 -padx 2 -borderwidth 1
			
	}
}



# go to line number "

proc gotoline {} {
	set newlineno [.fpop.l3.line get]
	.txt.txt mark set insert $newlineno.0
	.txt.txt see insert
	focus .txt.txt
	set foco .txt.txt
}


# show word count

proc wordcount {} {
	set wordsnow [.txt.txt get 1.0 {end -1c}]
	set wordlist [split $wordsnow]
	set countnow 0
	foreach item $wordlist {
		if {$item ne ""} {
			incr countnow
		}
	}
	toplevel .count
	wm title .count "Word Count"
	tk::label .count.word -text "Current count:"
	tk::label .count.show -text "$countnow words"
	tk::button .count.ok -text "Okay" -command {destroy .count}
	
	pack .count.word -in .count -side top
	pack .count.show -in .count -side top
	pack .count.ok -in .count -side top
}

#############################################
# insertions menu commands

## insert time stamp

proc indate {} {
	if {![info exists date]} {set date " "}
	set date [clock format [clock seconds] -format "%R %p %D"]
	.txt.txt insert insert $date
}

# markdown
# to be inserted in the post.
###################################
proc inlink {} {

toplevel .link
wm title .link "Insert Hyperlink"

frame .link.s
grid [tk::label .link.s.l1 -text "URL:"]\
[tk::entry .link.s.e1 -width 40 -textvariable inurl]
grid [tk::label .link.s.l2 -text "Link text:"]\
[tk::entry .link.s.e2 -width 40 -textvariable ltxt]

pack .link.s -in .link -side left

frame .link.btns

grid [tk::button .link.btns.in -text "Insert link" -command {.txt.txt insert insert "\[$ltxt]\($inurl\)"}]\
[tk::button .link.btns.out -text "Done" -command {destroy .link}]

pack .link.btns -in .link -side left
}

proc ital {} {
toplevel .link
wm title .link "Italics "

frame .link.s
grid [tk::label .link.s.l2 -text "Text:"]\
[tk::entry .link.s.e2 -width 40 -textvariable ltxt]

pack .link.s -in .link -side left

frame .link.btns

grid [tk::button .link.btns.in -text "Insert " -command {.txt.txt insert insert "*$ltxt*"}]\
[tk::button .link.btns.out -text "Done" -command {destroy .link}]

pack .link.btns -in .link -side left
}

proc iboldic {} {
toplevel .link
wm title .link "Bold Italics"

frame .link.s
grid [tk::label .link.s.l2 -text "Text:"]\
[tk::entry .link.s.e2 -width 40 -textvariable ltxt]

pack .link.s -in .link -side left

frame .link.btns

grid [tk::button .link.btns.in -text "Insert" -command {.txt.txt insert insert "***$ltxt***"}]\
[tk::button .link.btns.out -text "Done" -command {destroy .link}]

pack .link.btns -in .link -side left
}

proc bold {} {
toplevel .link
wm title .link "Bold"

frame .link.s
grid [tk::label .link.s.l2 -text "Text:"]\
[tk::entry .link.s.e2 -width 40 -textvariable ltxt]

pack .link.s -in .link -side left

frame .link.btns

grid [tk::button .link.btns.in -text "Insert" -command {.txt.txt insert insert "**$ltxt**"}]\
[tk::button .link.btns.out -text "Done" -command {destroy .link}]

pack .link.btns -in .link -side left
}

proc head1 {} {
toplevel .link
wm title .link "Header 1"

frame .link.s
grid [tk::label .link.s.l2 -text "Text:"]\
[tk::entry .link.s.e2 -width 40 -textvariable ltxt]

pack .link.s -in .link -side left

frame .link.btns

grid [tk::button .link.btns.in -text "Insert" -command {.txt.txt insert insert "#$ltxt\n"}]\
[tk::button .link.btns.out -text "Done" -command {destroy .link}]

pack .link.btns -in .link -side left
}

proc head2 {} {
toplevel .link
wm title .link "Header 2"

frame .link.s
grid [tk::label .link.s.l2 -text "Text:"]\
[tk::entry .link.s.e2 -width 40 -textvariable ltxt]

pack .link.s -in .link -side left

frame .link.btns

grid [tk::button .link.btns.in -text "Insert" -command {.txt.txt insert insert "##$ltxt\n"}]\
[tk::button .link.btns.out -text "Done" -command {destroy .link}]

pack .link.btns -in .link -side left
}

proc head3 {} {
toplevel .link
wm title .link "Header 3"

frame .link.s
grid [tk::label .link.s.l2 -text "Text:"]\
[tk::entry .link.s.e2 -width 40 -textvariable ltxt]

pack .link.s -in .link -side left

frame .link.btns

grid [tk::button .link.btns.in -text "Insert" -command {.txt.txt insert insert "###$ltxt\n"}]\
[tk::button .link.btns.out -text "Done" -command {destroy .link}]

pack .link.btns -in .link -side left
}

proc head4 {} {
toplevel .link
wm title .link "Header 4"

frame .link.s
grid [tk::label .link.s.l2 -text "Text:"]\
[tk::entry .link.s.e2 -width 40 -textvariable ltxt]

pack .link.s -in .link -side left

frame .link.btns

grid [tk::button .link.btns.in -text "Insert" -command {.txt.txt insert insert "####$ltxt\n"}]\
[tk::button .link.btns.out -text "Done" -command {destroy .link}]

pack .link.btns -in .link -side left
}

proc inpic {} {

toplevel .link
wm title .link "Insert Image"

frame .link.s
grid [tk::label .link.s.l1 -text "URL:"]\
[tk::entry .link.s.e1 -width 40 -textvariable inurl]
grid [tk::label .link.s.l2 -text "Text"]\
[tk::entry .link.s.e2 -width 40 -textvariable ltxt]

pack .link.s -in .link -side left

frame .link.btns

grid [tk::button .link.btns.in -text "Insert link" -command {.txt.txt insert insert "!\[$ltxt]\($inurl\)"}]\
[tk::button .link.btns.out -text "Done" -command {destroy .link}]

pack .link.btns -in .link -side left
}


# b'bye (quit procedure)
##################################

proc leave {} {
	if {[.txt.txt edit modified]} {
	set xanswer [tk_messageBox -message "Would you like to save your work?"\
 -title "B'Bye..." -type yesnocancel -icon question]
	if {$xanswer eq "yes"} {
		{file_save} 
		{exit}
				}
	if {$xanswer eq "no"} {exit}
		} else {exit}
}


## clear text widget / close document
#########################################

proc clear {} {
	if {[.txt.txt edit modified]} {
	set xanswer [tk_messageBox -message "Would you like to save your work?"\
 -title "B'Bye..." -type yesnocancel -icon question]
	if {$xanswer eq "yes"} {
	{file_save} 
	{yclear}
		}
	if {$xanswer eq "no"} {yclear}
	}
}

proc yclear {} {
	.txt.txt delete 1.0 end
	.txt.txt edit reset
	.txt.txt edit modified 0
	set ::filename " "
	wm title . "Xpostulate"
}

# open html in browser
###########################################

proc browz {} {
	global brow
	if {$brow != " "} {
	eval exec $::brow $::rurl &
	} else {
	tk_messageBox -message "You have not chosen a browser.\nLet's set the browser now." -type ok -title "Set browser"
	set brow [tk_getOpenFile -filetypes $::file_types]
	{browz}
	}
}


proc sapro {} {
	set novar "cows"
	set header "# treetcl conf" 
   	set filename ~/.treetcl.conf
   	set fileid [open $filename w]
   	puts $fileid $header
   	foreach var $::allvars {puts $fileid [list set $var [set ::$var]]}
   	close $fileid
   	
   	 tk_messageBox -message "Preferences saved" 
} 

proc setbro {} {
set filetypes " "
set ::brow [tk_getOpenFile -filetypes $filetypes -initialdir "/usr/bin"]
}


######################
#  global preferences


proc prefs {} {

toplevel .pref

wm title .pref "treetcl preferences"


grid [tk::label .pref.lbl -text "Set global preferences here"]



grid [tk::button .pref.fc -text "Font Color" -command {tfore}]\
[tk::button .pref.bc -text "Text Background" -command {tback}]\
[tk::button .pref.wc -text "Window Color" -command {winback}]\
[tk::button .pref.wt -text "Window Text" -command {wintex}]


grid [tk::button .pref.bro -text "Set Browser" -command {setbro}]\
[tk::entry .pref.br0z -textvariable brow]

grid [tk::label .pref.b1o -text "Tree:"]

grid [tk::label .pref.b1un -text "Tree URL:"]\
[tk::entry .pref.b1nome -textvariable tree]\
[tk::label .pref.b1p -text "API Token"]\
[tk::entry .pref.b1pw -show * -textvariable apitoken]

grid [tk::button .pref.sv -text "Save Preferences" -command sapro]\
[tk::button .pref.ok -text "OK" -command {destroy .pref}]


}


################
# post to libertree

proc tpost {} {
    
set update [.txt.txt get 1.0 {end -1c}]
	set orchard "$::tree/api/v1/posts/create?token=$::apitoken"
	set myquery [::http::formatQuery "text" "$update" "source" "tazman\'s tree tickler"]
	set token [::http::geturl $orchard -query $myquery]
	if { $token == "::http::1" } { 
		set response "tree planted!"
		} else { 
		set response "uh oh..."
	}
	toplevel .resp
	wm title .resp "Response"
	tk::message .resp.msg -width 250 -text "Tree says: $token\n$response"
	tk::button .resp.ok -text "OK" -command {destroy .resp}
	pack .resp.msg -in .resp
	pack .resp.ok -in .resp
	
}


#####################################
# Help dialog
proc help {} {
toplevel .help
wm title .help "Help!"

frame .help.bt
grid [tk::button .help.bt.out -text "Close" -command {destroy .help}]

frame .help.t

text .help.t.inf -width 30 -height 5
.help.t.inf insert end "There is no help.\nOut here in the forest,\nwe learn to be self-sufficient.\nDeal with it!\n\nhttp://wiki.tazmandevil.info"

pack .help.bt -in .help -side top
pack .help.t -in .help -side top
pack .help.t.inf -in .help.t -fill x

}


#############################################################################
# This program was written by tazmand deville
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#########
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#########
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
############################################################################
