#!/bin/bash
DASH_ROOT=$(pwd)

if [ ! -d "repos" ]; then
	echo Cloning repos...
	mkdir repos
	git clone git@github.com:slalomatldev/MyCricket-iOS.git repos/MyCricket-iOS
	git clone git@github.com:slalomatldev/MyCricket-Android.git repos/MyCricket-Android
else
	echo Updating repos...
	cd repos
	cd MyCricket-iOS
	git pull 

	cd ../MyCricket-Android
	git pull
	cd $DASH_ROOT
fi

echo starting git webui servers...

cd git-webui

npm install
bower install
grunt 

# To kill these servers: 	pkill -f python 		
pkill -f 'port 8008'
pkill -f 'port 8009'
dist/libexec/git-core/./git-webui --port 8008 --no-browser --repo-root $DASH_ROOT/repos/MyCricket-iOS &
dist/libexec/git-core/./git-webui --port 8009 --no-browser --repo-root $DASH_ROOT/repos/MyCricket-Android &

cd ..

bundle

dashing start




