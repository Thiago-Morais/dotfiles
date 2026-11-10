--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------
local M = {}

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- require("config.defaults")
local colors = require("colors")

local DEFAULT_FLOATING_SIZE = { "960", "540" }
local set_special_gaps
local PICTURE_IN_PICTURE = "[Pp]icture[- ][Ii]n[- ][Pp]icture"

function M.setup()
	M.default_rules()
	M.float_necessary_windows()
	M.set_base_opacity()
	M.general_window_rules()
	M.decorations()
	M.bind_windows_to_workspace()
	M.prevent_idle()
	M.layer_rules()
	M.workspace_rules()
end

function M.default_rules()
	---@diagnostic disable-next-line: unused-local
	local suppressMaximizeRule = hl.window_rule({
		-- Ignore maximize requests from all apps. You'll probably like this.
		name = "suppress-maximize-events",
		match = { class = ".*" },
		suppress_event = "maximize",
	})
	-- suppressMaximizeRule:set_enabled(false)

	hl.window_rule({
		-- Fix some dragging issues with XWayland
		name = "fix-xwayland-drags",
		match = {
			class = "^$",
			title = "^$",
			xwayland = true,
			float = true,
			fullscreen = false,
			pin = false,
		},
		no_focus = true,
	})

	-- Layer rules also return a handle.
	-- local overlayLayerRule = hl.layer_rule({
	--     name  = "no-anim-overlay",
	--     match = { namespace = "^my-overlay$" },
	--     no_anim = true,
	-- })
	-- overlayLayerRule:set_enabled(false)

	-- Hyprland-run windowrule
	hl.window_rule({
		name = "move-hyprland-run",
		match = { class = "hyprland-run" },
		move = "20 monitor_h-120",
		float = true,
	})
end

function M.float_necessary_windows()
	hl.window_rule({
		float = 1,
		size = DEFAULT_FLOATING_SIZE,
		match = { class = "^(polkit-gnome-authentication-agent-1|hyprpolkitagent|org.org.kde.polkit-kde-authentication-agent-1)" },
	})
	hl.window_rule({
		float = 1,
		size = DEFAULT_FLOATING_SIZE,
		match = { class = "^(xdg-desktop-portal-gtk|xdg-desktop-portal-kde|xdg-desktop-portal-hyprland)" },
	})
	hl.window_rule({ float = 1, size = { "660", "420" }, match = { class = "blueman-manager" } })
	hl.window_rule({ float = 1, size = { "810", "540" }, match = { class = "^(org.pulseaudio.pavucontrol)" } })
	hl.window_rule({ float = 1, size = DEFAULT_FLOATING_SIZE, match = { class = "^(CachyOSHello)$" } })
	hl.window_rule({ float = 1, size = DEFAULT_FLOATING_SIZE, match = { class = "^(it.mijorus.smile)$" } })
	hl.window_rule({ float = 1, size = DEFAULT_FLOATING_SIZE, match = { class = "^(zenity)$" } })
	hl.window_rule({ float = 1, size = DEFAULT_FLOATING_SIZE, match = { title = "^((Save|Open) (File|Folder))$" } })
	hl.window_rule({ float = 1, size = DEFAULT_FLOATING_SIZE, match = { title = "^(Steam - Self Updater)$" } })
end

function M.set_base_opacity()
	hl.window_rule({ opacity = 0.95, match = { float = 0, fullscreen = 0 } })
	hl.window_rule({ opacity = 1.00, match = { fullscreen = 1 } })
	-- hl.window_rule({ opacity = 1.00, match = { class = "^(org.inkscape.Inkscape|inkstitch|.* - Inkscape)$" } })
	-- hl.window_rule({ opacity = 0.80, match = { class = "^(org.inkscape.Inkscape|inkstitch|.* - Inkscape)$" } })
	hl.window_rule({ opacity = 0.96, match = { class = "^(discord|armcord|webcord|vesktop)$" } })
	hl.window_rule({ opacity = 0.96, match = { initial_class = "^(DBeaver)$" } })
	hl.window_rule({ opacity = 0.95, match = { title = "^(QQ|Telegram)$" } })
	hl.window_rule({ opacity = 0.95, match = { title = "^(NetEase Cloud Music Gtk4)$" } })
	hl.window_rule({ opacity = 0.92, match = { class = "^(thunar|nemo)$" } })
end

function M.general_window_rules()
	hl.window_rule({ match = { class = ".*" }, center = true })
end

function M.decorations()
	M.video_player()
	M.terminal()
	M.specific_applications()
	M.floatin_windows()
	M.fullscreen_windows()
end

function M.video_player()
	hl.window_rule({
		match = { class = "^(vlc|imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$" },
		float = 1,
		size = { 960, 540 },
		center = true,
	})
end

function M.terminal()
	hl.window_rule({ match = { class = "^(kitty|Alacritty)$" }, animation = "slide right" })
end

function M.specific_applications()
	hl.window_rule({ match = { class = ".*(01KCKFKMNJ6CYVWDH0TA87FX47)" }, no_dim = 1, opaque = 1 })
	hl.window_rule({ match = { title = "^(danmufloat)$" }, pin = 1, rounding = 5 })
	hl.window_rule({ match = { title = "^(termfloat)$" }, rounding = 5 })
	hl.window_rule({ match = { title = ("^(%s)$"):format(PICTURE_IN_PICTURE) }, no_dim = 1, opaque = 1, float = 1, pin = 1, size = { "800", "450" } })
	hl.window_rule({ match = { class = "^(com.github.wwmm.easyeffects)" }, maximize = 1 })
	hl.window_rule({ match = { class = "ueberzugpp_.*" }, no_dim = 1, opaque = 1, float = 1, no_anim = 1 })
	hl.window_rule({ match = { class = "^(mpv|vlc)$" }, no_dim = 1, opaque = 1, pin = 1 })
	hl.window_rule({ match = { title = "^(cava)$" }, no_dim = 1, opaque = 1 })
	hl.window_rule({ match = { title = ".*(cbonsai|screensaver|gitlogue).*" }, no_dim = 1, opaque = 1 })
	hl.window_rule({ match = { class = ("(%s)"):format(Task_manager) }, float = 1, size = { "1300", "840" } })
	hl.window_rule({ match = { class = "clipse" }, float = 1, size = { "622", "622" } })
	local function inkscape_rules()
		hl.window_rule({ match = { class = "^(org.inkscape.Inkscape)$" }, float = 1 })
		hl.window_rule({ match = { class = "^(inkstitch)$" }, float = 1, size = { "1500", "840" } })
		hl.window_rule({ match = { title = "^(.* - Inkscape)$" }, float = 0 })
	end
	inkscape_rules()
	hl.window_rule({ match = { class = "flameshot" }, float = 1, opaque = 1, center = false })
end

function M.floatin_windows()
	hl.window_rule({ border_color = colors.outline, match = { float = 1 }, border_size = 2, no_dim = 1, rounding = 8 })
end

function M.fullscreen_windows()
	hl.window_rule({ match = { fullscreen = 1 }, border_size = 0, no_dim = 1, opaque = 1 })
end

function M.bind_windows_to_workspace()
	hl.window_rule({ workspace = 2, match = { class = ("(%s|obsidian|md.Obsidian|md.obsidian.Obsidian|github-desktop-plus|desktop-plus)"):format(Note_taker) } })
	hl.window_rule({ workspace = 3, match = { class = ("^(%s|nvim|code)$"):format(Code_editor) } })
	hl.window_rule({ workspace = 4, match = { class = ("^(%s|zen-browser|firefox|chrome|zen)$"):format(Browser) } })
	hl.window_rule({ workspace = 5, match = { initial_title = "(WhatsApp Web|whatsapp-web).*" } })
	hl.window_rule({ workspace = 5, match = { title = ".*(WhatsApp Web — ).*" } })
	hl.window_rule({ workspace = 8, match = { class = "(eu.betterbird.Betterbird).*" } })
	hl.window_rule({ workspace = "special:音楽", match = { class = "^(com.github.th[_-]ch.youtube[_-]music|org.kde.kasts)$" } })
end

function M.prevent_idle()
	local match = "mpv|%s|bg|%s|Anydesk"
	hl.window_rule({ idle_inhibit = "always", match = { class = ("^(" .. match .. ")$"):format(PICTURE_IN_PICTURE, Background_video_class) } })
	hl.window_rule({ idle_inhibit = "always", match = { title = ("^(" .. match .. ")$"):format(PICTURE_IN_PICTURE, Background_video_title) } })
end

function M.layer_rules()
	hl.layer_rule({ animation = "slide top", match = { namespace = "logout_dialog" } })
	-- hllayerw_rule({ animation = "popin 50%", match = { class = "waybar" } })
	hl.layer_rule({ animation = "slide down", match = { namespace = "waybar" } })
	hl.layer_rule({ animation = "fade 50%", match = { namespace = "wallpaper" } })
	hl.layer_rule({ blur = true, match = { namespace = "^(rofi)$" } })
	hl.layer_rule({ dim_around = true, match = { namespace = "^(rofi)$" } })
	hl.layer_rule({ no_anim = true, match = { namespace = "^(rofi)$" } })
end

function M.workspace_rules()
	M.set_special_gaps(0.2)
end

function M.set_special_gaps(factor)
	for _, m in ipairs(hl.get_monitors()) do
		local x_out = math.floor(m.width / m.scale * (factor / 2))
		local y_out = math.floor(m.height / m.scale * (factor / 2))
		local x_in = math.floor(m.width / m.scale * (factor / 4))
		local y_in = math.floor(m.height / m.scale * (factor / 4))
		hl.workspace_rule({
			workspace = "s[true] m[" .. m.name .. "] f[-1]",
			gaps_out = { top = y_out, right = x_out, bottom = y_out, left = x_out },
			gaps_in = { top = y_in, right = x_in, bottom = y_in, left = x_in },
		})
	end
end

M.setup()
