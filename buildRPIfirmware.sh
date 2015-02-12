#/bin/sh

cd /usr/src/raspberry/linux

#building config
#make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcmrpi_defconfig

#building all
#make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-

#copy kernel to tinynfc-rpi-firmware folder
cp /usr/src/raspberry/linux/arch/arm/boot/Image /usr/src/raspberry/tinynfc-rpi-firmware

# building modules
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=/usr/src/raspberry/tinynfc-rpi-firmware modules
# installing modules
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=/usr/src/raspberry/tinynfc-rpi-firmware modules_install

