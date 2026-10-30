local b = require("config.binds-utils")

local M = {}

local _desc = ""
local function toggle_keybinds_displayer()
	local w = hl.get_window("initialtitle:HotKeyHub")
	if w then
		hl.dispatch(hl.dsp.window.close({ window = w }))
	else
		hl.dispatch(hl.dsp.exec_cmd("hotkeyhub --hyprland"))
	end
end

function M.setup()
	-- ======= Launch Programs =======
	hl.bind(b.combo(MainMod, "SPACE"), hl.dsp.exec_cmd(App_launcher .. " &"), { description = "Runs your Application Launcher" })
	hl.bind(b.combo(MainMod, "CTRL", "SPACE"), hl.dsp.exec_cmd(Window_switcher .. " &"), { description = "Runs your Window Switcher" })
	_desc = "Opens your preferred Terminal emulator (" .. Terminal .. ")"
	hl.bind(b.combo(MainMod, "RETURN"), hl.dsp.exec_cmd(Terminal .. " &"), { description = _desc })
	hl.bind(b.combo("ALT", "RETURN"), hl.dsp.exec_cmd(Terminal .. " &"), { description = _desc })
	hl.bind(b.combo(MainMod, "PERIOD"), hl.dsp.exec_cmd(Emoji_picker .. " &"), { description = "Open Emoji picker (" .. Emoji_picker .. ")" })
	hl.bind(b.combo(MainMod, "E"), hl.dsp.exec_cmd(File_manager .. " &"), { description = "Opens your preferred File Manager (" .. File_manager .. ")" })
	_desc = "Open your preferred Browser (" .. Browser .. ")"
	hl.bind(b.combo(MainMod, "B"), hl.dsp.exec_cmd(("gtk-launch %s || %s &"):format(Browser, Browser)), { description = _desc })
	_desc = "Open your preferred Task Manager (" .. Task_manager .. ")"
	hl.bind(b.combo(MainMod, "Escape"), hl.dsp.exec_cmd(("%s --class %s -e %s &"):format(Terminal, Task_manager, Task_manager)), { description = _desc })
	hl.bind(b.combo(MainMod, "O"), hl.dsp.exec_cmd(Note_taker .. " &"), { description = "Open your preferred Note taking app (" .. Note_taker .. ")" })
	_desc = "Open your preferred Code Editor (" .. os.getenv("EDITOR") .. ")"
	hl.bind(b.combo(MainMod, "N"), hl.dsp.exec_cmd(("%s $EDITOR %s & disown"):format(Terminal_preffix, Terminal_suffix)), { description = _desc })
	hl.bind(b.combo(MainMod, "I"), hl.dsp.exec_cmd(Color_picker .. " -ar"), { description = "Open your preferred Color picker (" .. Color_picker .. ")" })
	hl.bind(b.combo(MainMod, "CTRL", "V"), hl.dsp.exec_cmd(Terminal .. " --class clipse -e 'clipse' &"), { description = "Open Clipboard history" })
	hl.bind(b.combo(MainMod, "Y"), hl.dsp.exec_cmd(Music_player .. " &"), { description = "Open your preferred Music player (" .. Music_player .. ")" })
	-- hl.bind(b.combo(MainMod, "Super_L"), toggle_keybinds_displayer, { description = "Open a Hotkeys cheat sheet" })

	-- ======= Screenshot/Printscreen =======
	hl.bind(b.combo("Print"), hl.dsp.exec_cmd(Shot_screen), { description = "Creates a screenshot of an area" })
	hl.bind(b.combo(MainMod, "SHIFT", "S"), hl.dsp.exec_cmd(Shot_region), { description = "Creates a screenshot of an area" })
	hl.bind(b.combo(MainMod, "SHIFT", "ALT", "S"), hl.dsp.exec_cmd(Alt_Shot), { description = "Use and alternative screenshot command" })
	hl.bind(b.combo("CTRL", "Print"), hl.dsp.exec_cmd(Shot_window), { description = "Creates a screenshot of the active window" })
	hl.bind(b.combo("ALT", "Print"), hl.dsp.exec_cmd(Shot_screen), { description = "Creates a screenshot of the active display" })
end

return M
