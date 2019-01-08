#!/usr/bin/env bash

zip -9 -r Space.love .

cp Space.love /love-android-sdl2/app/src/main/assets/game.love
cd /love-android-sdl2
./gradlew build
cp /love-android-sdl2/app/build/outputs/apk/debug/app-debug.apk /app
cd /app

rm Space.love
