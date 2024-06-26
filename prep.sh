#!/bin/bash

# Help output for this script
function help() {
	echo "Usage: prep.sh [OPTIONS] SALT_VERSION"
	echo "Extracts the installer bundle and prepares the build directories."
	echo ""
	echo "Options:"
	echo "  --oss    Only prep open source bits"
	echo "  --clean  Clean up build dirs"
	echo "  --help   Display this help message."
	echo ""
	echo "SALT_VERSION Optional. Specifiy the full version of salt to install"
}

if [[ $1 == "--help" || $1 == "-h" ]]
then
	help
	exit 0
fi

# clean the build dirs before every build prep
if [[ -f compose.yaml ]]
then
	docker compose down
fi
rm -rf ./build/sse-installer ./build/raas/eapi_service ./build/salt-master/eapi_plugin .env compose.yaml data/postgres/* data/raas/pki/ data/raas/raas.secconf data/raas/initialized data/master/pki/ data/redis/redis.conf

# Check if the user has requested to only clean up unpacked installer directories
# if we are cleaning only then stop here and don't unpack again
if [[ $1 == "--clean" ]]
then
	echo "environment cleaned"
	exit 0
fi

# If only deploying oss bits then prep a minimal .env file and exit cleanly without parsing installer bundle
if [[ $1 == "--oss" ]]
then
	# Determine salt version to use
	SALT_VERSION='3007.0'
	if [ $# -eq 2 ]; then
		SALT_VERSION="$2"
	fi
	echo "SALT_VERSION=$SALT_VERSION" >> .env

	# print .env file for user to quickly validate correct values 
	cat .env

	# link the oss-compose.yaml
	ln -s oss-compose.yaml compose.yaml

	# offer to bring up the environment for the user
	while true; do
	    read -p "Do you wish to run docker compose? " yn
	    case $yn in
	        [Yy]* ) docker compose up -d; exit 0; break;;
	        [Nn]* ) exit 0;;
	        * ) echo "Please answer yes or no.";;
	    esac
	done
fi

# Extract the installer bundle
tar zxf vRA_SaltStack_Config*.tar.gz -C build # TODO: add ability to handle tar.gz

# Copy the installers to build directories
cp -r ./build/sse-installer/salt/sse/eapi_service ./build/raas/
cp -r ./build/sse-installer/salt/sse/eapi_plugin ./build/salt-master

# build the .env file
RAAS_FILE_PATH=$(ls build/raas/eapi_service/files/raas*.rpm)
RAAS_FILE_NAME=$(basename $RAAS_FILE_PATH)
echo "RAAS_RPM_NAME=$RAAS_FILE_NAME" >> .env

MASTER_PLUGIN_PATH=$(ls build/salt-master/eapi_plugin/files/SSEAPE*.whl)
MASTER_PLUGIN_NAME=$(basename $MASTER_PLUGIN_PATH)
echo "MASTER_PLUGIN_NAME=$MASTER_PLUGIN_NAME" >> .env

SALT_VERSION='3007.0'
if [ $# -gt 0 ]; then
	SALT_VERSION="$1"
fi
echo "SALT_VERSION=$SALT_VERSION" >> .env

echo "POSTGRES_USER=default" >> .env
echo "POSTGRES_PASS=postgres123" >> .env

echo "REDIS_PASS=redis123" >> data/redis/redis.conf

# link the aria compose file
ln -s aria-compose.yaml compose.yaml

# print the env environment for user to validate
cat .env
cat data/redis/redis.conf

# offer to bring up the environment for user
while true; do
    read -p "Do you wish to run docker compose? " yn
    case $yn in
        [Yy]* ) docker compose up -d; break;;
        [Nn]* ) exit 0;;
        * ) echo "Please answer yes or no.";;
    esac
done
