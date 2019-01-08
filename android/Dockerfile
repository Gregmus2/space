FROM debian

RUN apt-get update && apt-get install -y zip wget git openjdk-8-jdk make file

RUN git clone https://bitbucket.org/MartinFelis/love-android-sdl2
RUN mkdir -p love-android-sdl2/app/src/main/assets
RUN wget https://dl.google.com/android/archives/android-sdk-linux_x86-1.6_r1.tgz
RUN mkdir android
RUN tar xvzf android-sdk-linux_x86-1.6_r1.tgz -C /android
RUN wget https://dl.google.com/android/repository/android-ndk-r14b-linux-x86_64.zip
RUN unzip android-ndk-r14b-linux-x86_64.zip -d android
COPY licenses /android/android-sdk-linux_x86-1.6_r1/licenses
COPY local.properties /love-android-sdl2
COPY gradle-wrapper.properties /love-android-sdl2/gradle/wrapper
COPY build.gradle /love-android-sdl2

RUN cd /love-android-sdl2 && ./gradlew build

WORKDIR /app

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT /entrypoint.sh