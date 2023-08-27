#!/usr/bin/env sh

# Set this to the directory containing all of Skyrim's files.
skyrimDirectory="/home/lukas/.local/share/Steam/steamapps/common/Skyrim"
skyrimSteamAppID=72850

# Gum stylings
export GUM_CHOOSE_HEADER_FOREGROUND="9"
export GUM_CHOOSE_CURSOR_FOREGROUND="4"
export GUM_CHOOSE_HEADER_BORDER="rounded"
export GUM_CONFIRM_SELECTED_BACKGROUND="4"
export GUM_CONFIRM_SELECTED_BOLD="true"

func_launch_game () {
	./gum confirm "Launch Game?" && ./gum spin steam steam://rungameid/$skyrimSteamAppID --spinner="line" --title="Loading..." && exit || func_main_menu
}

func_main_menu () {
	case $(./gum choose "Launch Skyrim!" "Change applyed modlist" "Exit" --header="Skyrim Mod Manager" --cursor=" >> ") in
		"Launch Skyrim!")
			func_launch_game
			;;
		"Change applied modlist")
                	printf "what list"
                	;;
        	"Exit") 
                	exit 
                	;;
	esac
}



# Checks if gum is installed or if binary was previously downloaded
if [[ $(whereis gum) == "gum:" ]] && [[ $(ls | grep -w -o gum) == "" ]]
	then
	printf "Fetching dependency..."
	curl -OLs https://github.com/charmbracelet/gum/releases/download/v0.11.0/gum_0.11.0_Linux_x86_64.tar.gz
	tar -xzf gum_0.11.0_Linux_x86_64.tar.gz gum
	printf " Done!\n"
fi

func_main_menu
