**Hypersomnia is now deprecated. Please use the more-versatile program [idlelock.sh](https://github.com/thetarkus/idlelock.sh) for your screen locking needs.**

# 🌜 Hypersomnia
Power Manager for Linux.

Hypersomnia is a tool for those who want a simplistic and easily
customizable solution to automatically manage: idle notifications,
screen blanking, screen locking, and system sleeping states.

Hypersomnia was created to be a single alternative to the awkwardly common
combination of `xautolock`, `xscreensaver`, and `xss-lock`.


## Features
* Notify user of inactivity through screen dimming, fading, or `notify-send`.
* Lock screen after a period of user inactivity.
* Turn screen off after a period of user inactivity.
* Put system to sleep after a period of user inactivity.
* Change timers based on a file's content. 🔋
* Lock screen on system sleep.
* Wake screen on system resume.
* Pause processes while locked.
* Hooks for *pre-* and *post-* notify, sleep, lock, and restore.
* Pause timers for a duration of time.
  * Pause all timers (`hypersomnia --pause 30`).
  * Pause individual timers (`hypersomnia --pause 30 lock sleep`).
* Inhibitors
  * Audio Inhibitor; prevent timers from activating when audio is playing.
  * Fullscreen Inhibitor; prevent timers from activating when a window is fullscreen.
  * CPU Inhibitor; prevent suspending when CPU usage is above a value.
  * Network Inhibitor; prevent suspending when network is active.
  * User Inhibitor; prevent timers from activating when user command is successful.
* Hook into systemd's login manager by monitoring DBus for locking and sleeping state changes.
  * Lock using `loginctl lock-session`; unlock using `loginctl unlock-session`.
  * Lock and sleep with `systemctl suspend`.
* Highly customizable.



## Installation

### Quick-Install
```sh
git clone https://github.com/thetarkus/hypersomnia && cd hypersomnia && sudo make install
```

### Install
```sh
# Clone this repository
git clone https://github.com/thetarkus/hypersomnia && cd hypersomnia

# Check that requirements are satisfied (Optional)
./hypersomnia --requirements

# Install requirements for Ubuntu-based systems
sudo apt install gcc libx11-dev libxss-dev realpath bc

# Install requirements for Arch-based systems
sudo pacman -S gcc libx11 libxss coreutils bc

# Install hypersomnia (current user only)
# You will also need to add ~/.local/bin to your $PATH
make install

# Install hypersomnia (system-wide)
# No modification of $PATH needed
sudo make install
```

Run `hypersomnia` to begin.
Add `hypersomnia -d` to your startup applications.

### Dependencies
* gcc
* libX11
* libXss
* realpath
* bc

#### Optional
* xbacklight
* i3lock


## Usage
```
usage: ./hypersomnia [-h]

optional arguments:
--help
  Print usage instructions.

--options
  Print Hypersomnia's default options.

--hooks
  Print Hypersomnia's hooks.

--requirements
  Print required dependencies.

--notify
  Immediately run the notifier command.

--lock, -l
  Immediately run the lock command.

--screen-off
  Immediately run the screen off command.

--sleep
  Immediately run the sleep command.

--resume
  Immediately run the resume command.

--brightness, -b
  Restore brightness to the contents of `$HS_BRIGHTNESS_FILE`.

--max-brightness, -B
  Set brightness to 100%.

--reload, -r
  Reload Hypersomnia.

--daemon, -d
  Run Hypersomnia as a daemon.

--kill, -k
  Kill Hypersomnia.

--pid
  List all Hypersomnia process IDs.

--inhibitors, -i
  List which inhibitors are active.

--pause, -p <duration> [timers...]
  Pause Hypersomnia for a specified duration. Specify a duration
  such as `1:05` for 1 hour and 5 minutes. Valid formats are: H:M:S,
  H:M, M. Timers can be individually paused by specifying the timers
  name after the duration. For example, `screen-off sleep` after the
  duration will pause the screen-off and sleep timers but the other
  timers will still activate as normal.

--unpause, -u
  Unpause or clear paused status for Hypersomnia.

--status, -s
  Print status of Hypersomnia.

--version, -v
  Print version.
```


## Configuration
Hypersomnia utilizes environment variables for configuration. Hypersomnia, by
default, will also try to source `$HOME/.config/hypersomnia/config` before running.

View options by running `hypersomnia --options`.


## Examples

#### Turn off screen and lock a minute later
```sh
#
# $HOME/.config/hypersomnia/config
#

: ${HS_NOTIFY_SECONDS:=30}     # Notify after 30 seconds
: ${HS_SCREEN_OFF_SECONDS:=60} # Turn screen off 30 seconds later
: ${HS_LOCK_SECONDS:=120}      # Lock screen 60 seconds later
: ${HS_SLEEP_SECONDS:=0}       # Disable sleep timer

# Prevent locker from running while listening to music
: ${HS_LOCK_INHIBITORS:=audio}

# Prevent system sleep when downloading at 2Mb/s
: ${HS_SLEEP_INHIBITORS:=network}
: ${HS_INHIBIT_NETWORK_VALUE:=2000000}
```


#### Lock screen then turn off 30 seconds later
```sh
#
# $HOME/.config/hypersomnia/config
#

: ${HS_NOTIFY_SECONDS:=30}     # Notify after 30 seconds
: ${HS_LOCK_SECONDS:=60}       # Lock screen 30 seconds later
: ${HS_SCREEN_OFF_SECONDS:=90} # Turn screen off 30 seconds later
: ${HS_SLEEP_SECONDS:=3600}    # Put system to sleep after 1 hour of inactivity
```


#### Use xsecurelock (instead of i3lock)
```sh
#
# $HOME/.config/hypersomnia/config
#

: ${HS_LOCK_COMMAND:=xsecurelock}
: ${HS_LOCK_PROCESS_NAME:=xsecurelock}
: ${HS_INHIBITORS:=none}  # Disable all inhibitors

# Fade to black screen
: ${HS_NOTIFY_STYLE:=fade}

# Pause redshift to prevent flickering while dimming
: ${HS_NOTIFY_PAUSE_PROCESS_NAMES:=redshift}

# Pause dunst when lock is activated to hide private notifications
: ${HS_NOTIFY_LOCK_PROCESS_NAMES:=dunst}
```


#### Set timers based on battery charging status
```sh
#
# $HOME/.config/hypersomnia/config
#

: ${HS_NOTIFY_SECONDS:=60 30}    # Longer inactivity before notifying user
: ${HS_LOCK_SECONDS:=0 60}       # Don't lock when charging

# Battery status file
: ${HS_WATCH_FILE:=/sys/class/power_supply/BAT0/status}
: ${HS_WATCH_VALUE:=Discharging} # Value to compare to for secondary values
: ${HS_WATCH_INTERVAL:=15}         # Check every 15 seconds for status change
```
