#!/usr/bin/env bash

if [ ! -d build ]; then
  mkdir build
fi

cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ../
make
sudo make install
sudo update-icon-caches /usr/share/icons/hicolor/
cd ..
