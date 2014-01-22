#!/bin/bash

##########################################################3
# This script will install tree.tcl on a gnu/linux system.
# If you're using BSD or Mac OS, I believe it should also work fine.
##########################################################3

name=$(whoami)

if [ != "$HOME/bin/" ]; then
	mkdir $HOME/bin/
	$PATH=$PATH:/$HOME/bin/
	export PATH
fi

echo "Installing tree.tcl..."

echo "Creating config files..."

cp treetcl.conf $HOME/.treetcl.conf

echo "Moving files, setting permissions..."

cp tree.tcl $HOME/bin/tree.tcl
chmod +x $HOME/bin/tree.tcl

echo "Installation complete!"
echo "To run tree.tcl, in terminal type tree.tcl, or make an icon/menu item/short cut to /home/$name/bin/tree.tcl"
echo "Don't forget to edit preferences before trying to post for the first time! "
echo "Enjoy!"

exit
