#!/bin/bash
wget https://github.com/startbootstrap/startbootstrap-grayscale/archive/gh-pages.zip
apt install -y zip
ls -l
unzip gh-pages.zip
cp -r startbootstrap-grayscale-gh-pages/* /var/www/html
rm -r gh-pages.zip startbootstrap-grayscale-gh-pages