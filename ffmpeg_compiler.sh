#!/bin/bash

function run {
	case "$1" in
		install_basic_packages)
			# Prepare for compilation
			sudo apt-get install -y git autoconf automake build-essential checkinstall libass-dev libgpac-dev libmp3lame-dev \
			libopencore-amrnb-dev libopencore-amrwb-dev librtmp-dev libspeex-dev libtheora-dev libtool libvorbis-dev \
			pkg-config texi2html zlib1g-dev yasm
			;;
		compile_fdk-aac)
			# Compile fdk-aac library (used by ffmpeg)
			cd $DIR/tmp
			git clone --depth 1 git://github.com/mstorsjo/fdk-aac.git
			cd fdk-aac
			autoreconf -fiv
			./configure --disable-shared
			make
			sudo checkinstall --pkgname=fdk-aac --pkgversion="$(date +%Y%m%d%H%M)-git" --backup=no --deldoc=yes --fstrans=no --default
			mv fdk-aac_*-git-1_armhf.deb $DIR/packages/
			;;
		install_fdk-aac)
			# install the compiled fdk-aac package
			sudo dpkg -i $DIR/packages/fdk-aac_*-git-1_armhf.deb
			;;
		compile_x264)
			# Compile x264 library (used by ffmpeg)
			cd $DIR/tmp
			git clone --depth 1 git://git.videolan.org/x264.git
			cd x264
			./configure --enable-static
			make
			sudo checkinstall --pkgname=x264 --pkgversion="$(date +%Y%m%d%H%M)-git" --backup=no --deldoc=yes --fstrans=no --default
			mv x264_*-git-1_armhf.deb $DIR/packages/
			;;
		install_x264)
			# install the compiled fdk-aac package
			sudo dpkg -i $DIR/packages/x264_*-git-1_armhf.deb
			;;
		compile_ffmpeg)
			# Compile ffmpeg with libfdk capability
			cd $DIR/tmp
			git clone --depth 1 git://source.ffmpeg.org/ffmpeg
			cd ffmpeg
			./configure --enable-gpl --enable-libass --enable-libfdk-aac --enable-libmp3lame --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libspeex --enable-librtmp --enable-libtheora --enable-libvorbis --enable-nonfree --enable-version3
			make
			sudo checkinstall --pkgname=ffmpeg --pkgversion="7:$(date +%Y%m%d%H%M)-git" --backup=no --deldoc=yes --fstrans=no --default
			mv ffmpeg_*-git-1_armhf.deb $DIR/packages/
			;;
		install_ffmpeg)
			# install the compiled fdk-aac package
			sudo dpkg -i $DIR/packages/ffmpeg_*-git-1_armhf.deb
			;;
		clean_up)
			# clean up
			sudo rm -Rf $DIR/tmp/{fdk-aac,ffmpeg}
			;;
		*)
			break
			;;
	esac
}

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
	if [ "$CONT" == "y" ]; then
		run install_basic_packages
	fi
else
	run install_basic_packages
fi

if $INTERACTIVE; then
	echo -n "Do you want to compile fdk-acc to package? [y|n] "
	read CONT
	if [ "$CONT" == "y" ]; then
		run compile_fdk-aac
	fi
else
	run compile_fdk-aac
fi


if $INTERACTIVE; then
	echo -n "Do you want to install fdk-acc package? [y|n] "
	read CONT
	if [ "$CONT" == "y" ]; then
		run install_fdk-aac
	fi
else
	run install_fdk-aac
fi


if $INTERACTIVE; then
	echo -n "Do you want to compile x264 to package? [y|n] "
	read CONT
	if [ "$CONT" == "y" ]; then
		run compile_x264
	fi
else
	run compile_x264
fi


if $INTERACTIVE; then
	echo -n "Do you want to install x264 package? [y|n] "
	read CONT
	if [ "$CONT" == "y" ]; then
		run install_x264
	fi
else
	run install_x264
fi


if $INTERACTIVE; then
	echo -n "Do you want to compile ffmpeg to package? [y|n] "
	read CONT
	if [ "$CONT" == "y" ]; then
		run compile_ffmpeg
	fi
else
	run compile_ffmpeg
fi


if $INTERACTIVE; then
	echo -n "Do you want to install ffmpeg package? [y|n] "
	read CONT
	if [ "$CONT" == "y" ]; then
		run install_ffmpeg
	fi
else
	run install_ffmpeg
fi


if $INTERACTIVE; then
	echo -n "Do you want to clean up all temporary files? [y|n] "
	read CONT
	if [ "$CONT" == "y" ]; then
		run clean_up
	fi
else
	run clean_up
fi
