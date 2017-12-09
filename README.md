# Weather

[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg)](https://appcenter.elementary.io/com.github.bitseater.weather)﻿

### Know the forecast of the next hours & days.

Developed with Vala & Gtk,using OpenWeatherMap API (https://openweathermap.org/)

![Screenshot](screenshot.png  "Weather")

### Features:

- Current weather, with information about temperature, pressure, wind speed and direction, sunrise & sunset.
- Forecast for next 18 hours.
- Forecast for next five days.
- Choose your units (metric or imperial).
- Choose your city, with maps help.

### How To Build

Library Dependencies :

- gtk+-3.0
- libsoup-2.4
- json-glib-1.0
- clutter-1.0
- clutter-gtk-1.0
- champlain-0.12
- geocode-glib-1.0

For advanced users!

	git clone https://github.com/bitseater/weather
	cd weather
	mkdir build
	cd build
	cmake -DCMAKE_INSTALL_PREFIX=/usr ../
	make
	sudo make install

----

#### New on release 0.4.1:

- Add cmake support to other SO than elementaryOS.
- Add lituanian and russian translations. Thx to welaq and camellan.
- Fix gettext issue. Thx to Andrey Kultyapov.
- Add support to Debian/Ubuntu.
- Fix visual issues in UI.
- CSS support added.
- Choose between realistic and symbolic icons.
  
Suggested by Cassidy James Blaede:
  
- New "find location" screen, with elegants maps.
- Automatic location on start (Can disabled on preferences).
