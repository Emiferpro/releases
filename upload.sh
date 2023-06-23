cd ~/ota/releases
device=viva
buildprop=/home/emiferpro/risingOS/out/target/product/$device/system/build.prop
linenr=`grep -n "ro.system.build.date.utc" $buildprop | cut -d':' -f1`
timestamp=`sed -n $linenr'p' < $buildprop | cut -d'=' -f2`

echo "Publishing release"
gh release create  -F changelog_viva.txt --title "RisingOS for Redmi Note 11 Pro 4G (viva) | $timestamp" $timestamp rising* boot.img
echo "Commiting changes"
git add .
git commit -sm "viva: Update OTA JSON / Other Files"
git push