# ISS HD Earth Viewing Wallpaper \o/

## Sumup

I really do like views from space and i was tired of my old wallpaper.
So why not create dynamic wallpaper where photos come from the [ISS HDEV experiment](http://www.ustream.tv/channel/iss-hdev-payload).

```
~$ ./live.sh
```
![view from ISS](http://upload.timfaitsoncinema.fr/p/2016-10/58157bdf.jpg)

```
~$ ./live.sh --with-location
```

![view from ISS with location](http://upload.timfaitsoncinema.fr/p/2016-11/5818e79a.jpg)

(location and time on top left)

:camera: :dizzy_face:

## Config:

* OS : debian 
* windows manager : i3
* screen : 1920x1080

## Content

Script is not really long.
I wanted to be able to recognize if the stream was down (meaning loss of signal between earth and ISS) to avoid updating my wallpaper.
Same logic if the stream is too dark.
I tried to find a method to resize in a clever way, but hard work for me. :sweat:

i used:

* imagemagick CLI
* feh
* ffmpeg


## To Do

* ~~Add location text (dev branch)~~
* resize quality
* colors/filters?


## Refs

[Nasa](http://www.nasa.gov/mission_pages/station/research/experiments/917.html)


_PS: Shell is not really my thing so feel free to contribute or comment_  :v:
