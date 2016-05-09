#!/bin/bash

sudo apt-get update

sudo apt-get install -y curl nodejs

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

\curl -sSL https://get.rvm.io | bash -s stable --rails

#source ~/.rvm/scripts/rvm

/usr/local/rvm/bin/rvm requirements

/usr/local/rvm/bin/rvm install ruby

/usr/local/rvm/bin/rvm use ruby --default

/usr/local/rvm/bin/rvm rubygems current

gem install rails
