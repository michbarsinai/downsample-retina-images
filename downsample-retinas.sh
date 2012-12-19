#!/bin/bash

# Simple script to resize each image which ends with SUFFIX to half its size.
# Michael Bar-Sinai (mich.barsinai@gmail.com)
# Apache 2 license

# Usage: downsample-retinas [dir]

SUFFIX="@2x.png" # Suffix for the files that would be downsampled.
DEPTH=1          # Maximum depth for searching. 1: this dir only. 2: and in child dirs (but not in their sub dirs) 1000: ... you get the point

echo Downsampling image files that ends in $SUFFIX...

if [[ $# -eq 0 ]]; then
    dir=.
else
    dir=$1
fi

files=$(find $dir -name "*$SUFFIX" -depth $DEPTH)
for imgFile in $files; do
    echo processing: $imgFile
    h=$(sips -g pixelHeight "$imgFile" | tail -n1 | cut -d: -f2)
    w=$(sips -g pixelWidth "$imgFile"  | tail -n1 | cut -d: -f2)
    nw=$(($w/2))
    nh=$(($h/2))
    newName=$(echo $imgFile | sed "s/\(.*\)@2x.png/\1.png/")
    echo " old width:" $w ", new width:" $nw
    echo " old height:" $h ", new height:" $nh
    echo " old name:" $imgFile ", new name:" $newName
    cp -f "$imgFile" "$newName"
    sips -z $nh $nw "$newName" > /dev/null # sips is a bit verbose.
done

echo DONE.