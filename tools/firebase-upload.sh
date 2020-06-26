#!/bin/sh

set -e

tools_directory="$(dirname "$0")"
root_directory="$tools_directory/.."
build_path="$root_directory/DerivedData"
app_name="MexicanTrain"

cd $root_directory

GOOGLE_APP_ID=$(/usr/libexec/PlistBuddy -c "Print :GOOGLE_APP_ID" Resources/GoogleService-Info.plist)
firebase appdistribution:distribute "${build_path}"/"${app_name}".ipa --app $GOOGLE_APP_ID