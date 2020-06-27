#!/bin/sh

set -e

tools_directory="$(dirname "$0")"
root_directory="$tools_directory/.."
build_path="$root_directory/DerivedData"
app_name="MexicanTrain"

cd $root_directory

xcodegen
pod install

xcodebuild -workspace "${app_name}".xcworkspace -scheme "${app_name}" -sdk iphoneos archive -archivePath "${build_path}"/"${app_name}".xcarchive
xcodebuild -exportArchive -archivePath "${build_path}"/"${app_name}".xcarchive -exportOptionsPlist exportOptions-ad-hoc.plist -exportPath "${build_path}"
