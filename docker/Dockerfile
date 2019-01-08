FROM debian

RUN apt-get update && apt-get install -y zip wget

RUN wget https://bitbucket.org/rude/love/downloads/love-11.2-win64.zip
RUN mkdir /love-win && unzip love-11.2-win64.zip -d /love-win && rm love-11.2-win64.zip
RUN mkdir /love-win/dist && cp /love-win/love-11.2.0-win64/* /love-win/dist
RUN cd /love-win/dist && rm readme.txt love.ico love.exe lovec.exe game.ico changes.txt

RUN cd /
RUN wget https://bitbucket.org/rude/love/downloads/love-11.2-macos.zip
RUN mkdir /love-mac && unzip love-11.2-macos.zip -d /love-mac && rm love-11.2-macos.zip
RUN mv /love-mac/love.app /love-mac/Space.app
COPY Info.plist /love-mac/Space.app/Contents/Info.plist

WORKDIR /app

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT /entrypoint.sh