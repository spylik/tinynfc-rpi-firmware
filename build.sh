#/bin/bash

# SmartNFC firmware builder for Raspberry Pi (RPi model B+)
# (c) 2015 Oleksii Semilietov

FOLDER_TREE=${FOLDER_TREE:-"/usr/src/raspberry"}

if [ ! -d "${FOLDER_TREE}" ]; then
	mkdir $FOLDER_TREE
fi

# updating kernel source directory tree
getOrUpdateKernelSourceTree() {
	if [ ! -d "${FOLDER_TREE}/linux" ]; then
		cd $FOLDER_TREE
		git clone --depth=1 https://github.com/raspberrypi/linux
	else
		cd $FOLDER_TREE/linux
		git pull
	fi
}
# end of updating kernel source directory tree

# updating firmware directory tree
getOrUpdateFirmwareTree() {
	if [ ! -d "${FOLDER_TREE}/firmware" ]; then
		cd $FOLDER_TREE
		git clone --depth=1 https://github.com/raspberrypi/firmware
	else
		cd $FOLDER_TREE/firmware
		git pull
	fi
	#copy data from current firmware boot folder to our firmware folder
	cp -r /usr/src/raspberry/firmware/boot/* /usr/src/raspberry/tinynfc-rpi-firmware/
	rm -R $FOLDER_TREE/tinynfc-rpi-firmware/vc/hardfp/opt/vc
	rm -R $FOLDER_TREE/tinynfc-rpi-firmware/vc/softfp/opt/vc
	#sdk
	rm -R $FOLDER_TREE/tinynfc-rpi-firmware/vc/sdk/opt/vc/include
	rm -R $FOLDER_TREE/tinynfc-rpi-firmware/vc/sdk/opt/vc/src

	cp -r $FOLDER_TREE/firmware/hardfp/opt/vc $FOLDER_TREE/tinynfc-rpi-firmware/vc/hardfp/opt/
	cp -r $FOLDER_TREE/firmware/opt/vc $FOLDER_TREE/tinynfc-rpi-firmware/vc/softfp/opt/
	#currently we copy sdk from hardfp folder
	cp -r $FOLDER_TREE/firmware/hardfp/opt/vc/include $FOLDER_TREE/tinynfc-rpi-firmware/vc/sdk/opt/vc/
	cp -r $FOLDER_TREE/firmware/hardfp/opt/vc/src $FOLDER_TREE/tinynfc-rpi-firmware/vc/sdk/opt/vc/


	
}
# end of updating firmware directory tree

# build kernel and modules
buildKernelAndModulesARM6() {
	cd $FOLDER_TREE/linux
	make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- oldconfig
	make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
	cp $FOLDER_TREE/linux/arch/arm/boot/Image $FOLDER_TREE/tinynfc-rpi-firmware/kernel.img
	make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=/usr/src/raspberry/tinynfc-rpi-firmware modules
#	rm -r $FOLDER_TREE/tinynfc-rpi-firmware/lib/modules
	make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=/usr/src/raspberry/tinynfc-rpi-firmware modules_install
	cp -r $FOLDER_TREE/tinynfc-rpi-firmware/lib/modules $FOLDER_TREE/tinynfc-rpi-firmware/
}
# end of build kernel and modules

$1
