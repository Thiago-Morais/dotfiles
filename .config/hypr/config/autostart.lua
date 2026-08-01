-------------------
---- AUTOSTART ----
-------------------
require("config.defaults")

local start_core_processes, start_secondary_process, fix_power_usage, single_trigger_commands, start_programs_in_workspaces

local function main()
	-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
	hl.on("hyprland.start", function()
		-- Autostart wiki https://wiki.hyprland.org/Configuring/Keywords/#executing

		start_core_processes()
		start_secondary_process()
		hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1 &")

		single_trigger_commands()

		-- Slow app launch fix
		hl.exec_cmd("systemctl --user import-environment &")
		hl.exec_cmd("systemctl --user start gammastep-indicator &")
		hl.exec_cmd("systemctl --user start geoclue-agent &")
		hl.exec_cmd("hash dbus-update-activation-environment 2>/dev/null &")
		hl.exec_cmd("dbus-update-activation-environment --systemd &")

		start_programs_in_workspaces()
	end)
end

function start_core_processes()
	hl.exec_cmd("fcitx5 -d &")
	hl.exec_cmd("nm-applet --indicator &")
	hl.exec_cmd('bash -c "mkfifo ' .. wob_path .. " && tail -f " .. wob_path .. ' | wob & disown" &')
end

function start_secondary_process()
	hl.exec_cmd("hyprpaper &")
	hl.exec_cmd("wpaperd &")
	hl.exec_cmd("waybar")
	hl.exec_cmd("mako")
	hl.exec_cmd("easyeffects -w &")
	hl.exec_cmd("clipse -listen &")
	hl.exec_cmd(start_all_services .. " &")
	hl.exec_cmd(sync_all_remotes .. " &")
	hl.exec_cmd(idle_handler)
	-- hl.exec_cmd("seanime &")
	hl.exec_cmd("xsettingsd &")
end

function single_trigger_commands()
	hl.exec_cmd("hyprpm reload &")
	hl.exec_cmd("trash-empty 30 -f")
	fix_power_usage()
end

function fix_power_usage()
	hl.exec_cmd("brightnessctl -d nvidia_0 s 0")
	hl.exec_cmd("../scripts/power-mode/update-power-mode.sh")
end

function start_programs_in_workspaces()
	-- We can't use a `&` at the end if we want the application to open at the correct workspace
	hl.exec_cmd("[workspace 1 silent] anki &")
	-- hl.exec_cmd("[workspace 2 silent] " .. Notetaker .. " &")
	hl.exec_cmd("[workspace 3 silent] " .. terminal_preffix .. " cd ~/.config/hypr/ && " .. code_editor .. " -S " .. terminal_suffix .. " &")
	-- hl.exec_cmd("[workspace 4 silent] " .. Browser .. " &")
	-- Launch WhatsApp
	hl.exec_cmd("[workspace 5 silent] firefoxpwa site launch 01K7N2EPSD39A4MS7ZFD78HVCC" .. " &")
	-- hl.exec_cmd("[workspace 8 silent] " .. Email .. Email_suffix .. " &")
	-- hl.exec_cmd("[workspace special:音楽 silent] youtube-music" .. " &")
	hl.exec_cmd("[workspace special:特別 silent] " .. terminal .. " &")
end

-- **** Ignore ****
-- $gnome-schema = org.gnome.desktop.interface
-- # Dark Theme
-- # #for libadwaita gtk4 apps you can use this command:
-- exec = gsettings set $gnome-schema color-scheme "prefer-dark"   # for GTK4 apps
--
-- # #for gtk3 apps you need to install adw-gtk3 theme (in arch linux sudo pacman -S adw-gtk-theme)
-- # exec = gsettings set $gnome-schema gtk-theme "cachyos-nord"   # for GTK3 apps
-- # exec = gsettings set $gnome-schema gtk-theme ""   # for GTK3 apps
-- exec = gsettings set $gnome-schema icon-theme "breeze"   # for GTK3 apps
--
-- exec = gsettings set $gnome-schema font-name "JetBrainsMonoNL Nerd Font Propo"   # for GTK4 apps
-- # exec = gsettings set $gnome-schema font-name ""   # for GTK4 apps
--
-- # Enable debug mode on gtk applications
-- # exec = gsettings set org.gtk.Settings.Debug enable-inspector-keybinding true
--
-- # #for kde apps you need to install: sudo pacman -S qt5ct qt6ct kvantum kvantum breeze-icons
-- # #you will need to set dark theme for qt apps from kde more difficult thans with gnome :D:
-- env = QT_QPA_PLATFORMTHEME,qt6ct   # for Qt apps# Theme
--
-- #  Sync with rclone
-- # $ rclone copy --dry-run --drive-export-formats link.html,link.html,link.html REMOTE: PATH/TO/DIRECTORY
--
-- # # Cursor Theme
-- exec = gsettings set org.gnome.desktop.interface cursor-theme cursor_theme_name
-- exec = gsettings set org.gnome.desktop.interface cursor-size 32
-- exec = gsettings set org.mate.peripherals-mouse cursor-theme cursor_theme_name
-- exec = gsettings set org.mate.peripherals-mouse 32

main()
