#!/usr/bin/env sh

# Set this to the directory containing all of Skyrim's files.
skyrimDirectory="/home/lukas/.local/share/Steam/steamapps/common/Skyrim"
skyrimSteamAppID=72850

# Gum stylings
export GUM_CHOOSE_HEADER_FOREGROUND="9"
export GUM_CHOOSE_CURSOR_FOREGROUND="4"
export GUM_CONFIRM_SELECTED_BACKGROUND="4"
export GUM_CONFIRM_SELECTED_BOLD="true"


func_apply_modlist_menu () {
	modlistToApply=$(./gum/gum choose $(ls ./modlists | grep -v FORMAT.md))
	
}

func_launch_game () {
	./gum/gum confirm "Launch Game?" && ./gum/gum spin steam steam://rungameid/$skyrimSteamAppID --spinner="line" --title="Loading..." && exit || func_main_menu
}

func_modlist_options_menu () {
	case $(./gum/gum choose "Apply new modlist(s)" "Remove current modlist" "Back to main menu" --header="Modlists" --cursor=" >> ") in 
		"Apply new modlist(s)")
			func_apply_modlist_menu
			;;
		"Remove current modlist(s)")
			printf "Removing modlist"
			;;
		"Back to main menu")
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


# Checks if active directory is that which contains the manager.
# For now, there is no way to be sure of the directory that the script is installed in.
if [[ $(ls | grep -w -o skyrimModManager.sh) == "" ]]
	then
	printf "Error: Must be in same directory as the script!\n"
	exit
fi



func_main_menu

