newbundleid=' example.ytx.rac;'
oldbundleid=$(awk -F '=' '/PRODUCT_BUNDLE_IDENTIFIER/ {print $2;exit}' RACTestO.xcodeproj/project.pbxproj)
echo $oldbundleid
sed -i '' "s/$oldbundleid/$newbundleid/g" RACTestO.xcodeproj/project.pbxproj

#修改info.plist的bundle id
#dir=`pwd`
#echo `defaults write $dir/RACTestO/Info.plist CFBundleIdentifier com.ytx.bundle`
#plutil -convert xml1 $dir/RACTestO/Info.plist
