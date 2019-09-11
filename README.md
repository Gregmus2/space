## External libs for IDEA
clone https://github.com/EmmyLua/Emmy-love-api and attach to IDEA 
    as external library for autocompletes
    
## Builds
Windows, Mac: `docker-compose up` \
Android: `cd android && docker-compose up`

## Luarocks
If you want to install lua dependencies simply, you have to install luarocks.
```shell script
sudo apt install -y lua5.1 liblua5.1-dev && \
wget https://luarocks.org/releases/luarocks-3.2.0.tar.gz && \
tar zxpf luarocks-3.2.0.tar.gz && rm luarocks-3.2.0.tar.gz && \
cd luarocks-3.2.0 && ./configure --lua-version=5.1 && \
make build && sudo make install
```

## Debug
https://emmylua.github.io/run.html#get-ready
maybe you must install mobdebug with luarocks

- put `require("debug.mobdebug").start()` in start of code (f.e. in love.load)
- create idea configuration for moddebug and start it
- start app

## Luacheck
First install luacheck with luarocks

Next go to `File | Settings | Languages & Frameworks | EmmyLua | LuaCheck` and fill settings:
* LuaCheck: your path to luacheck (by default: `/usr/local/bin/luacheck`)
* CommandLine: `--stds=lua51c+love` 