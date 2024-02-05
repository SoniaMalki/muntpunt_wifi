#!/bin/bash
#Script to install Wifi Muntpunt on Ubuntu

COLUMNS=70
SEP_CHAR="#"
LINE_SEP=""
for (( c=1; c<=$COLUMNS; c++ )); do LINE_SEP=$LINE_SEP$SEP_CHAR; done
#LINE_SEP=$LINE_SEP"\n"


# ========= IMPORTANT INSTALLATION VARIABLES ==========
SETUP_DIR=$(dirname "$0")
CREDENTIAL_FILE="credentials.txt"
PYTHON_SCRIPT_CONNECT="wifi_muntpunt_connect_code.py"
PYTHON_SCRIPT_TRAY="wifi_muntpunt_tray.py"
BASH_SCRIPT_CONNECT="wifi_muntpunt_bash_script_connect.sh"
DESKTOP_FILE_CONNECT="wifi_muntpunt.desktop"
BASH_SCRIPT_TRAY="wifi_muntpunt_tray_bash_script.sh"
DESKTOP_FILE_TRAY="wifi_muntpunt_tray.desktop"
ICON_FILE="wifi_muntpunt_icon.png"
INSTALL_PATH="/usr/bin/wifi_muntpunt"
DESKTOP_PATH=$HOME"/Bureau/"
DESKTOP_PATH_TRAY=$HOME"/.config/autostart"
DESKTOP_FILE_PATH=$DESKTOP_PATH"/"$DESKTOP_FILE_CONNECT
DESKTOP_FILE_PATH_TRAY=$DESKTOP_PATH_TRAY"/"$DESKTOP_FILE_TRAY
DEFAULT_OPTION=1

# ======== WELCOME MESSAGE ==========
echo -e $LINE_SEP
echo "Welcome to this quick installation script. Please follow the instructions."
echo "If you wish to change your username or password, you can relaunch this script."
echo -e $LINE_SEP

# ======== INSTALLATION OPTIONS ==========
echo "Please choose the correct option"
echo "1 - By default: Install the program & enter the credentials"
echo "2 - Only install the program, keep the credentials as before"
echo "3 - Reenter the credentials without installating" 
echo "4 - Cancel"
read -s -n 1 OPTION 
echo -e $LINE_SEP

if ! [[ $OPTION =~ ^(1|2|3|4) ]]
then
	OPTION=$DEFAULT_OPTION
fi

if [ $OPTION -ne 4 ] 
then 

# ======== INSTALLATION QUESTIONS ==========
	if [ $OPTION -eq 1 ] || [ $OPTION -eq 3 ]
	then
		echo "Please enter your Wifi username (First name followed by a space then last name)"
		read username
		echo "Please enter your password (your national ID number or number on Muntpunt card)"
		read password

		echo -e "username="$username > $SETUP_DIR/$CREDENTIAL_FILE
		echo -e "password="$password >> $SETUP_DIR/$CREDENTIAL_FILE
		echo -e $LINE_SEP
	fi
#  ======== PYTHON INSTALLATION ==========
	if [ $OPTION -eq 1 ] || [ $OPTION -eq 2 ]
	then
		echo -ne '                          (0%)\r'
		sudo apt-get install -y --quiet=3 python3
		echo -ne '-------------             (50%)\r'
		sudo apt install -y --quiet=3 python3-pip
		echo -ne '********************      (75%)\r'
		sudo apt install -y --quiet=3 gir1.2-appindicator3-0.1
		echo -ne '********************      (80%)\r'
		pip3 install requests --quiet
		echo -ne '-----------------------   (90%)\r'
		pip3 install chardet --quiet
		echo -ne '**************************(100%)\r'
		sleep 0.05
	fi

	# ======== FILE MOVING ==========
	sudo mkdir -p /usr/bin/wifi_muntpunt
	mkdir -p $HOME/.icons/
	if [ $OPTION -eq 1 ] || [ $OPTION -eq 3 ]
	then
		sudo mv $SETUP_DIR"/"$CREDENTIAL_FILE $INSTALL_PATH
	fi
	sudo cp $SETUP_DIR"/"$PYTHON_SCRIPT_CONNECT $INSTALL_PATH
	sudo cp $SETUP_DIR"/"$PYTHON_SCRIPT_TRAY $INSTALL_PATH
	sudo cp $SETUP_DIR"/"$BASH_SCRIPT_CONNECT $INSTALL_PATH
	sudo cp $SETUP_DIR"/"$BASH_SCRIPT_TRAY $INSTALL_PATH
	sudo cp $SETUP_DIR"/"$ICON_FILE $INSTALL_PATH

	cp $SETUP_DIR"/"$ICON_FILE ~/.icons/
	cp $SETUP_DIR"/"$DESKTOP_FILE_CONNECT $DESKTOP_PATH
	cp $SETUP_DIR"/"$DESKTOP_FILE_TRAY $DESKTOP_FILE_PATH_TRAY

	# ======== FILES PERMISSIONS ==========
	gio set $DESKTOP_FILE_PATH metadata::trusted true
	gio set $DESKTOP_FILE_PATH_TRAY metadata::trusted true

	sudo chmod +x $INSTALL_PATH"/"$BASH_SCRIPT_CONNECT
	sudo chmod +x $INSTALL_PATH"/"$BASH_SCRIPT_TRAY
	sudo chmod a+x $DESKTOP_FILE_PATH
	sudo chmod a+x $DESKTOP_FILE_PATH_TRAY

fi
