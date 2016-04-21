#!/bin/bash
DASH_ROOT=$(pwd)

while getopts "qr" opt; do
  case $opt in
    q)
      QUICK=true >&2
      ;;
    r)
      NOREPOS=true >&2
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

if [ ! "$(find repos -maxdepth 2 -name '.git')" ]; then
   echo "No repositories found in /repos. Please clone desired repositories into /repos and retry this script"
else
	echo repos found:
	echo $(find repos -maxdepth 2 -name '.git')
	if [ "$NOREPOS" != "true" ]; then
		echo Updating repos...
		cd repos
		cd MyCricket-iOS

		git pull -v origin master

		cd ../MyCricket-Android
		git pull
	fi
	cd $DASH_ROOT

	echo starting git webui servers...

	cd git-webui

	if [ "$QUICK" != "true" ]; then
		npm install
		bower install
		grunt 
	fi

	# To kill these servers: 	pkill -f python 		
	pkill -f 'port 8008' & pkill -f 'port 8009'
	dist/libexec/git-core/./git-webui --port 8008 --no-browser --repo-root $DASH_ROOT/repos/MyCricket-iOS &
	dist/libexec/git-core/./git-webui --port 8009 --no-browser --repo-root $DASH_ROOT/repos/MyCricket-Android &

	cd ..

	if [ "$QUICK" != "true" ]; then
		bundle
	fi

	dashing start
fi






