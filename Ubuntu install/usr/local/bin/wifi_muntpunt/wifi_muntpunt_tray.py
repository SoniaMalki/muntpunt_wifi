#!/usr/bin/python
import os

import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk as gtk, AppIndicator3 as appindicator
def main():
  indicator = appindicator.Indicator.new("customtray", os.path.abspath("/usr/share/icons/hicolor/128x128/apps/wifi_muntpunt_icon.png"), appindicator.IndicatorCategory.APPLICATION_STATUS)
  indicator.set_status(appindicator.IndicatorStatus.ACTIVE)
  indicator.set_menu(menu())
  gtk.main()

def menu():
  menu = gtk.Menu()

  command_one = gtk.MenuItem('Connect Wifi')
  command_one.connect('activate', wifi)
  menu.append(command_one)
  
  exittray = gtk.MenuItem('Exit Tray')
  exittray.connect('activate', quit)
  menu.append(exittray)

  menu.show_all()
  return menu


def wifi(_):
  os.system("gnome-terminal -- /usr/local/bin/wifi_muntpunt/wifi_muntpunt_bash_script_connect.sh")

if __name__ == "__main__":
  main()
