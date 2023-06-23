#!/bin/bash
#put script in crDroid source folder, make executable (chmod +x createupdate.sh) and run it (./createupdate.sh)

#modify values below
#leave blank if not used
maintainer="emiferpro" #ex: Lup Gabriel (gwolfu)
oem="Xiaomi" #ex: OnePlus
device="viva" #ex: guacamole
devicename="Redmi Note 11 Pro 4G" #ex: OnePlus 7 Pro
zip="risingOS-v1.1-Babylon-202306222227-viva-CORE-COMMUNITY.zip" #ex: crDroidAndroid-<android version>-<date>-<device codename>-v<ricedroid version>.zip
buildtype="Weekly" #choose from Testing/Alpha/Beta/Weekly/Monthly
forum="https://t.me/vivaaosp" #https link (mandatory)
gapps="" #https link (leave empty if unused)
firmware="" #https link (leave empty if unused)
modem="" #https link (leave empty if unused)
bootloader="" #https link (leave empty if unused)
recovery="https://github.com/Emiferpro/releases/releases/download/'$timestamp'/boot.img" #https link (leave empty if unused)
paypal="" #https link (leave empty if unused)
telegram="https://t.me/vivaaosp" #https link (leave empty if unused)
dt="https://github.com/xiaomi-mt6781-devs/android_device_xiaomi_viva" #https://github.com/ricedroidandroid/android_device_<oem>_<device_codename>
commondt="" #https://github.com/ricedroidandroid/android_device_<orm>_<SOC>-common
kernel="https://github.com/xiaomi-mt6781-devs/android_device_xiaomi_viva-kernel" #https://github.com/ricedroidandroid/android_kernel_<oem>_<SOC>


#don't modify from here
script_path="`dirname \"$0\"`"
zip_name=$script_path/out/target/product/$device/$zip
buildprop=$script_path/out/target/product/$device/system/build.prop

if [ -f $script_path/$device.json ]; then
  rm $script_path/$device.json
fi

linenr=`grep -n "ro.system.build.date.utc" $buildprop | cut -d':' -f1`
timestamp=`sed -n $linenr'p' < $buildprop | cut -d'=' -f2`
zip_only=`basename "$zip_name"`
md5=`md5sum "$zip_name" | cut -d' ' -f1`
sha256=`sha256sum "$zip_name" | cut -d' ' -f1`
size=`stat -c "%s" "$zip_name"`
version=`echo "$zip_only" | cut -d'-' -f2`
v_max=`echo "$version" | cut -d'.' -f1 | cut -d'v' -f2`
v_min=`echo "$version" | cut -d'.' -f2`
version=`echo $v_max.$v_min`

echo '{
  "response": [
    {
        "maintainer": "'$maintainer'",
        "oem": "'$oem'",
        "device": "'$devicename'",
        "filename": "'$zip_only'",
        "download": "https://github.com/Emiferpro/releases/releases/download/'$timestamp'/'$zip_only'",
        "timestamp": '$timestamp',
        "md5": "'$md5'",
        "sha256": "'$sha256'",
        "size": '$size',
        "version": "'$version'",
        "buildtype": "'$buildtype'",
        "forum": "'$forum'",
        "gapps": "'$gapps'",
        "firmware": "'$firmware'",
        "modem": "'$modem'",
        "bootloader": "'$bootloader'",
        "recovery": "https://github.com/Emiferpro/releases/releases/download/'$timestamp'/boot.img",
        "paypal": "'$paypal'",
        "telegram": "'$telegram'",
        "dt": "'$dt'",
        "common-dt": "'$commondt'",
        "kernel": "'$kernel'"
    }
  ]
}' >> $device.json
echo "Generate OTA JSON"
cat $device.json
mv viva.json ~/ota/releases/viva.json
cp "$script_path/out/target/product/$device/$zip" ~/ota/releases/"$zip"
echo "Copied ($zip)"
cp "$script_path/out/target/product/$device/boot.img" ~/ota/releases/boot.img
echo "Copied boot.img"
bash ~/ota/releases/upload.sh