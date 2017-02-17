# ChromeScreens

**Please note: This script is experimental! Use at your own risk!**

## What is it?

ChromeScreens can be used to launch a Google Chrome instance on each connected display.

For each screen an URL (or even multiple ones if combined with a tab switcher extension like [Revolver - Tabs](https://chrome.google.com/webstore/detail/revolver-tabs/dlknooajieciikpedpldejhhijacnbda)) can be configured. So it is a perfect solution to show websites like monitoring dashboards on big screens.

The Chrome instances are launched in full screen (Kiosk mode), so nothing but the website is visible on the screen.

## Requirements

   * Debian 8 Jessie (x86 or x64)
   * At least one Nvidia graphics card

## Installation

   * Check out this repository on the target system (The system which you want to configure)
   * Execute the [configure.sh](/configure.sh) script
   * Wait while the script configures ChromeScreens
   * Configure the Chrome instances (See bellow)
   * Use it ;-)

**Important:** Do not remove the checked out directory! Files like the LightDM session file refer to that directory.

## Update

   * Update the checkout using *git pull*
   * Execute the [configure.sh](/configure.sh) script
   * Restart LightDM (service lightdm restart)

## Configure Chrome instances

Chrome instances are configured in the file [conf/chrome-instances.conf](/conf/chrome-instances.conf.sample).

Each non-empty line not starting with a '#' is read by the script.

A line looks like 'Screen-ID Chrome Arguments'. The screen is a number starting at 0.

The chrome arguments typically contain the URL of the website to load. You may specify multiple URLs separated by space to open multiple tabs and install a [Chrome Extension which automatically switches the tabs](https://chrome.google.com/webstore/detail/revolver-tabs/dlknooajieciikpedpldejhhijacnbda).

Example:
```
0 http://example.com
1 http://another-website.com http://some-other-site.com
```

**Do not configure more instances than screens attached!**

You have to restart LightDM to apply your changes (e.g. *service lightdm restart*).

## Configure wakeup and suspend

You can optionally configure your computer to automatically wake it up and suspend it on specific days and at specific times.

Wakeup and suspend times are configured in the file [conf/suspend-wakeup.conf](/conf/suspend-wakeup.conf).

Each non-empty line not starting with a '#' is read by the script.

Each day must be on a new line in the format 'Day Action Time'.

"Day" is a value between 1 (Monday) and 7 (Sunday).
"Action" can be "wakeup" (Wake up at the given time) or "suspend" (Suspend at the given time).
"Time" is a value in format "hh:mm" (e.g. 7:00 for 7am or 20:00 for 8pm).

Example:
```
1 wakeup 7:00
1 suspend 20:00
2 wakeup 7:00
2 suspend 20:00
3 wakeup 7:00
3 suspend 20:00
4 wakeup 7:00
4 suspend 20:00
5 wakeup 7:00
5 suspend 20:00
```

After you have saved your changes execute [bin/configure-suspend-wakeup.sh](bin/configure-suspend-wakeup.sh).

## Chrome Remote Debugging

Each Chrome instance is started with a locally listening port for Remote Debugging.

You can access it by forwarding port 9200 + <Screen ID> (e.g. Port 9200 for screen 0 and port 9201 for screen 1).

## VNC access

Each screen is viewable via a locally listening VNC server.

You can access it by forwarding port 5900 + <Screen ID> (e.g. Port 5900 for screen 0 and port 5901 for screen 1).
