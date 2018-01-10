FROM ubuntu

RUN apt-get update -qq \
  && apt-get install -y --no-install-recommends \
  wget \
  ca-certificates \
  lib32gcc1

RUN useradd -m steam
WORKDIR /home/steam
USER steam

RUN wget -nv https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
RUN tar -xvzf steamcmd_linux.tar.gz

COPY install .
RUN ./steamcmd.sh +runscript install

RUN mkdir -p ~/.steam && ln -s ~/linux32 ~/.steam/sdk32
WORKDIR /home/steam/cs16

COPY *.cfg cstrike/

EXPOSE 27015/tcp
EXPOSE 27015/udp

CMD ./hlds_run -game cstrike -strictportbind -autoupdate -ip 0.0.0.0 +sv_lan 1 +map aim_map -maxplayers 32
