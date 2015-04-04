#/bin/sh

# TinyNFC firmware builder for Raspberry Pi (RPi model B+), Raspbian OS
# (c) 2015 Oleksii Semilietov
#
# To update firmware just run on RPi "sudo REPO_URI=https://github.com/spylik/tinynfc-rpi-firmware-raspbian rpi-update"

FOLDER_TREE=${FOLDER_TREE:-"/usr/src/raspberry"}
BUILDER_TREE=${BUILDER_TREE:-"$FOLDER_TREE/tinynfc-rpi-firmware-raspbian"}

if [ ! -d "${FOLDER_TREE}" ]; then
	mkdir $FOLDER_TREE
fi

# updating kernel source directory tree
getOrUpdateKernelSourceTree() {
	if [ ! -d "${FOLDER_TREE}/linux" ]; then
		cd $FOLDER_TREE
		git clone --depth=1 https://github.com/raspberrypi/linux
		cp $BUILDER_TREE/extra/.config $FOLDER_TREE/linux/
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
	cp -r /usr/src/raspberry/firmware/boot/* $BUILDER_TREE/
	rm -R $BUILDER_TREE/vc/hardfp/opt/vc/bin
	rm -R $BUILDER_TREE/vc/hardfp/opt/vc/lib
	rm -R $BUILDER_TREE/vc/hardfp/opt/vc/LICENCE

	rm -R $BUILDER_TREE/vc/softfp/opt/vc/bin
	rm -R $BUILDER_TREE/vc/softfp/opt/vc/lib
	rm -R $BUILDER_TREE/vc/softfp/opt/vc/LICENCE


	#sdk
	rm -R $BUILDER_TREE/vc/sdk/opt/vc/include
	rm -R $BUILDER_TREE/vc/sdk/opt/vc/src

	cp -r $FOLDER_TREE/firmware/hardfp/opt/vc/bin $BUILDER_TREE/vc/hardfp/opt/vc/
	cp -r $FOLDER_TREE/firmware/hardfp/opt/vc/lib $BUILDER_TREE/vc/hardfp/opt/vc/
	cp -r $FOLDER_TREE/firmware/hardfp/opt/vc/LICENCE $BUILDER_TREE/vc/hardfp/opt/vc/


	cp -r $FOLDER_TREE/firmware/opt/vc/bin $BUILDER_TREE/vc/softfp/opt/vc/
	cp -r $FOLDER_TREE/firmware/opt/vc/lib $BUILDER_TREE/vc/softfp/opt/vc/
	cp -r $FOLDER_TREE/firmware/opt/vc/LICENCE $BUILDER_TREE/vc/softfp/opt/vc/


	#currently we copy sdk from hardfp folder (softfp used in old version)
	cp -r $FOLDER_TREE/firmware/hardfp/opt/vc/include $BUILDER_TREE/vc/sdk/opt/vc/
	cp -r $FOLDER_TREE/firmware/hardfp/opt/vc/src $BUILDER_TREE/vc/sdk/opt/vc/
}
# end of updating firmware directory tree

makemenuconfig() {
	cd $FOLDER_TREE/linux
	make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig
	make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- oldconfig
}

buildKernelARM6() {
	cd $FOLDER_TREE/linux
	make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- oldconfig
	make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
	cp $FOLDER_TREE/linux/arch/arm/boot/Image $BUILDER_TREE/kernel.img
}

buildModulesARM6() {
	cd $FOLDER_TREE/linux
	make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- oldconfig
	make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=$BUILDER_TREE modules
	make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=$BUILDER_TREE modules_install
	cp -r $BUILDER_TREE/lib/modules $BUILDER_TREE/
}

# build kernel and modules
buildKernelAndModulesARM6() {
	buildKernelARM6
	buildModulesARM6
}
# end of build kernel and modules

$1
