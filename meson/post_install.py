#!/usr/bin/env python3
import os
import subprocess

schemadir = os.path.join('/','usr', 'share', 'glib-2.0', 'schemas')
icondir = os.path.join('/','usr', 'share', 'icons', 'hicolor')

if not os.environ.get('DESTDIR'):
    print('Compiling gsettings schemas...')
    subprocess.call(['glib-compile-schemas', schemadir], shell=False)

    print('Rebuilding desktop icons cache...')
    subprocess.call(['update-icon-caches', icondir], shell=False)
