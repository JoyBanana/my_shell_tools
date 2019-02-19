#!/bin/bash
#-----------------------------------------
#des:install ffmpeg on Ubuntu
#ffmpeg -i source.mp4 -c:v libx264 -ar 22050 -crf 28 destinationfile.flv
#-----------------------------------------
apt install pkg-config -y
apt install yasm
apt install git -y
add-apt-repository ppa:djcj/hybrid
apt-get update
apt-get install ffmpeg -y
git clone git://git.videolan.org/x264.git
cd x264
./configure --enable-shared --enable-static --disable-asm
make
make install
cd ..
wget https://cfhcable.dl.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz
tar -zxvf lame-3.100.tar.gz
cd lame-3.100/
./configure --enable-shared --enable-static
make
make install
echo "/usr/local/lib" >> /etc/ld.so.conf
ldconfig
