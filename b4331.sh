#!/bin/sh

##      Bader S. Zaidan - github.com/BaderSZ
## OpenFWWF installer script for deb based systems

## The MIT License (MIT)
## 
## Copyright (c) 2013 Bader Senussi Zaidan
## 
## Permission is hereby granted, free of charge, to any person obtaining a copy
## of this software and associated documentation files (the "Software"), to deal
## in the Software without restriction, including without limitation the rights
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
## copies of the Software, and to permit persons to whom the Software is
## furnished to do so, subject to the following conditions:
## 
## The above copyright notice and this permission notice shall be included in
## all copies or substantial portions of the Software.
## 
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
## THE SOFTWARE.


FWDIR="./firmware"
FWDIR_PROP="./firmware/proprietary"
FW_INSTALL_DIR="/lib/firmware/b43-open/"
ARCH=$(uname -p)
ARCH32="i386"
ARCH64="x86_64"

echo "Accessing apt-get to install the neccessary utilities"

sudo apt-get install flex bison debhelper wget build-essential make binutils

mkdir $FWDIR
cd $FWDIR


echo "Downloading needed packages, from the internet..."

wget- -c  http://bues.ch/b43/fwcutter/b43-fwcutter-017.tar.bz2 \
      http://www.lwfinger.com/b43-firmware/broadcom-wl-5.100.138.tar.bz2 \
      http://mirror.fsf.org/trisquel/pool/main/o/openfwwf/openfwwf_5.2-0trisquel3_all.deb


## Detect Architecture and download specific package
if echo $ARCH64 | grep -q $ARCH
then
  echo "Architecture detected: x86_64"
  wget http://mirror.fsf.org/trisquel/pool/main/b/b43-asm/b43-asm_0~20080619-0+c0.sidux.5_amd64.deb
elif echo $ARCH32 | grep -q $ARCH
then
  echo "Architecture detected: i386"
  wget http://mirror.fsf.org/trisquel/pool/main/b/b43-asm/b43-asm_0~20080619-0+c0.sidux.5_i386.deb
fi


tar xjf b43-fwcutter-017.tar.bz2
tar xjf broadcom-wl-5.100.138.tar.bz2


## Now that installation and extraction is done, install b43-fwcutter.
cd b43-fwcutter-017
make
sudo make install
cd ..


## openfwwf depends on b43-asm, install both
sudo dpkg -i b43-asm*.deb openfwwf_5.2-0trisquel3_all.deb


## extract the proprietary firmware to the temporary directory.
sudo b43-fwcutter -w $FWDIR_PROP broadcom-wl-5.100.138/linux/wl_apsta.o


## copy only the needed proprietary files. To the firmware directory.
sudo cp $FWDIR_PROP/ht0initvals29.fw    $FW_INSTALL_DIR
sudo cp $FWDIR_PROP/ht0bsinitvals29.fw  $FW_INSTALL_DIR
sudo cp $FWDIR_PROP/ucode29_mimo.fw     $FW_INSTALL_DIR


echo "-------------------------"
echo "Done! Please reboot the computer..."

