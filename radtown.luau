loom = require("loom/core")
random = require("loom/random")
--encode = require("loom/encode")

-- Characters
local narrator = loom.character{
	color = "555555",
}
local player = loom.character{
	name = "You",
	align = "right",
}
local ichibark = loom.character{
	name = "Ichibark",
	color = "ff8400",
}
local longboy = loom.character{
	name = "Longboy",
	color = "0073ff",
}

local dialogue = random.deck{
	{
		"blaiz...",
		"chas-chas...",
		"funk...",
		"they...",
		"...they left me"
	},
	"fuck me running lmao",
	"i am so lonely",
	"doggy won't talk to me",
	"why is the world so big",
	"i am peeing",
	"none pizza left me",
	"i am sleeby",
	"eating garbage is good for you",
	"you kinda rock bro",
	"you're my biggest fan",
	"i will eat a small rock, much like a bird",
	"you are so sexy",
	"are you concerned about microplastics?",
	"i think my uncle is in love with my stepdad",
	"do you know where can one purchase... items?",
	"do you know where i can find the Hollywood sign?",
	"i need to clean most of the mirrors in my house"
}

local function sample_dialogue(character)
	local line = dialogue:pop()
	if line then
		if type(line) == "table" then
			for _, v in line do
				character(v)
			end
		else
			character(line)
		end
	else
		dialogue:reset()
		character("...")
	end
end

function talk_ichibark()
	sample_dialogue(ichibark)
	loom.jump(talk_ichibark)
end

function talk_longboy()
	sample_dialogue(longboy)
	loom.jump(talk_longboy)
end