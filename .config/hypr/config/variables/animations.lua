--------------------
---- ANIMATIONS ----
--------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	animations = {
		enabled = true,
		workspace_wraparound = false,
	},
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
-- Default springs
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.curve("overshot", { type = "bezier", points = { { 0.13, 0.99 }, { 0.29, 1.1 } } })
hl.curve("easeOutBack", { type = "bezier", points = { { 0.34, 1.56 }, { 0.64, 1 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 1, bezier = "overshot", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1, bezier = "overshot", style = "slide" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1, bezier = "overshot", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1, bezier = "overshot", style = "slidefade 80%" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 1, bezier = "overshot", style = "slidefadevert 50%" })
hl.animation({ leaf = "specialWorkspaceIn", enabled = true, speed = 1, bezier = "overshot", style = "slidefadevert" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 1, bezier = "overshot", style = "slidefadevert" })
