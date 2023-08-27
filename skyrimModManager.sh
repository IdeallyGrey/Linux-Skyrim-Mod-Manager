#!/usr/bin/env sh

# Set this to the directory containing all of Skyrim's files.
skyrimDirectory="/home/lukas/.local/share/Steam/steamapps/common/Skyrim"
skyrimSteamAppID=72850

# Gum stylings
export GUM_CHOOSE_HEADER_FOREGROUND="9"
export GUM_CHOOSE_CURSOR_FOREGROUND="4"
export GUM_CONFIRM_SELECTED_BACKGROUND="4"
export GUM_CONFIRM_SELECTED_BOLD="true"

func_launch_game () {
	./gum confirm "Launch Game?" && ./gum spin steam steam://rungameid/$skyrimSteamAppID --spinner="line" --title="Loading..." && exit || func_main_menu
}

func_modlist_options_menu () {
	case $(./gum choose "Apply new modlist(s)" "Remove current modlist" "Back to main menu" --header="Modlists" --cursor=" >> ") in 
		"Apply new modlist")
			printf "Applying new modlist"
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
	case $(./gum choose "Launch Skyrim!" "Change applied modlist" "Exit" --header="Skyrim Mod Manager" --header.border="rounded" --cursor=" >> ") in
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

# Checks if gum is installed or if binary was previously downloaded
if [[ $(whereis gum) == "gum:" ]] && [[ $(ls | grep -w -o gum) == "" ]]
	then
	printf "Fetching dependency..."
	curl -OLs https://github.com/charmbracelet/gum/releases/download/v0.11.0/gum_0.11.0_Linux_x86_64.tar.gz
	tar -xzf gum_0.11.0_Linux_x86_64.tar.gz gum
	printf " Done!\n"
fi

func_main_menu
