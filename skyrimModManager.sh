#!/usr/bin/env sh

# Set this to the directory containing all of Skyrim's files.
skyrimDirectory="/home/lukas/temp/Skyrim"
skyrimSteamAppID=72850

# Gum stylings
export GUM_CHOOSE_HEADER_FOREGROUND="9"
export GUM_CHOOSE_CURSOR_FOREGROUND="4"
export GUM_CONFIRM_SELECTED_BACKGROUND="4"
export GUM_CONFIRM_SELECTED_BOLD="true"
export GUM_SPIN_SPINNER="line"

func_remove_modlist () {
	a=$(pwd)
	cd $skyrimDirectory/Data/
	find [a-z]* -maxdepth 0
	$a/gum/gum confirm "Remove these files?" && rm -rf $(find [a-z]* -maxdepth 0) && $a/gum/gum style "All modlists have been removed." --foreground="11" || $a/gum/gum style "Modlist removal was canceled." --foreground="11"
	cd $a
	func_main_menu
}

func_apply_modlist_menu () {
	modlistToApply=$(./gum/gum choose $(ls ./modlists | grep -v FORMAT.md) "=Back=")
	if [[ $modlistToApply == "=Back=" ]]
		then
		func_modlist_options_menu
		exit
	fi
	# Checks to be sure that the selected modlist actually exists, should prevent manager from taking action when it shouldn't (ie: user ctrl+c's while in the selection menu).
	if [[ $(ls ./modlists | grep -w $modlistToApply) == "" ]]
		then
		printf "Error, selected item not in directory.\n"
		exit
	fi	

	mkdir ./modlists/temp
	cp -r ./modlists/$modlistToApply/* modlists/temp/
	cd ./modlists/temp
	# Replaces spaces with underscores, prefixes "tagged_" to every file (not directories)
	for i in *\ *; do mv "$i" "${i// /_}"; done
	for i in $(ls -p | grep -v /); do mv "$i" "tagged_$i"; done
	cd ../..
	rsync -a ./modlists/temp/* $skyrimDirectory/Data/
	rm -rf ./modlists/temp
	./gum/gum style "Modlist $modlistToApply has been applied." --foreground="11"
	./gum/gum spin --title="" --spinner="dot" sleep 4
	func_main_menu
}

func_launch_game () {
	./gum/gum confirm "Launch Game?" && ./gum/gum spin steam steam://rungameid/$skyrimSteamAppID --title="Stealing sweet-rolls..." && exit || func_main_menu
}

func_modlist_options_menu () {
	case $(./gum/gum choose "Apply new modlist" "Remove current modlist(s)" "Back" --header="Modlists" --cursor=" >> ") in 
		"Apply new modlist")
			func_apply_modlist_menu
			;;
		"Remove current modlist(s)")
			func_remove_modlist
			;;
		"Back")
			func_main_menu
			;;
	esac
}

func_main_menu () {
	case $(./gum/gum choose "Launch Skyrim!" "Change applied modlist" "Exit" --header="Skyrim Mod Manager" --header.border="rounded" --cursor=" >> ") in
		"Launch Skyrim!")
			func_launch_game
			;;
		"Change applied modlist")
                	func_modlist_options_menu
                	;;
        	"Exit") 
                	exit 
                	;;
	esac
}


# Pre-flight checklist

# Checks if active directory is that which contains the manager.
# For now, there is no way to be sure of the directory that the script is installed in.
if [[ $(ls | grep -w -o skyrimModManager.sh) == "" ]]
	then
	printf "Error: Must be in same directory as the script!\n"
	exit
fi
#Checks if a "temp" subdirectory exists, since it is used in the modlist application process
if [[ $(ls ./modlists | grep -w -o "temp") != "" ]]
	then
	printf "Error: a subdirectory in modlists/ called \"temp\" exists, please remove it and try again.\n"
	exit
fi

func_main_menu

