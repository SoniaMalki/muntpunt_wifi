#!/bin/bash
# Script to install Wifi tray

SETUP_DIR=$(dirname "$0")
DESKTOP_PATH_TRAY=$HOME"/.config/autostart"
DESKTOP_FILE_TRAY="wifi_muntpunt_tray.desktop"
DESKTOP_FILE_PATH_TRAY=$DESKTOP_PATH_TRAY"/"$DESKTOP_FILE_TRAY

mkdir -p $DESKTOP_PATH_TRAY

cp $SETUP_DIR/$DESKTOP$DESKTOP_FILE_TRAY $DESKTOP_FILE_PATH_TRAY

echo "Installed at launch successfully for user $USER"