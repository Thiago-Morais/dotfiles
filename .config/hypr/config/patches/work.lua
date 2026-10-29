hl.config({
	general = {
		-- border_size = 1,
		border_size = 2,
		-- gaps_in = 10,
		gaps_in = 3,
	},
	decoration = {
		rounding = 0,
		blur = {
			size = 8,
			-- size = 10,
			passes = 3, -- more passes = more resource intensive.
			-- new_optimizations = true,
		},
	},
	group = {
		groupbar = {
			gradient_rounding = 0,
			gaps_in = 2,
			blur = true,
		},
	},
})
