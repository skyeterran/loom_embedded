--!nolint UnknownGlobal

local module = {
    convo = nil,
    characters = {},
    globals = {},
}

-- Initializes a character, making it callable
type Character = {
    name: string?,
    color: vector?,
    align: string?,
}
function module.character(char: Character)
    if not char.align then
        char.align = "left"
    end
    setmetatable(char, { __call = module.say })
    if char.name then
        module.characters[char.name] = char
    else
        module.characters["nil"] = char
    end
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

local result = {
    text = "",
    speaker = nil,
    options = nil
}
function module.step(input: any?)
    local block = module.convo[#module.convo]
    local alive, value = coroutine.resume(block)
    if alive and value then
        if value.kind == "line" then
            result = {
                text = value.contents,
                speaker = value.speaker.name,
                color = value.speaker.color,
                align = value.speaker.align,
            }
        end
        if value.kind == "branch" then
            local chosen = value.contents[input][2]
            if chosen then
                schedule(chosen)
                module.step()
            else
                -- TODO: Replace with error()
                result = { text = "Invalid choice!" }
            end
        end
        if value.kind == "choice" then
            result = { text = "Choose one:", options = {} }
            for _, v in value.contents do
                table.insert(result.options, v[1])
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
    
    return result
end

return module