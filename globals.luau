loom = require("loom/core")
random = require("loom/random")

-- Characters
local narrator = loom.character{
	color = "555555",
}
local player = loom.character{
	name = "You",
	align = "right",
}
local scav = loom.character{
	name = "Scav",
	color = "ff8400",
}
local noora = loom.character{
	name = "Noora",
	color = "0073ff",
}

function start()
	narrator("You wake up in an empty space.")
	narrator("You see a blue, and a red pill.")
	player("Oh, okay. I get it.")
	loom.choice{
		{ "Choose the red pill.", function()
            loom.globals["pill_chosen"] = "red"
            narrator("You know, the red pill was actually estrogen.")
            narrator("Not many people know that, only all trans women on earth.")
		end },
		{ "Choose the blue pill.", function()
            loom.globals["pill_chosen"] = "blue"
            narrator("I... okay. Sure.")
            narrator("Nobody really does that, but okay.")
		end },
	}

	loom.jump(start)
end