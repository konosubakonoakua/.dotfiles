#TODO: Implement install functionality

backup_gdbinit() {
	# Backup gdbinit if any
	if [ -f "${HOME}/.gdbinit" ]; then
		mv "${HOME}/.gdbinit" "${HOME}/.gdbinit.old"
		return 0
	fi
	return 1
}

manage_gdb-dashboard() {
	case "$2" in
	update)
		echo "Updating $1 ..."
		backup_gdbinit
		wget -P ~ https://git.io/.gdbinit
		;;
	install)
		echo "Installing $1 (https://github.com/cyrus-and/gdb-dashboard/wiki)"
		wget -P ~ https://git.io/.gdbinit
		pip3 install pygments
		;;
	uninstall)
		backup_gdbinit
		echo "$1 uninstalled"
		;;
	*)
		echo "Target $2 not supported!!!!!"
		echo "only [ install | uninstall | update ] supported"
		return 1
		;;
	esac

	return 0
}

download_gef() {
	branch="main"

	# Get the hash of the commit
	ref=$(curl --silent https://api.github.com/repos/hugsy/gef/git/ref/heads/${branch} | grep '"sha"' | tr -s ' ' | cut -d ' ' -f 3 | tr -d "," | tr -d '"')

	# Download the file
	curl --silent --location --output "${HOME}/.gdbinit-gef.py" "https://github.com/hugsy/gef/raw/${branch}/gef.py"

	[ ! "$?" -eq "0" ] && echo "Download fialed: $?" && return 1

	# Create the new gdbinit
	echo "source ~/.gdbinit-gef.py" >~/.gdbinit

	echo "Downloaded"
	return 0
}

manage_gef() {
	case "$2" in
	install)
		echo "Installing $1 (https://hugsy.github.io/gef)"
		backup_gdbinit
		download_gef
		;;
	extras)
		echo "gef extras installing..."
		bash -c "$(wget https://github.com/hugsy/gef/raw/main/scripts/gef-extras.sh -O -)"
		;;
	update)
		if [ ! -f ~/.gdbinit-gef.py ]; then
			echo "gef not installed!"
		else
			echo "gef updating..."
			backup_gdbinit
			echo "source ~/.gdbinit-gef.py" >~/.gdbinit
			python3 ~/.gdbinit-gef.py --update
		fi
		;;
	uninstall)
		cat "# source ~/.gdbinit-gef.py" >~/.gdbinit
		rm -f ~/gdbinit-gef.py ~/.gef.rc
		echo "gef uninstalled!"
		;;
	*)
		echo "Target $2 not supported!!!!!"
		echo "only [ install | uninstall | update | extras] supported"
		return 1
		;;
	esac

	return 0
}

manage_gdbgui() {
	case "$2" in
	install)
		echo "Installing $1 (https://hugsy.github.io/gef)"
		python3 -m pip install --user pipx
		python3 -m userpath append ~/.local/bin
		pipx install gdbgui
		[ ! "$?" -eq "0" ] && echo "Install fialed: $?" && return 1
		echo "Installed."
		;;
	uninstall)
		echo "gef extras installing..."
		pipx uninstall gdbgui
		[ ! "$?" -eq "0" ] && echo "Uninstall fialed: $?" && return 1
		echo "Uninstalled."
		;;
	update)
		echo "gef updating..."
		pipx upgrade gdbgui
		[ ! "$?" -eq "0" ] && echo "Updated fialed: $?" && return 1
		echo "Updated."
		;;
	*)
		echo "Target $2 not supported!!!!!"
		echo "only [ install | uninstall | update ] supported"
		return 1
		;;
	esac
	return 0
}

case "$1" in
gdb-dashboard)
	manage_gdb-dashboard $@
	;;
gef)
	manage_gef $@
	;;
gdbgui)
	manage_gdbgui $@
	;;
*)
	echo "Target $1 not supported!!!!!"
	echo "only [ gdb-dashboard | gef | gdbgui ] supported"
	;;
esac
