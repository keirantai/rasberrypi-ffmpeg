#!/bin/bash
#
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Prepare folders
mkdir -p $DIR/tmp
mkdir -p $DIR/packages/

# Prepare for compilation
sudo apt-get install git autoconf automake build-essential checkinstall libass-dev libgpac-dev libmp3lame-dev \
libopencore-amrnb-dev libopencore-amrwb-dev librtmp-dev libspeex-dev libtheora-dev libtool libvorbis-dev \
pkg-config texi2html zlib1g-dev yasm

# Compile fdk-aac library (used by ffmpeg)
cd $DIR/tmp
git clone --depth 1 git://github.com/mstorsjo/fdk-aac.git
cd fdk-aac
autoreconf -fiv
./configure --disable-shared
make
sudo checkinstall --pkgname=fdk-aac --pkgversion="$(date +%Y%m%d%H%M)-git" --backup=no --deldoc=yes --fstrans=no --default
mv fdk-aac_*-git-1_armhf.deb $DIR/packages/

# Compile x264 library (used by ffmpeg)
cd $DIR/tmp
git clone --depth 1 git://git.videolan.org/x264.git
cd x264
./configure --enable-static
make
sudo checkinstall --pkgname=x264 --pkgversion="$(date +%Y%m%d%H%M)-git" --backup=no --deldoc=yes --fstrans=no --default
mv x264_*-git-1_armhf.deb $DIR/packages/

# Compile ffmpeg with libfdk capability
cd $DIR/tmp
git clone --depth 1 git://source.ffmpeg.org/ffmpeg
cd ffmpeg
./configure --enable-gpl --enable-libass --enable-libfdk-aac --enable-libmp3lame --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libspeex --enable-librtmp --enable-libtheora --enable-libvorbis --enable-nonfree --enable-version3
make
sudo checkinstall --pkgname=ffmpeg --pkgversion="7:$(date +%Y%m%d%H%M)-git" --backup=no --deldoc=yes --fstrans=no --default
mv ffmpeg_*-git-1_armhf.deb $DIR/packages/

# clean up
cd; rm -Rf $DIR/tmp/{fdk-aac,ffmpeg}