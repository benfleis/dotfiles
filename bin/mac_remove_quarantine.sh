#!/bin/sh

# stop asking if this app is ok when d/l'd from internet
sudo xattr -d com.apple.quarantine $@
