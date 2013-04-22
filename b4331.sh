#!/bin/sh

## Bader Zaidan - github.com/BaderSZ
## OpenFWWF installer script for deb based systems

FWDIR="./firmware"
FWDIR_PROP="./firmware/proprietary"
FW_INSTALL_DIR="/lib/firmware/b43-open/"

echo "Accessing apt-get to install the neccessary utilities"

sudo apt-get install flex bison debhelper wget build-essential make binutils

mkdir $FWDIR
cd $FWDIR

echo "Downloading needed packages, from the interwebz"

wget     http://bues.ch/b43/fwcutter/b43-fwcutter-017.tar.bz2
wget     http://www.lwfinger.com/b43-firmware/broadcom-wl-5.100.138.tar.bz2
wget     http://mirror.fsf.org/trisquel/pool/main/o/openfwwf/openfwwf_5.2-0trisquel3_all.deb
wget     http://mirror.fsf.org/trisquel/pool/main/b/b43-asm/b43-asm_0~20080619-0+c1.aptosid.9trisquel1_amd64.deb

tar xjf b43-fwcutter-017.tar.bz2
tar xjf broadcom-wl-5.100.138.tar.bz2

cd b43-fwcutter-017
make
sudo make install
cd ..

sudo dpkg -i b43-asm_0~20080619-0+c1.aptosid.9trisquel1_amd64.deb
sudo dpkg -i openfwwf_5.2-0trisquel3_all.deb

sudo b43-fwcutter -w $FWDIR_PROP broadcom-wl-5.100.138/linux/wl_apsta.o

sudo cp $FWDIR_PROP/ht0initvals29.fw    $FW_INSTALL_DIR
sudo cp $FWDIR_PROP/ht0bsinitvals29.fw  $FW_INSTALL_DIR
sudo cp $FWDIR_PROP/ucode29_mimo.fw     $FW_INSTALL_DIR


echo "-------------------------"
echo "Done! Please reboot the computer..."


