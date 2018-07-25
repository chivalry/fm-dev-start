#!/bin/bash

fmsadmin backup fm-dev-start.fmp12 --dest filemac:/Aslan/Users/chuck/Projects/chivalry/fm-dev-start/ --username Administrator --password "eyeWi110fourg3t" -k 0
mv Databases/fm-dev-start.fmp12 ./
rm -r Databases

git add .
git commit -a -m "Add standard script folders."
git push
