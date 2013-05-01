# Pebble Box
Pebble Box is a [Vagrant](http://www.vagrantup.com) base box that makes it easy to quickly get started with the [Pebble Watch Face SDK](http://developer.getpebble.com/1/welcome). It contains the Pebble Watch Face SDK and the toolchain required to compile Pebble apps and watch faces.

With Pebble Box you:

* Save time, since you don't have to go through the [SDK install steps](http://developer.getpebble.com/1/01_GetStarted/01_Step_2).

* Can build Pebble apps and watch faces, even if you're on Windows.

* Don't have to worry about overwriting system files or leaving cruft on your machine since it runs in its own virtual machine.

> **Note**: this repo is for people that would like to create their own Pebble Box from scratch. If you're just looking to quickly get started building watch faces for your Pebble watch, you'll want to [download a prebuilt copy of Pebble Box](https://dl.dropboxusercontent.com/u/2135156/pebble.box).

## Prerequisites

Since this is a Vagrant base box, you'll need to have Vagrant installed on your system. There are prebuilt installers for every major OS available for download on [Vagrant's website](http://www.vagrantup.com).

If you're new to Vagrant, you'll find the (short) [Vagrant Getting Started Guide](http://docs.vagrantup.com/v2/getting-started/index.html) very helpful.

## Set up

Creating a Pebble Box is as easy as cloning this repo and running `vagrant up`. In a new terminal window, type the following:

```
git clone https://github.com/rahims/pebble-box.git
cd pebble-box
vagrant up
```

It'll take Vagrant roughly 20 minutes to set everything up, so go grab a snack. After Vagrant is done, you'll have your very own Pebble Box.

## Usage

Access your Pebble Box by running `vagrant ssh` in the terminal window. Once you're logged in, you can create your Pebble watch face project by running:

```
$PEBBLEDIR/tools/create_pebble_project.py $PEBBLEDIR/sdk my_new_project
cd my_new_project
./waf configure
```

This will create a new directory, called `my_new_project`, in both your Pebble Box (under `/vagrant/my_new_folder`) and your machine (under `pebble-box/my_new_folder`).

The two folders are synced, so any changes you make to files in the folder on your machine will automatically be visible in the folder on your Pebble Box, and vice versa. That means you can write code on your machine using whatever dev tools you like. When you're ready to build, just switch back to the terminal with your Vagrant session and type:

```
./waf build
python -m HTTPServer 8000
```

This builds your project and serves it up through a simple webserver running on your Pebble Box. (You can find out your Pebble Box's IP by running `ifconfig eth1`.)

## Contributing

Tweaking of your Pebble Box will most likely be done through the Puppet script found in `pebble-box/manifests/init.pp`. If you've got something you think would be helpful for others, be sure to send a pull request :)

## License
Copyright (C) 2013 Rahim Sonawalla ([rsonawalla@gmail.com](mailto:rsonawalla@gmail.com) / [@rahims](http://twitter.com/rahims)).

Released under the [MIT license](http://www.opensource.org/licenses/mit-license.php).
