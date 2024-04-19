#!/usr/bin/env bash

set -e

xcodebuild -configuration Release -derivedDataPath DerivedData/beepserv-installer -destination 'generic/platform=iOS' -scheme Installer CODE_SIGNING_ALLOWED="NO" CODE_SIGNING_REQUIRED="NO" CODE_SIGN_IDENTITY=""
cp Resources/ents.plist DerivedData/beepserv-installer/Build/Products/Release-iphoneos/
pushd DerivedData/beepserv-installer/Build/Products/Release-iphoneos
rm -rf Payload Installer.ipa
mkdir Payload
cp -r beepserv-installer.app Payload
ldid -Sents.plist Payload/beepserv-installer.app
zip -qry Installer.ipa Payload
popd
cp DerivedData/beepserv-installer/Build/Products/Release-iphoneos/Installer.ipa .
rm -rf Payload
