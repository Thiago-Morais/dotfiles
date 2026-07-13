-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

local function core_env()
	hl.env("XDG_MENU_PREFIX", "arch-")
	hl.env("XDG_SCREENSHOTS_DIR", "$HOME/Pictures/Screenshots")
	hl.env("GSK_RENDERER=gl")
end

local function fix_scaling()
	local function cursor_scaling()
		hl.env("HYPRCURSOR_SIZE", "24")
		hl.env("XCURSOR_SIZE", "24")
		hl.env("QT_CURSOR_SIZE", "24")
	end
	local function gdk_scaling()
		hl.env("GDK_SCALE", "2") -- integer only
		hl.env("GDK_DPI_SCALE", "1") -- overscale firefox also
		-- hl.env("GDK_DPI_SCALE","1") -- underscale steam also
	end
	local function qt_scaling()
		hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
		hl.env("QT_ENABLE_HIGHDPI_SCALING", "1")
		hl.env("QT_QPA_PLATFORM", "wayland;xcb")
		hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
		-- hl.env("QT_QPA_PLATFORMTHEME","qt5ct")
		hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
		hl.env("QT_WAYLAND_FORCE_DPI", "physical")
		hl.env("QT_SCREEN_SCALE_FACTOR", "1.6")
		-- hl.env("QT_SCREEN_SCALE_FACTOR","1")
		hl.env("QT_SCALE_FACTOR", "1") -- overscale Dolphin and QDirStat?
		hl.env("QT_WAYLAND_FORCE_DPI", "96") -- 96 * 1.0 -- overscale Dolphin
	end
	local function program_scalings()
		hl.env("ELM_SCALE", "1.6") -- Elementary OS applications
		hl.env("_JAVA_OPTIONS", "'-Dsun.java2d.uiScale=1.6'") -- Java applications (Swing/AWT)
		hl.env("STEAM_FORCE_DESKTOPUI_SCALING", "1.6")
	end

	qt_scaling()
	cursor_scaling()
	gdk_scaling()
	program_scalings()
end

local function program_specific_env()
	hl.env("RIPGREP_CONFIG_PATH", "$HOME/.config/.ripgreprc")
	hl.env("ANKI_WAYLAND", "1")
	hl.env("MOZ_ENABLE_WAYLAND", "1") -- Mozilla applications
	-- hl.env("MOZ_USE_XINPUT2","1")
	hl.env("YAZI_CONFIG_HOME", "$HOME/.config/yazi")
	hl.env("LESS", " -R")
	hl.env("PACCACHE_ARGS", "'-rk1'")
	hl.env("EDITOR", "nvim")
end

local function force_input_method_editor(ime)
	-- Fix dead keys
	-- be sure to install fcitx with $ paru -S fcitx
	hl.env("GTK_IM_MODULE", ime)
	hl.env("QT_IM_MODULE", "wayland;" .. ime .. ";ibus")
	hl.env("XMODIFIERS", "@im=" .. ime)
	-- hl.env("SDL_IM_MODULE", ime)
end

local function force_wayland()
	-- Toolkit Backend
	hl.env("GDK_BACKEND", "wayland,x11,*")
	hl.env("CLUTTER_BACKEND", "wayland")
	-- Electron based apps use X11 as default, auto should detect wayland
	-- hl.env("ELECTRON_OZONE_PLATFORM_HINT","auto")
	hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
	hl.env("OZONE_PLATFORM", "wayland")

	hl.env("SYSTEMD_SLEEP_FREEZE_USER_SESSION", " false")
	hl.env("SYSTEMD_HOME_LOCK_FREEZE_SESSION", " false")

	hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
	hl.env("XDG_SESSION_TYPE", "wayland")
	hl.env("XDG_SESSION_DESKTOP", "Hyprland")

	hl.env("ECORE_EVAS_ENGINE", "wayland_egl")
	hl.env("ELM_ENGINE", "wayland_egl")
	-- hl.env("SDL_VIDEODRIVER","wayland")
	hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")
end
local function nvidia_env()
	hl.env("LIBVA_DRIVER_NAME", "nvidia")
	hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
	-- hl.env("AQ_DRM_DEVICES"," /dev/dri/card2:/dev/dri/card1")
end

core_env()
fix_scaling()
program_specific_env()
force_input_method_editor("fcitx")
force_wayland()
nvidia_env()
