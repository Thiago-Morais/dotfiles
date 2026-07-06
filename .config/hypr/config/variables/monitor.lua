------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

hl.monitor({
	output = "eDP-2",
	mode = "highres@highrr",
	position = "0x0",
	scale = "1.6",
})

hl.monitor({
	output = "HDMI-A-1",
	mode = "highres@highrr",
	position = "auto-right",
})

hl.config({ xwayland = {
	force_zero_scaling = true,
} })
