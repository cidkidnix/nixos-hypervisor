device_addr="0000:29:00.0"
setpci -s "$device_addr" 7c.l=39d5e86b || exit 1
