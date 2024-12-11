loom = require("loom/core")
random = require("loom/random")

-- Characters
local narrator = loom.character{}
local player = loom.character{ name = "You" }
local zeelay = loom.character{ name = "Ze'elay" }
local krell = loom.character{ name = "Krell" }
local tarsk = loom.character{ name = "Tarsk" }
local greeter, bellhop, custodian = nil

local loops = 0
function start()
    -- Random task assignments
    local employees = { zeelay, krell, tarsk }
    greeter = random.pop(employees)
    bellhop = random.pop(employees)
    custodian = random.pop(employees)

    narrator("You wake up in what looks like an airline terminal.")

    loops = loops + 1
    if loops == 3 then
        narrator("Three times over? Seems excessive.")
        look_at_window(start)
    end

    greeter(random.item{
        "Hello, there!",
        "Uh... hey.",
        "What's up?"
    })
    greeter("Um, welcome to the space station.")
    greeter(`I'm {greeter.name}.`)
    check_bags()

    -- Restart the loop
    loom.jump(start)
end

function check_bags()
    bellhop(`And my name's {bellhop.name}.`)
    bellhop("May I check your bags?")
    loom.choice{
        ["yes"] = function()
            player("Um, sure?")
            bellhop("Oh, sweet!")
            bellhop("I've dissolved them for you.")
        end,
        ["no"] = function()
            player("Uh, no thanks.")
            bellhop("What? Why not?")
            bellhop("You're on your own, then.")
        end,
    }
    bellhop("What, no tip? Jackass.")
end

function look_at_window(fn)
    narrator("You look at the portside window.")
    narrator("What is this place, really?")
    custodian("Looks fucking sexy, right?")
    loom.choice{
        ["yes"] = function()
            player("I... yes. Yep. So sexy.")
        end,
        ["no"] = function()
            player("Excuse me?")
            custodian("Don't wanna fuck space?")
        end,
        ["maybe"] = function()
            player("I'm... not decided yet.")
        end,
    }
    player(`Your nametag just says \"{custodian.name} the Pervert\".`)
    custodian("I also grease the vacuum robots at night.")
    player("I'm starting over again now.")
    loom.jump(fn)
end