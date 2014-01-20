# ChromeScreens

## What is it?

ChromeScreens can be used to launch a Google Chrome instance on each connected display.

One URL of each screen can be configured. So it is perfectly to show websites like monitoring dashboards on big screens.

## Requirements

   * Debian (x86 or x64)
   * At least one Nvidia graphics card

## Installation

   * Check out this repository on the target system (The system which you want to configure).
   * Execute the configure.sh script
   * Wait while the script configures ChromeScreens
   * Configure the Chrome instances (See bellow)
   * Use it ;-)

## Configure Chrome instances

Chrome instances are configure in /etc/chrome-instance.conf.

Each non-empty line not starting with a '#' is read by the session script.

A line looks like 'Screen-ID URL'. The screen is a numer starting at 0.

Example:
```
0 http://example.com
1 http://another-website.com
```

*You should not configure more instances than attached screens!*
