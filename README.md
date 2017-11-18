# Weather
###A forecast application for the desktop.

Built in Vala, Granite & Gtk,using OpenWeatherMap API (https://openweathermap.org/)

![Screenshot](screenshot.png  "Weather")

###Features:

- Current weather, with information about temperature, pressure, wind speed and direction, 
sunrise & sunset.
- Forecast for next 18 hours.
- Forecast for next five days.
- Choose your units (metric or imperial).
- Choose your city.

###How To Build

For advanced users only!

	git clone https://github.com/bitseater/weather
	cd weather
	mkdir build
	cd build 
	cmake -DCMAKE_INSTALL_PREFIX=/usr ../
	sudo make install