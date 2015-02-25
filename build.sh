#/bin/sh

# SmartNFC firmware builder for Raspberry Pi (RPi model B+)
# (c) 2015 Oleksii Semilietov
#
# To update firmware use "sudo REPO_URI=https://github.com/spylik/tinynfc-rpi-firmware-raspbian rpi-update"

FOLDER_TREE=${FOLDER_TREE:-"/usr/src/raspberry"}

if [ ! -d "${FOLDER_TREE}" ]; then
	mkdir $FOLDER_TREE
fi

# updating kernel source directory tree
getOrUpdateKernelSourceTree() {
	if [ ! -d "${FOLDER_TREE}/linux" ]; then
		cd $FOLDER_TREE
		git clone --depth=1 https://github.com/raspberrypi/linux
		cp $FOLDER_TREE/tinynfc-rpi-firmware-raspbian/.config $FOLDER_TREE/linux/
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
	cp -r /usr/src/raspberry/firmware/boot/* /usr/src/raspberry/tinynfc-rpi-firmware-raspbian/
	rm -R $FOLDER_TREE/tinynfc-rpi-firmware-raspbian/vc/hardfp/opt/vc/bin
	rm -R $FOLDER_TREE/tinynfc-rpi-firmware-raspbian/vc/hardfp/opt/vc/lib
	rm -R $FOLDER_TREE/tinynfc-rpi-firmware-raspbian/vc/hardfp/opt/vc/LICENCE

	rm -R $FOLDER_TREE/tinynfc-rpi-firmware-raspbian/vc/softfp/opt/vc/bin
	rm -R $FOLDER_TREE/tinynfc-rpi-firmware-raspbian/vc/softfp/opt/vc/lib
	rm -R $FOLDER_TREE/tinynfc-rpi-firmware-raspbian/vc/softfp/opt/vc/LICENCE


	#sdk
	rm -R $FOLDER_TREE/tinynfc-rpi-firmware-raspbian/vc/sdk/opt/vc/include
	rm -R $FOLDER_TREE/tinynfc-rpi-firmware-raspbian/vc/sdk/opt/vc/src

	cp -r $FOLDER_TREE/firmware/hardfp/opt/vc/bin $FOLDER_TREE/tinynfc-rpi-firmware-raspbian/vc/hardfp/opt/vc/
	cp -r $FOLDER_TREE/firmware/hardfp/opt/vc/lib $FOLDER_TREE/tinynfc-rpi-firmware-raspbian/vc/hardfp/opt/vc/
	cp -r $FOLDER_TREE/firmware/hardfp/opt/vc/LICENCE $FOLDER_TREE/tinynfc-rpi-firmware-raspbian/vc/hardfp/opt/vc/


	cp -r $FOLDER_TREE/firmware/opt/vc/bin $FOLDER_TREE/tinynfc-rpi-firmware-raspbian/vc/softfp/opt/vc/
	cp -r $FOLDER_TREE/firmware/opt/vc/lib $FOLDER_TREE/tinynfc-rpi-firmware-raspbian/vc/softfp/opt/vc/
	cp -r $FOLDER_TREE/firmware/opt/vc/LICENCE $FOLDER_TREE/tinynfc-rpi-firmware-raspbian/vc/softfp/opt/vc/


	#currently we copy sdk from hardfp folder (softfp used in old version)
	cp -r $FOLDER_TREE/firmware/hardfp/opt/vc/include $FOLDER_TREE/tinynfc-rpi-firmware-raspbian/vc/sdk/opt/vc/
	cp -r $FOLDER_TREE/firmware/hardfp/opt/vc/src $FOLDER_TREE/tinynfc-rpi-firmware-raspbian/vc/sdk/opt/vc/
}
# end of updating firmware directory tree

buildKernelARM6() {
	cd $FOLDER_TREE/linux
	make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- oldconfig
	make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
	cp $FOLDER_TREE/linux/arch/arm/boot/Image $FOLDER_TREE/tinynfc-rpi-firmware-raspbian/kernel.img
}

buildModulesARM6() {
	cd $FOLDER_TREE/linux
	make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- oldconfig
	make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=/usr/src/raspberry/tinynfc-rpi-firmware-raspbian modules
#	rm -r $FOLDER_TREE/tinynfc-rpi-firmware-raspbian/lib/modules
	make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=/usr/src/raspberry/tinynfc-rpi-firmware-raspbian modules_install
	cp -r $FOLDER_TREE/tinynfc-rpi-firmware-raspbian/lib/modules $FOLDER_TREE/tinynfc-rpi-firmware-raspbian/
}

# build kernel and modules
buildKernelAndModulesARM6() {
	buildKernelARM6
	buildModulesARM6
}
# end of build kernel and modules

$1
