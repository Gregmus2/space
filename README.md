## External libs for IDEA
clone https://github.com/EmmyLua/Emmy-love-api and attach to IDEA 
    as external library for autocompletes
    
## Builds
Windows, Mac: `docker-compose up` \
Android: `cd android && docker-compose up`

## Debug
https://emmylua.github.io/run.html#get-ready
maybe you must install mobdebug with luarocks

- put `require("debug.mobdebug").start()` in start of code (f.e. in love.load)
- create idea configuration for moddebug and start it
- start app