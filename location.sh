#!/bin/bash

# tests

# no ocean
# latitude="25"
# longitude="42"

# ocean
# latitude="-40"
# longitude="-16"

# variables
username=`cat USERNAME`
position=""

# find iss location
issinfos=$(curl -s https://api.wheretheiss.at/v1/satellites/25544)
latitude=`echo $issinfos | grep -Po 'latitude.*?,' | grep -Po '\-?[0-9]+\.[0-9]+'`
longitude=`echo $issinfos | grep -Po 'longitude.*?,' | grep -Po '\-?[0-9]+\.[0-9]+'`


# find ocean name
ocean=$(curl -s "http://api.geonames.org/oceanJSON?lat=$latitude&lng=$longitude&username=$username")
echo $ocean
position=$(echo $ocean | grep -Po '(?<=name":").*?(?=")')

if [[ -z $position ]]  
then
	# find country with location
	country=$(curl -s "http://api.geonames.org/findNearbyJSON?lat=$latitude&lng=$longitude&username=$username&style=MEDIUM&maxRows=1")
	echo $country
	position=$(echo $country | grep -Po '(?<=countryName":").*?(?=")')
fi

echo $position

