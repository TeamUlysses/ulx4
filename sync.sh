#!/bin/sh

rm -rf /Volumes/C/srcds/steamapps/common/GarrysModDS/garrysmod/addons/ulx
rm -rf /Volumes/C/srcds/steamapps/common/GarrysModDS/garrysmod/addons/ulib
rm -rf /Volumes/C/srcds/steamapps/common/GarrysModDS/garrysmod/addons/utime
make lua
rsync -a --del --exclude=.git ~/Downloads/ulx4 /Volumes/C/srcds/steamapps/common/GarrysModDS/garrysmod/addons
