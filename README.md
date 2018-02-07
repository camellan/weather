# Weather

[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg)](https://appcenter.elementary.io/com.github.bitseater.weather)﻿

### Know the forecast of the next hours & days.

Developed with Vala & Gtk,using OpenWeatherMap API (https://openweathermap.org/)

![Screenshot](./data/screens/screenshot_1.png  "Weather")

### Features:

- Current weather, with information about temperature, pressure, wind speed and direction, sunrise & sunset.
- Forecast for next 18 hours.
- Forecast for next five days.
- Choose your units (metric or imperial).
- Choose your city, with maps help.
- Awesome maps with weather info.
- System tray indicator.

### How To Build

Library Dependencies :

- gtk+-3.0
- libsoup-2.4
- json-glib-1.0
- clutter-1.0
- clutter-gtk-1.0
- champlain-0.12
- champlain-gtk-0.12
- geocode-glib-1.0
- webkit2gtk-4.0
- appindicator3-0.1


For advanced users!

    git clone https://github.com/bitseater/weather
    cd weather
    ./quick.sh -b

----

#### New on release 0.5:

- Add meson support to build/compile.
- Add new translations.
- Add Indicator to wingpanel with symbolic icons.
- Add Weather Maps with temperatures, clouds, precipitation, pressure and wind speeds.
- Add maps providers: *Dark Sky* and *OpenWeatherMaps*.
----
#### Other screenshots:

**A map with temperatures by Dark Sky**
![Screenshot](./data/screens/screenshot_2.png  "Weather")
**A map with temperatures by OpenWeatherMap:**
![Screenshot](./data/screens/screenshot_3.png  "Weather")
**Indicator in wingpanel / system tray:**

![Screenshot](./data/screens/screenshot_4.png  "Weather")