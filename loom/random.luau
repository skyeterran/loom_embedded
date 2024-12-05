math.randomseed(os.time())

local module = {
    number = math.random
}

function module.item(x: {any})
    return x[math.random(1, #x)]
end

function module.pop(x: {any})
    return table.remove(x, math.random(1, #x))
end

return module