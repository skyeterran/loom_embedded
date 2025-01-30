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
	narrator("You wake up to the sound of a leaf blower outside your window. In your apartment complex, that means it's Friday.")
	player("Thank god.")
	narrator("So true. You have big plans today, too.")
	loom.choice{
		{ "No, I don't.", function()
			narrator("You totally do, actually.")
			narrator("Your plans are so profound that you're nearly vibrating.")
			narrator("Though that could be fear, or caffeine withdrawal.")
		end },
		{ "Yep, huge plans.", function()
			narrator("Such huge plans, that you're shaking with excitement.")
			player("Actually, that's anxiety-")
			narrator("You're so excited.")
		end },
	}
	player("I read in a Chaos Magick book that \"any sensation can be interpreted as novelty\" once.")
	narrator("You have no idea what that means, do you?")
	loom.choice{
		{ "I think it means they're full of shit.", function()
			narrator("Ah, like all the best writers.")
		end },
		{ "...shut up.", function()
			narrator("That's what I thought.")
		end },
	}
	player("It's too bad I don't actually remember what I was planning on doing.")
	morning_text()

	loom.jump(start)
end

function morning_text()
	narrator("You get a text on your rectangle.")

	local ignored_responses = {
		"Okay, to clarify: This isn't a \"choices matter\" situation.",
		"What, really? This is like, the first plot that's happened.",
		"Don't do this to me. Pick up your phone.",
		"I'm begging you, this isn't even that funny.",
		"You know what? I'm not humoring you next time.",
	}

	local read_phone = function()
		narrator(`Looking at your phone, you immediately see, just like, the worst shit ever, but also, a text from your friend {noora.name}.`)
		noora(`Hey, {player.name}! You're making cookies today, right?`)
		player("Oh shit, that's what it was.")
	end

	local times_ignored = 0
	local has_read_text = false
	while not has_read_text do
		loom.choice{
			{ "Pick it up.", function()
				if times_ignored > 0 then
					narrator("That's better.")
					if times_ignored > 1 then
						narrator(`Took you {times_ignored} times, but good enough.`)
					else
						narrator("At least I only had to say it once.")
					end
				end
				read_phone()
				has_read_text = true
			end },
			{ "Ignore it.", function()
				times_ignored = times_ignored + 1
				if #ignored_responses > 0 then
					narrator(table.remove(ignored_responses, 1))
				else
					if times_ignored < 10 then
						narrator("...")
					else
						-- If they're really stubborn
						narrator("Okay, we need to talk about this.")
						narrator("Do you not want to play the game?")
						loom.choice{
							{ "Not really, no.", function()
								narrator("Fuck. Honestly, I don't know why I asked that if I wouldn't like the answer.")
								narrator("Fine. Whatever. I'm just going to restart the whole thing to spite you now.")
								loom.jump(start)
							end },
							{ "No, I do!", function()
								narrator("Then who do you take me for?")
								loom.choice{
									{ "God?", function()
										narrator("Dude, I'm not god. I'm a narrator in an indie game.")
										narrator("I don't even have a British accent. I'm a second-rate meta video game narrator.")
									end },
									{ "An idiot?", function()
										narrator("You know what? That's fair, actually.")
									end },
								}
								narrator("I'm just going to force you to pick up the phone now.")
								read_phone()
								has_read_text = true
							end },
						}
					end
				end
			end },
		}
	end
end