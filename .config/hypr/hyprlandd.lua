-- This is an example Hyprland Lua config file.
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

-- Please note not all available settings / options are set here.
-- For a full list, see the wiki

-- You can (and should!!) split this configuration into multiple files
-- Create your files separately and then require them like this:
-- require("myColors")

require("config.defaults")

require("default-colors")
require("colors")
require("config.variables.init")
-- require("config.autostart")
require("config.environment")
require("config.keybinds")
require("config.windowrules")
-- require("config.plugins")
