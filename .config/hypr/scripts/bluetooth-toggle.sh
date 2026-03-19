STATE=`bluetoothctl show | grep Powered | awk '{print $2}'`
if [[ $STATE == 'yes' ]]; then
    bluetoothctl power off
    notify-send "Bluetooth Off" -n blueman
else
    bluetoothctl power on
    notify-send "Bluetooth On" -n blueman
fi
