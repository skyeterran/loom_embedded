local module = {
    convo = nil,
}

-- Initializes a character, making it callable
type Character = { name: string? }
function module.character(char: Character)
    setmetatable(char, { __call = module.say })
    return char
end

function module.say(self, txt: string)
    coroutine.yield{
        kind = "line",
        contents = txt,
        speaker = self,
    }
end

-- Runs a branch depending on the input key
function module.branch(fn)
    coroutine.yield{
        kind = "branch",
        contents = fn
    }
end

-- Like a branch, but presents the options first
function module.choice(options)
    coroutine.yield{
        kind = "choice",
        contents = options
    }
end

function module.jump(fn: () -> ())
    coroutine.yield{
        kind = "jump",
        contents = fn
    }
end

function module.run(fn)
    module.convo = { coroutine.create(fn) }
end

local function schedule(fn)
    table.insert(
        module.convo,
        coroutine.create(fn)
    )
end

function module.step(input: any?)
    local block = module.convo[#module.convo]
    local alive, value = coroutine.resume(block)
    if alive and value then
        if value.kind == "line" then
            if value.speaker.name then
                print(`{value.speaker.name}: {value.contents}`)
            else
                print(value.contents)
            end
        end
        if value.kind == "branch" then
            local chosen = value.contents[input]
            if chosen then
                schedule(chosen)
                module.step()
            else
                -- TODO: Replace with error()
                print("Invalid choice!")
            end
        end
        if value.kind == "choice" then
            print("Choose one:")
            for k, _ in value.contents do
                print(`--> \"{k}\"`)
            end
            schedule(function()
                module.branch(value.contents)
            end)
        end
        if value.kind == "jump" then
            module.run(value.contents)
            module.step()
        end
    else
        table.remove(module.convo, #module.convo)
        module.step()
    end
end

return module