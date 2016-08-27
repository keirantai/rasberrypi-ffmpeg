#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
INTERACTIVE=false
if [ "$1" == "-i" ]; then
	INTERACTIVE=true
fi

# Prepare folders
mkdir -p $DIR/tmp
mkdir -p $DIR/packages/

if $INTERACTIVE; then
	echo -n "Do you want to install required packages for compilation? [y|n] "
	read CONT
	if [ "$CONT" != "y" ]; then
		exit 0
	fi
fi
# Prepare for compilation
sudo apt-get install -y git autoconf automake build-essential checkinstall libass-dev libgpac-dev libmp3lame-dev \
libopencore-amrnb-dev libopencore-amrwb-dev librtmp-dev libspeex-dev libtheora-dev libtool libvorbis-dev \
pkg-config texi2html zlib1g-dev yasm

if $INTERACTIVE; then
	echo -n "Do you want to compile fdk-acc to package? [y|n] "
	read CONT
	if [ "$CONT" != "y" ]; then
		exit 0
	fi
fi
# Compile fdk-aac library (used by ffmpeg)
cd $DIR/tmp
git clone --depth 1 git://github.com/mstorsjo/fdk-aac.git
cd fdk-aac
autoreconf -fiv
./configure --disable-shared
make
sudo checkinstall --pkgname=fdk-aac --pkgversion="$(date +%Y%m%d%H%M)-git" --backup=no --deldoc=yes --fstrans=no --default
mv fdk-aac_*-git-1_armhf.deb $DIR/packages/

if $INTERACTIVE; then
	echo -n "Do you want to install fdk-acc package? [y|n] "
	read CONT
	if [ "$CONT" != "y" ]; then
		exit 0
	fi
fi
# install the compiled fdk-aac package
dpkg -i $DIR/packages/fdk-aac_*-git-1_armhf.deb

if $INTERACTIVE; then
	echo -n "Do you want to compile x264 to package? [y|n] "
	read CONT
	if [ "$CONT" != "y" ]; then
		exit 0
	fi
fi
# Compile x264 library (used by ffmpeg)
cd $DIR/tmp
git clone --depth 1 git://git.videolan.org/x264.git
cd x264
./configure --enable-static
make
sudo checkinstall --pkgname=x264 --pkgversion="$(date +%Y%m%d%H%M)-git" --backup=no --deldoc=yes --fstrans=no --default
mv x264_*-git-1_armhf.deb $DIR/packages/

if $INTERACTIVE; then
	echo -n "Do you want to install x264 package? [y|n] "
	read CONT
	if [ "$CONT" != "y" ]; then
		exit 0
	fi
fi
# install the compiled fdk-aac package
dpkg -i $DIR/packages/x264_*-git-1_armhf.deb

if $INTERACTIVE; then
	echo -n "Do you want to compile ffmpeg to package? [y|n] "
	read CONT
	if [ "$CONT" != "y" ]; then
		exit 0
	fi
fi
# Compile ffmpeg with libfdk capability
cd $DIR/tmp
git clone --depth 1 git://source.ffmpeg.org/ffmpeg
cd ffmpeg
./configure --enable-gpl --enable-libass --enable-libfdk-aac --enable-libmp3lame --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libspeex --enable-librtmp --enable-libtheora --enable-libvorbis --enable-nonfree --enable-version3
make
sudo checkinstall --pkgname=ffmpeg --pkgversion="7:$(date +%Y%m%d%H%M)-git" --backup=no --deldoc=yes --fstrans=no --default
mv ffmpeg_*-git-1_armhf.deb $DIR/packages/

if $INTERACTIVE; then
	echo -n "Do you want to install ffmpeg package? [y|n] "
	read CONT
	if [ "$CONT" != "y" ]; then
		exit 0
	fi
fi
# install the compiled fdk-aac package
dpkg -i $DIR/packages/ffmpeg_*-git-1_armhf.deb

if $INTERACTIVE; then
	echo -n "Do you want to clean up all temporary files? [y|n] "
	read CONT
	if [ "$CONT" != "y" ]; then
		exit 0
	fi
fi
# clean up
cd; rm -Rf $DIR/tmp/{fdk-aac,ffmpeg}