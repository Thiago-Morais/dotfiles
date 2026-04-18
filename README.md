
## Create these files

- **path:** `/etc/geoclue/conf.d/arch-override.conf`
- **content:**

```conf
[wifi]
# To use the BeaconDB geolocation service, uncomment this URL.
url=https://api.beacondb.net/v1/geolocate
```

- **path:** `/etc/udev/rules.d/99-power-mode-switch.rules`
- **content:**

```conf
SUBSYSTEM=="power_supply", ATTR{online}=="?", RUN+="/usr/bin/runuser -u <YOUR_USERNAME> -- /home/<YOUR_USERNAME>/.config/hypr/scripts/power-mode/update-power-mode.sh"
```

> Where `<YOUR_USERNAME>` is your username since we can't use `~` nor `$HOME` on udev rules
