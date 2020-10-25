#!/usr/bin/env bash
# Should be execute in graphical env

# Enable Breeze-Dark in plasma 
lookandfeeltool --apply org.kde.breezedark.desktop

# Disable auto screenlocking
kwriteconfig5 --file ~/.config/kscreenlockerrc --group Daemon --key Autolock --type bool false
kwriteconfig5 --file ~/.config/kscreenlockerrc --group Daemon --key LockOnResume --type bool false


