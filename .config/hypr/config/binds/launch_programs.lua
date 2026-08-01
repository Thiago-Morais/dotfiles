local b = require("config.binds-utils")

local M = {}

local _desc = ""
function M.setup()
	-- ======= Launch Programs =======
	hl.bind(b.combo(MainMod, "SPACE"), hl.dsp.exec_cmd(App_launcher .. " &"), { description = "Runs your application launcher" })
	hl.bind(b.combo(MainMod, "CTRL", "SPACE"), hl.dsp.exec_cmd(Window_switcher .. " &"), { description = "Runs your window switcher" })
	hl.bind(b.combo(MainMod, "RETURN"), hl.dsp.exec_cmd(Terminal .. " &"), { description = "Opens your preferred terminal emulator (" .. Terminal .. ")" })
	hl.bind(b.combo(MainMod, "E"), hl.dsp.exec_cmd(File_manager .. " &"), { description = "Opens your preferred filemanager (" .. File_manager .. ")" })
	hl.bind(b.combo(MainMod, "B"), hl.dsp.exec_cmd(Browser .. " &"), { description = "Open your preferred browser (" .. Browser .. ")" })
	_desc = "Open your preferred task manager (" .. Task_manager .. ")"
	hl.bind(b.combo(MainMod, "Escape"), hl.dsp.exec_cmd(("%s --class %s -e %s &"):format(Terminal, Task_manager, Task_manager)), { description = _desc })
	hl.bind(b.combo(MainMod, "O"), function()
		hl.dsp.exec_cmd(("%s --class %s %s cd %s; $EDITOR %s & disown"):format(Terminal, Note_taker, Terminal_middlefix, Note_vault, Terminal_suffix))
		hl.dsp.exec_cmd(Note_taker .. " &")
	end, { description = "Open your preferred note taking app (" .. Note_taker .. ")" })
	_desc = "Open your preferred code editor (" .. os.getenv("EDITOR") .. ")"
	hl.bind(b.combo(MainMod, "N"), hl.dsp.exec_cmd(("%s $EDITOR %s & disown"):format(Terminal_preffix, Terminal_suffix)), { description = _desc })
	hl.bind(b.combo(MainMod, "I"), hl.dsp.exec_cmd(Color_picker .. " -ar"), { description = "Open your preferred color picker (" .. Color_picker .. ")" })
	hl.bind(b.combo(MainMod, "PERIOD"), hl.dsp.exec_cmd(Emoji_picker .. " &"), { description = "Open emoji picker (" .. Emoji_picker .. ")" })
	hl.bind(b.combo(MainMod, "CTRL", "V"), hl.dsp.exec_cmd(Terminal .. " --class clipse -e 'clipse' &"), { description = "Open clipboard history" })
	hl.bind(b.combo(MainMod, "Y"), hl.dsp.exec_cmd(Music_player .. " &"), { description = "Open your preferred music player (" .. Music_player .. ")" })
end

return M
