#!/bin/bash
#Description: installs SoapUI

SOAPUI_VERSION='5.5.0'
SOAPUI_INSTALLATION="/opt/SoapUI-${SOAPUI_VERSION}"
SOAPUI_LOG="/var/log/soapui"
SOAPUI_ARCHIVE="SoapUI-${SOAPUI_VERSION}-linux-bin.tar.gz"

RESOURCES=/vagrant/resources
SERVICE=/vagrant/service/soapui_mock.service

# download and extract SoapUI
echo "Downloading SoapUI-$SOAPUI_VERSION"
if [ -d $SOAPUI_INSTALLATION ]; then
	sudo rm -r $SOAPUI_INSTALLATION
	sudo rm -r $SOAPUI_LOG
fi
sudo mkdir -p $SOAPUI_INSTALLATION
sudo mkdir -p $SOAPUI_LOG
wget -q https://s3.amazonaws.com/downloads.eviware/soapuios/${SOAPUI_VERSION}/${SOAPUI_ARCHIVE} -O /tmp/${SOAPUI_ARCHIVE}
tar -xzf /tmp/${SOAPUI_ARCHIVE} --strip-components=1 -C $SOAPUI_INSTALLATION
chmod a+x -R ${SOAPUI_INSTALLATION}/bin/
chmod a+rw $SOAPUI_LOG
rm /tmp/${SOAPUI_ARCHIVE}

# copy the mock service resources
echo "Copying resources from $RESOURCES"
if [ -d /opt/mock ]; then
	sudo rm -r /opt/mock
fi
sudo mkdir /opt/mock
sudo cp ${RESOURCES}/* /opt/mock
chmod a+rw -R /opt/mock

# copy the service and enable it
echo "Copying service: $SERVICE"
SERVICE_NAME="${SERVICE##*/}"
sudo cp $SERVICE /etc/systemd/system/$SERVICE_NAME

echo "Enabling service: $SERVICE_NAME"
sudo systemctl enable $SERVICE_NAME
sudo systemctl daemon-reload
sudo systemctl start soapui_mock
