#!/bin/bash

#TOP=`pwd`
pushd ${ANDROID_BUILD_TOP}
HOUDINI_PATH=${ANDROID_BUILD_TOP}/vendor/intel/houdini
HOUDINI_VERSION=`strings ${HOUDINI_PATH}/system/lib/libhoudini.so | grep version: | awk '{print $2}'`
PRODUCT_OUT=${ANDROID_BUILD_TOP}/out/target/product/A400CG

mkdir -p ${PRODUCT_OUT}/obj/SHARED_LIBRARIES/libhoudini_intermediates/LINKED/
mkdir -p ${PRODUCT_OUT}/symbols/system/lib/
mkdir -p ${PRODUCT_OUT}/system/lib/

### Copy libhoudini with version
echo "Copying libhoudini"
cp -f --remove-destination ${HOUDINI_PATH}/system/lib/libhoudini.so ${PRODUCT_OUT}/obj/SHARED_LIBRARIES/libhoudini_intermediates/LINKED/libhoudini.so.${HOUDINI_VERSION}
cp -f --remove-destination ${HOUDINI_PATH}/system/lib/libhoudini.so ${PRODUCT_OUT}/symbols/system/lib/libhoudini.so.${HOUDINI_VERSION}
cp -f --remove-destination ${HOUDINI_PATH}/system/lib/libhoudini.so ${PRODUCT_OUT}/system/lib/libhoudini.so.${HOUDINI_VERSION}

### Create soft link for the libhoudini.so
echo "checking . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ."
cd ${PRODUCT_OUT}/obj/SHARED_LIBRARIES/libhoudini_intermediates/LINKED
ln -sf libhoudini.so.${HOUDINI_VERSION} libhoudini.so
cd ${PRODUCT_OUT}/symbols/system/lib/
ln -sf libhoudini.so.${HOUDINI_VERSION} libhoudini.so
cd ${PRODUCT_OUT}/system/lib
ln -sf libhoudini.so.${HOUDINI_VERSION} libhoudini.so

### Extra files needs to copy for houdini
cd $TOP
echo "Copying Houdini executables"
mkdir -p ${PRODUCT_OUT}/system/bin/
mkdir -p ${PRODUCT_OUT}/system/etc/binfmt_misc/
cp -f --remove-destination ${HOUDINI_PATH}/system/bin/houdini ${PRODUCT_OUT}/system/bin/
cp -f --remove-destination ${HOUDINI_PATH}/system/etc/binfmt_misc/arm_dyn ${PRODUCT_OUT}/system/etc/binfmt_misc/
cp -f --remove-destination ${HOUDINI_PATH}/system/etc/binfmt_misc/arm_dyn ${PRODUCT_OUT}/system/etc/binfmt_misc/

echo "Copying Houdini arm libs"
mkdir -p ${PRODUCT_OUT}/system/lib/arm/
cp -f --remove-destination ${HOUDINI_PATH}/arm/*.so ${PRODUCT_OUT}/system/lib/arm/
cp -f --remove-destination ${HOUDINI_PATH}/arm/linker ${PRODUCT_OUT}/system/lib/arm/

echo "Copying Houdini misc files"
cp -f --remove-destination ${HOUDINI_PATH}/system/lib/arm/cpuinfo ${PRODUCT_OUT}/system/lib/arm/
cp -f --remove-destination ${HOUDINI_PATH}/system/lib/arm/cpuinfo.neon ${PRODUCT_OUT}/system/lib/arm/
popd
