math.randomseed(os.time())

local module = {
    number = math.random
}

function module.item(x: {any})
    return x[math.random(1, #x)]
end

function module.pop(x: {any})
    if #x > 0 then
        return table.remove(x, math.random(1, #x))
    else
        return nil
    end
end

-- A deck can be grabbed from randomly,
-- not repeating until it runs out of all items
type Deck = {
    fresh: {any},
    used: {any},
    pop: () -> any
}
function module.deck(items: {any})
    local deck = {
        fresh = items,
        used = {}
    }
    deck.reset = function(self)
        self.fresh = self.used
        self.used = {}
    end
    deck.pop = function(self)
        if #self.fresh == 0 then
            return nil
        else
            local item = module.pop(self.fresh)
            table.insert(self.used, item)
            return item
        end
    end
    return deck
end

return module