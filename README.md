# ChromeScreens

**Please note: This script is experimental! Use at your own risk!**

## What is it?

ChromeScreens can be used to launch a Google Chrome instance on each connected display.

One URL of each screen can be configured. So it is perfectly to show websites like monitoring dashboards on big screens.

## Requirements

   * Debian (x86 or x64)
   * At least one Nvidia graphics card

## Installation

   * Check out this repository on the target system (The system which you want to configure)
   * Execute the configure.sh script
   * Wait while the script configures ChromeScreens
   * Configure the Chrome instances (See bellow)
   * Use it ;-)

**Important:** Do not remove the checked out directory! Files like the LightDM session file refer to that directory.

## Update

   * Update the checkout using *git pull*
   * Execute the configure.sh script again
   * Restart LightDM (service lightdm restart)

## Configure Chrome instances

Chrome instances are configure in the file *conf/chrome-instances.conf*.

Each non-empty line not starting with a '#' is read by the script.

A line looks like 'Screen-ID URL'. The screen is a numer starting at 0.

Example:
```
0 http://example.com
1 http://another-website.com
```

**You should not configure more instances than attached screens!**

You have to restart LightDM to see your changes (e.g. *service lightdm restart*).

## Configure wakeup and suspend

You can optionally configure your computer to automatically wake it up and suspend it on specific days and at specific times.

**Note:** This feature does not work yet!

Wakeup and suspend times are configured in the file *conf/suspend-wakeup.conf*.

Each non-empty line not starting with a '#' is read by the script.

A line looks like 'Day wakeup-time suspend-time'. The wakeup and suspend times are in format 'hh:mm'.

Example:
```
1 7:00 20:00
2 7:00 20:00
3 7:00 20:00
4 7:00 20:00
5 7:00 20:00
```

**Each day should only be configured once!**

After you have saved your changes execute *bin/configure-suspend-wakeup.sh*.
