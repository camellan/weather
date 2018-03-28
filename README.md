# METEO

[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg)](https://appcenter.elementary.io/com.github.bitseater.weather)﻿

[![Release 0.7.0](https://img.shields.io/badge/Release-0.7.0-orange.svg)](https://github.com/bitseater/weather/releases) [![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0) [![Travis CI](https://travis-ci.org/bitseater/weather.svg?branch=master)](https://travis-ci.org/bitseater/weather/builds/) [![Flatpak](https://img.shields.io/badge/flatpak-download-lightgrey.svg)](https://flathub.org/repo/appstream/com.github.bitseater.weather.flatpakref) [![Snap Status](https://img.shields.io/badge/snap-download-red.svg)](https://snapcraft.io/meteo)


### Know the forecast of the next hours & days.

Developed with Vala & Gtk,using OpenWeatherMap API (https://openweathermap.org/)

![Screenshot](./data/screens/screenshot_1.png  "Weather")

### Features:

- Current weather, with information about temperature, pressure, wind speed and direction, sunrise & sunset.
- Forecast for next 18 hours.
- Forecast for next five days.
- Choose your units (metric, imperial or british).
- Choose your city, with maps help.
- Awesome maps with weather info.
- System tray indicator.

----

### How To Install

#### For elementary OS:

You can get it on [AppCenter](https://appcenter.elementary.io/com.github.bitseater.weather).

#### For Ubuntu and derivates:

You can add my ppa at Launchpad.net:

    sudo add-apt-repository ppa:bitseater/ppa
    sudo apt update
    sudo apt install com.github.bitseater.weather

#### For Debian and derivates:

You can download the last signed .deb package from [Releases](https://github.com/bitseater/weather/releases) page.

#### Flatpak package:

Also, you can install the flatpak package:

    flatpak install --from https://flathub.org/repo/appstream/com.github.bitseater.weather.flatpakref

#### Snap package:

Snap package is available at [Meteo in Snap Store](https://snapcraft.io/meteo)

I've added it at the request of the users, but I don't give support to snap.You can install it, at your own risk, from terminal:

    sudo snap install meteo

----

### How To Build

Library Dependencies :

- gtk+-3.0
- libsoup-2.4
- json-glib-1.0
- clutter-1.0
- clutter-gtk-1.0
- champlain-0.12
- geocode-glib-1.0
- webkit2gtk-4.0
- appindicator3-0.1
- meson


For advanced users!

    git clone https://github.com/bitseater/weather
    cd weather
    ./quick.sh -b

----

#### New on release 0.7.0:

- Load data from cache file when no connect.
- Add some comments when user select built-in API key.
- Add more information to indicator.
- Add new translations.
- Snap package avalaible.

Fixed issues: #49 #50 #52 #53 #57 #58 #60 #61

----
### Other screenshots:

**A map with temperatures by Dark Sky**
![Screenshot](./data/screens/screenshot_2.png  "Weather")

**A map with temperatures by OpenWeatherMap:**
![Screenshot](./data/screens/screenshot_3.png  "Weather")

**Indicator in wingpanel / system tray:**
![Screenshot](./data/screens/screenshot_4.png  "Weather")
