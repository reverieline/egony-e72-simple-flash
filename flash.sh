#!/bin/bash

PORT=/dev/ttyUSB0
if [ ! -z "$FLASH_PORT" ]; then
  PORT=$FLASH_PORT
fi
echo Flash port set to $PORT

echo
echo Installing dependencies
apt update
apt install -y git unzip python3 python3-pip
pip3 install pyserial intelhex

echo
echo Cloning flash tool and firmware
git clone https://github.com/JelmerT/cc2538-bsl.git
git clone https://github.com/egony/cc2652p_E72-2G4M20S1E.git

echo
echo Unpacking latest hex file
archive=$(ls -1 cc2652p_E72-2G4M20S1E/firmware/coordinator/*.zip | sort -r | head -1)
unzip -o $archive -d .
hexfile=$(ls -1 *.hex | head -1)
echo $hexfile

echo
echo ===========================
echo Hold Flash button and install the device, 
echo than release the button.
echo ===========================
echo Waiting for $PORT 
while $(ls $PORT 2>/dev/null 1>/dev/null) ; [ $? -ne 0 ]; do sleep 1; done

echo
echo Flashing
python3 cc2538-bsl/cc2538-bsl.py -p $PORT -e -w $hexfile





