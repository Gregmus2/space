#!/usr/bin/env bash

zip -9 -r Space.love .
cat /love-win/love-11.2.0-win64/love.exe Space.love > Space.exe
mv Space.exe /love-win/dist
zip -j -r Space.zip /love-win/dist
chmod 777 -R Space.zip
rm Space.love