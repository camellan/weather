#!/bin/bash
# Script for easy developing by Carlos Suárez (bitseater@gmail.com) - 2018
# Define variables
PACKAGE="com.github.bitseater.weather"
TEMPLATE=po/$PACKAGE.pot
FILES=po/*.po

# Define help and options
usage()
{
cat << EOF
usage: $0 options

OPTIONS:
   -b Build
   -c Compile
   -h Show this message
   -l List sources files
   -r Registre schemas
   -t Translate
   -u Uninstall
EOF
}

# Search strings to translate and update po files
translate()
{
    MYVAR=$(find . -type f -name *vala -or -name *appdata.xml.in -or -name *desktop.in)
    xgettext --keyword=_ --escape --sort-output -o $TEMPLATE $MYVAR
    for f in $FILES
	    do
		    msgmerge -v $f $TEMPLATE --update
		    echo $f "updated."
	    done
}
# Compile with meson / ninja
compile()
{
    meson --prefix /usr/ build
    ninja -C build
}

# Build and install
build(){
    sudo ninja -C build install
}

# Uninstall
uninstall(){
    ninja -v -C build
    sudo ninja -C build uninstall
    echo "Removing glib settings..."
    dconf reset -f /com/github/bitseater/weather/
    echo "Done."
    echo "Updating icon cache..."
    sudo update-icon-caches /usr/share/icons/hicolor/
    echo "Done."
}

# List sources files alphabetically
list(){
    find . -type f -name *vala | sort
}

# Registre or update schemas
registre(){
    sudo cp data/$PACKAGE.gschema.xml /usr/share/glib-2.0/schemas/
    sudo glib-compile-schemas /usr/share/glib-2.0/schemas/
}

# Menu options
while getopts “bchlrtu” OPTION
do
    case $OPTION in
        b)
            compile
            build
            exit 1
            ;;
        c)
            compile
            exit 1
            ;;
        h)
            usage
            exit 1
            ;;
        l)
            list
            exit 1
            ;;
        t)
            translate
            exit 1
            ;;
        r)
            registre
            exit 1
            ;;
        u)
            uninstall
            exit 1
            ;;
        ?)
            usage
            exit
            ;;
    esac
done
