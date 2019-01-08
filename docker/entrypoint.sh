#!/usr/bin/env bash

zip -9 -r Space.love .
cat /love-win/love-11.2.0-win64/love.exe Space.love > Space.exe
mv Space.exe /love-win/dist
zip -j -r Space_win.zip /love-win/dist
chmod 777 -R Space_win.zip

cp Space.love /love-mac/Space.app/Contents/Resources/
zip -y -r Space_mac.zip /love-mac/Space.app
chmod 777 -R Space_mac.zip

rm Space.love
