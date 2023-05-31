device=viva
buildprop=/home/emiferpro/risingOS/out/target/product/$device/system/build.prop
linenr=`grep -n "ro.system.build.date.utc" $buildprop | cut -d':' -f1`
timestamp=`sed -n $linenr'p' < $buildprop | cut -d'=' -f2`

gh release create $timestamp rising* boot.img